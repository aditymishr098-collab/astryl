// Astryl "daily" Edge Function: public, read-only data for the app and website.
//
//   GET ?what=tle&sat=iss|css|hst  orbit data (TLE) of a satellite
//   GET ?what=apod                 NASA's Astronomy Picture of the Day (science.nasa.gov RSS)
//
// Answers are cached in the feed_cache table, so the outside services are asked
// at most every few hours, however many people open the page. Nothing about
// the caller is stored. Deploy with "Verify JWT" switched OFF (no login needed).

import { createClient } from "npm:@supabase/supabase-js@2";

const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
  auth: { persistSession: false, autoRefreshToken: false },
});
const UA = "Astryl (github.com/aditymishr098-collab/astryl)";

const CORS: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
};

const SATS: Record<string, string> = { iss: "25544", css: "48274", hst: "20580" };
const HOUR = 3600 * 1000;

function reply(body: unknown, status = 200, maxAge = 600) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, "Content-Type": "application/json", "Cache-Control": `public, max-age=${maxAge}` },
  });
}

async function getText(url: string, max = 200000): Promise<string> {
  const r = await fetch(url, { headers: { "User-Agent": UA }, signal: AbortSignal.timeout(12000) });
  if (!r.ok) throw new Error(`upstream ${r.status}`);
  const t = await r.text();
  if (t.length > max) throw new Error("too big");
  return t;
}

async function cached(key: string): Promise<{ body: Record<string, unknown>; age: number } | null> {
  const { data } = await admin.from("feed_cache").select("body, fetched_at").eq("key", key).maybeSingle();
  if (!data) return null;
  return { body: data.body, age: Date.now() - Date.parse(data.fetched_at) };
}

async function save(key: string, body: Record<string, unknown>) {
  const { error } = await admin.from("feed_cache").upsert({ key, body, fetched_at: new Date().toISOString() });
  if (error) console.error("cache", key, error.message);
}

function checkTle(name: string, l1: string, l2: string, norad: string) {
  l1 = l1.trimEnd();
  l2 = l2.trimEnd();
  if (l1.length < 69 || l2.length < 69 || !l1.startsWith("1 ") || !l2.startsWith("2 ")) throw new Error("not a TLE");
  if (l1.substring(2, 7).trim() !== norad || l2.substring(2, 7).trim() !== norad) throw new Error("wrong satellite");
  return { name: name.trim() || norad, line1: l1, line2: l2 };
}

async function freshTle(sat: string) {
  const norad = SATS[sat];
  if (sat === "iss") {
    try {
      const j = JSON.parse(await getText("https://api.wheretheiss.at/v1/satellites/25544/tles"));
      return checkTle("ISS (ZARYA)", String(j.line1 ?? ""), String(j.line2 ?? ""), norad);
    } catch (_) { /* try Celestrak below */ }
  }
  const lines = (await getText(`https://celestrak.org/NORAD/elements/gp.php?CATNR=${norad}&FORMAT=TLE`))
    .split(/\r?\n/).filter((l) => l.trim());
  if (lines.length < 3) throw new Error("no TLE");
  return checkTle(lines[0], lines[1], lines[2], norad);
}

const NASA_IMG = /^https:\/\/(apod\.nasa\.gov|assets\.science\.nasa\.gov)\//;
const NASA_PAGE = /^https:\/\/(apod\.nasa\.gov|science\.nasa\.gov)\//;
const MONTHS = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"];

function decode(s: string): string {
  return s.replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1")
    .replace(/&#0?38;|&amp;/g, "&").replace(/&quot;|&#0?34;/g, '"').replace(/&#0?39;|&apos;|&#8217;/g, "'")
    .replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&nbsp;/g, " ");
}

function plain(html: string): string {
  return decode(html).replace(/<br\s*\/?>/gi, " ").replace(/<[^>]+>/g, "").replace(/\s+/g, " ")
    .replace(/\s+([.,;:!?)])/g, "$1").trim();
}

function tag(item: string, name: string): string {
  const m = item.match(new RegExp(`<${name}>([\\s\\S]*?)<\\/${name}>`));
  return m ? m[1].trim() : "";
}

// NASA moved APOD to science.nasa.gov in 2026; its RSS feed carries today's picture first.
async function freshApod() {
  const xml = await getText("https://science.nasa.gov/feed/apod-basic/", 3_000_000);
  const item = (xml.match(/<item>([\s\S]*?)<\/item>/) || [])[1];
  if (!item) throw new Error("no APOD item");
  const page = decode(tag(item, "link"));
  const dm = page.match(/apod-(\d{4})-([a-z]+)-(\d{1,2})-/);
  let date = "";
  if (dm && MONTHS.includes(dm[2])) {
    date = `${dm[1]}-${String(MONTHS.indexOf(dm[2]) + 1).padStart(2, "0")}-${dm[3].padStart(2, "0")}`;
  } else {
    const t = Date.parse(tag(item, "pubDate"));
    if (!Number.isFinite(t)) throw new Error("no date");
    date = new Date(t - 5 * 3600 * 1000).toISOString().slice(0, 10); // US Eastern day
  }
  const title = plain(tag(item, "title"));
  const hd = decode(tag(item, "apod:hdurl"));
  const isImage = NASA_IMG.test(hd) && !/\.(mp4|webm|mov)(\?|$)/i.test(hd);
  // A smaller copy for the card: NASA's image service scales on request.
  const url = isImage && hd.includes("/dynamicimage/") ? hd.replace(/\?.*$/, "") + "?w=1280&h=1280&fit=clip" : (isImage ? hd : "");
  const explanation = plain(tag(item, "apod:explanation") || tag(item, "description"))
    .replace(/^Explanation:\s*/i, "").replace(/\s*Tomorrow['’]s picture:.*$/s, "").trim();
  if (!/^\d{4}-\d{2}-\d{2}$/.test(date) || !title) throw new Error("bad APOD");
  return {
    date,
    title: title.slice(0, 200),
    explanation,
    media: isImage ? "image" : "other",
    url,
    hdurl: isImage ? hd : "",
    copyright: plain(tag(item, "apod:copyright") || tag(item, "apod:credit")).slice(0, 200),
    page: NASA_PAGE.test(page) ? page : "https://science.nasa.gov/apod/",
  };
}

async function serve(key: string, maxAgeMs: number, make: () => Promise<Record<string, unknown>>) {
  const old = await cached(key);
  if (old && old.age < maxAgeMs) return reply({ ...old.body, fetchedMs: Date.now() - old.age });
  try {
    const body = await make();
    await save(key, body);
    return reply({ ...body, fetchedMs: Date.now() });
  } catch (e) {
    console.error(key, String(e));
    if (old) return reply({ ...old.body, fetchedMs: Date.now() - old.age, stale: true }, 200, 120);
    return reply({ error: "unavailable" }, 503, 60);
  }
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "GET") return reply({ error: "method" }, 405, 0);
  const u = new URL(req.url);
  const what = u.searchParams.get("what");
  if (what === "tle") {
    const sat = u.searchParams.get("sat") || "iss";
    if (!SATS[sat]) return reply({ error: "bad_sat" }, 400);
    return await serve(`tle:${sat}`, 4 * HOUR, () => freshTle(sat));
  }
  if (what === "apod") return await serve("apod", 2 * HOUR, freshApod);
  return reply({ error: "bad_request" }, 400);
});
