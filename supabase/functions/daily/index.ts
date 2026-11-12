// Astryl "daily" Edge Function: public, read-only data for the app and website.
//
//   GET ?what=tle&sat=iss|css|hst  orbit data (TLE) of a satellite
//   GET ?what=apod                 NASA's Astronomy Picture of the Day
//
// Answers are cached in the feed_cache table, so the outside services are asked
// at most every few hours, however many people open the page. Nothing about
// the caller is stored. Deploy with "Verify JWT" switched OFF (no login needed).

import { createClient } from "npm:@supabase/supabase-js@2";

const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
  auth: { persistSession: false, autoRefreshToken: false },
});
const NASA_KEY = Deno.env.get("NASA_API_KEY") || "DEMO_KEY";
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

async function getText(url: string): Promise<string> {
  const r = await fetch(url, { headers: { "User-Agent": UA }, signal: AbortSignal.timeout(12000) });
  if (!r.ok) throw new Error(`upstream ${r.status}`);
  const t = await r.text();
  if (t.length > 200000) throw new Error("too big");
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

const MONTHS = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"];
const NASA_IMG = /^https:\/\/apod\.nasa\.gov\//;

function apodBody(date: string, title: string, explanation: string, isImage: boolean, url: string, hdurl: string, copyright: string) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(date) || !title) throw new Error("bad APOD");
  return {
    date,
    title: title.replace(/\s+/g, " ").trim(),
    explanation: explanation.replace(/\s*Tomorrow['’]s picture:.*$/s, "").replace(/\s+/g, " ").trim(),
    media: isImage ? "image" : "other",
    // Only pictures from NASA's own server are passed on (no video sites).
    url: isImage && NASA_IMG.test(url) ? url : "",
    hdurl: isImage && NASA_IMG.test(hdurl) ? hdurl : "",
    copyright: copyright.replace(/\s+/g, " ").replace(/^Image Credit[^:]*:\s*/i, "").trim().slice(0, 200),
    page: `https://apod.nasa.gov/apod/ap${date.slice(2, 4)}${date.slice(5, 7)}${date.slice(8, 10)}.html`,
  };
}

// NASA's API (api.nasa.gov) first; it fails now and then, so NASA's own page is read when it does.
async function freshApod() {
  try {
    const j = JSON.parse(await getText(`https://api.nasa.gov/planetary/apod?api_key=${encodeURIComponent(NASA_KEY)}`));
    const str = (v: unknown) => (typeof v === "string" ? v : "");
    return apodBody(str(j.date), str(j.title), str(j.explanation), j.media_type === "image", str(j.url), str(j.hdurl), str(j.copyright));
  } catch (e) {
    console.error("apod api", String(e));
  }
  const html = await getText("https://apod.nasa.gov/apod/astropix.html");
  const text = (h: string) => h.replace(/<[^>]+>/g, "").replace(/&amp;/g, "&").replace(/&quot;/g, '"').replace(/&#39;|&apos;/g, "'").replace(/&nbsp;/g, " ").replace(/\s+/g, " ").replace(/\s+([.,;:!?)])/g, "$1").trim();
  const dm = html.match(/(\d{4})\s+(January|February|March|April|May|June|July|August|September|October|November|December)\s+(\d{1,2})/i);
  if (!dm) throw new Error("no date");
  const date = `${dm[1]}-${String(MONTHS.indexOf(dm[2].toLowerCase()) + 1).padStart(2, "0")}-${dm[3].padStart(2, "0")}`;
  const tm = html.match(/<center>\s*<b>([\s\S]*?)<\/b>/i);
  const em = html.match(/Explanation:\s*<\/b>([\s\S]*?)(<p>\s*<center>|<center>|$)/i);
  const im = html.match(/<img[^>]+src="([^"]+)"/i);
  const hm = html.match(/<a\s+href="(image\/[^"]+)"/i);
  const cm = html.match(/(Image Credit[\s\S]*?)<\/center>/i);
  const abs = (u: string | undefined) => (u ? new URL(u, "https://apod.nasa.gov/apod/").href : "");
  return apodBody(date, tm ? text(tm[1]) : "", em ? text(em[1]) : "", !!im, abs(im?.[1]), abs(hm?.[1]), cm ? text(cm[1]) : "");
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
