// Astryl "community" Edge Function: the sky photo gallery and the questions-and-answers board,
// plus moderation.
//
// Photos and posts appear right away, and people can edit or delete their own. Anything reported comes to the moderators (rows in
// community_admins); after 3 reports it is hidden until a moderator keeps or removes it.
// Everything is tied to the account and is deleted with it. Photos are re-drawn in the browser
// before upload, so no camera or location data (EXIF) is sent.
//
// Deploy with "Verify JWT" switched OFF: the user's own token comes in x-astryl-token.
// GET ?action=img&id=…&size=thumb|full serves an approved photo.

import { createClient } from "npm:@supabase/supabase-js@2";
import config from "./config.json" with { type: "json" };

const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
  auth: { persistSession: false, autoRefreshToken: false },
});
const CORS: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-astryl-token",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
};
const CFG = config as { photoKinds: string[][]; postKinds: string[][] };
const PHOTO_KINDS = new Set(CFG.photoKinds.map((k) => k[0]));
const POST_KINDS = new Set(CFG.postKinds.map((k) => k[0]));
const REASONS = new Set(["rude", "spam", "personal", "offtopic", "other"]);
const MAX_FULL = 900_000, MAX_THUMB = 120_000;

class Fail extends Error {
  status: number;
  constructor(status: number, code: string) { super(code); this.status = status; }
}
function reply(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...CORS, "Content-Type": "application/json" } });
}
async function sha(s: string): Promise<string> {
  const d = await crypto.subtle.digest("SHA-256", new TextEncoder().encode("astryl-community:" + s));
  return Array.from(new Uint8Array(d)).slice(0, 16).map((b) => b.toString(16).padStart(2, "0")).join("");
}
async function userFrom(req: Request, required = true) {
  const token = req.headers.get("x-astryl-token") || "";
  if (!token) { if (required) throw new Fail(401, "no_token"); return null; }
  const { data, error } = await admin.auth.getUser(token);
  if (error || !data.user) { if (required) throw new Fail(401, "bad_token"); return null; }
  // only accounts made through the "account" function (they have a profile) may take part
  const { data: prof } = await admin.from("profiles").select("id").eq("id", data.user.id).maybeSingle();
  if (!prof) { if (required) throw new Fail(401, "no_profile"); return null; }
  return data.user;
}
async function isAdmin(uid: string) {
  const { data } = await admin.from("community_admins").select("user_id").eq("user_id", uid).maybeSingle();
  return !!data;
}
async function mustAdmin(req: Request) {
  const u = await userFrom(req);
  if (!(await isAdmin(u!.id))) throw new Fail(403, "not_admin");
  return u!;
}
/** Rate limit: at most n rows in a table for this user since a time. */
async function countSince(table: string, uid: string, sinceIso: string) {
  const { count } = await admin.from(table).select("id", { count: "exact", head: true }).eq("user_id", uid).gte("created_at", sinceIso);
  return count ?? 0;
}
function b64(bytes: Uint8Array) {
  let s = ""; for (let i = 0; i < bytes.length; i += 0x8000) s += String.fromCharCode(...bytes.subarray(i, i + 0x8000));
  return btoa(s);
}
function unb64(s: string) {
  const bin = atob(s); const out = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
  return out;
}
function hexToBytes(x: string) { // bytea comes back as \x…
  const h = x.startsWith("\\x") ? x.slice(2) : x; const out = new Uint8Array(h.length / 2);
  for (let i = 0; i < out.length; i++) out[i] = parseInt(h.substr(i * 2, 2), 16);
  return out;
}
function bytesToHex(b: Uint8Array) { return "\\x" + Array.from(b).map((v) => v.toString(16).padStart(2, "0")).join(""); }
function isJpeg(b: Uint8Array) { return b.length > 4 && b[0] === 0xff && b[1] === 0xd8 && b[2] === 0xff; }
async function names(ids: string[]) {
  const uniq = [...new Set(ids)]; if (!uniq.length) return {} as Record<string, string>;
  const { data } = await admin.from("profiles").select("id, username").in("id", uniq);
  return Object.fromEntries((data ?? []).map((p) => [p.id, p.username]));
}
/** Text that may be shown to everybody. */
function cleanText(s: unknown, min: number, max: number) {
  const t = String(s ?? "").replace(/[\u0000-\u0008\u000b-\u001f\u007f]/g, "").replace(/\s+\n/g, "\n").trim();
  if (t.length < min) throw new Fail(400, "too_short");
  if (t.length > max) throw new Fail(400, "too_long");
  if (/(https?:\/\/|www\.|\.(com|net|org|in|ru|xyz|io|me)\b)/i.test(t)) throw new Fail(400, "no_links");
  if (/(\+?\d[\d\s-]{8,}\d)|([\w.]+@[\w-]+\.)/.test(t)) throw new Fail(400, "no_contacts");
  return t;
}

// deno-lint-ignore no-explicit-any
async function handle(req: Request, b: any): Promise<Response> {
  const action = String(b.action ?? "");
  switch (action) {
    case "home": {
      const user = await userFrom(req, false);
      const count = async (t: string, top?: boolean) => {
        let q = admin.from(t).select("id", { count: "exact", head: true }).eq("status", "approved");
        if (top === true) q = q.is("parent_id", null); else if (top === false) q = q.not("parent_id", "is", null);
        const { count: c } = await q; return c ?? 0;
      };
      const [photos, questions, answers] = await Promise.all([count("community_photos"), count("community_posts", true), count("community_posts", false)]);
      return reply({ admin: user ? await isAdmin(user.id) : false, numbers: { photos, questions, answers } });
    }

    case "photos": {
      const user = await userFrom(req, false);
      const { data } = await admin.from("community_photos").select("id, user_id, title, kind, taken, w, h, stars, created_at, edited_at")
        .eq("status", "approved").order("created_at", { ascending: false }).limit(60);
      const nm = await names((data ?? []).map((p) => p.user_id));
      let starred: string[] = [];
      if (user && data?.length) {
        const { data: st } = await admin.from("photo_stars").select("photo_id").eq("user_id", user.id).in("photo_id", data.map((p) => p.id));
        starred = (st ?? []).map((s) => s.photo_id);
      }
      let pending = 0;
      if (user) { const { count } = await admin.from("community_photos").select("id", { count: "exact", head: true }).eq("user_id", user.id).eq("status", "pending"); pending = count ?? 0; }
      return reply({ photos: (data ?? []).map((p) => ({ id: p.id, by: nm[p.user_id] ?? "", title: p.title, kind: p.kind, taken: p.taken, w: p.w, h: p.h, stars: p.stars, at: p.created_at, edited: !!p.edited_at, mine: user?.id === p.user_id, starred: starred.includes(p.id) })), pending });
    }

    case "upload": {
      const user = (await userFrom(req))!;
      if (b.own !== true) throw new Fail(400, "must_be_own");
      const title = cleanText(b.title, 3, 80);
      const kind = String(b.kind ?? ""); if (!PHOTO_KINDS.has(kind)) throw new Fail(400, "bad_kind");
      const taken = b.taken ? cleanText(b.taken, 2, 60) : null;
      const full = unb64(String(b.full ?? "")), thumb = unb64(String(b.thumb ?? ""));
      if (!isJpeg(full) || !isJpeg(thumb)) throw new Fail(400, "not_jpeg");
      if (full.length > MAX_FULL || thumb.length > MAX_THUMB) throw new Fail(413, "too_big");
      const since = new Date(Date.now() - 86400000).toISOString();
      if ((await countSince("community_photos", user.id, since)) >= 3) throw new Fail(429, "photo_limit");
      const w = Math.min(4000, Math.max(1, Number(b.w) | 0)), h = Math.min(4000, Math.max(1, Number(b.h) | 0));
      const ins = await admin.from("community_photos").insert({ user_id: user.id, title, kind, taken, w, h, img: bytesToHex(full), thumb: bytesToHex(thumb), status: "approved" }).select("id").single();
      if (ins.error) throw new Fail(500, "upload_failed");
      return reply({ ok: true, id: ins.data.id });
    }

    case "star": {
      const user = (await userFrom(req))!;
      const id = String(b.id ?? "");
      const { data: p } = await admin.from("community_photos").select("id, stars").eq("id", id).eq("status", "approved").maybeSingle();
      if (!p) throw new Fail(404, "no_photo");
      const del = await admin.from("photo_stars").delete().eq("photo_id", id).eq("user_id", user.id).select("photo_id");
      let on = false;
      if (!del.data?.length) { await admin.from("photo_stars").insert({ photo_id: id, user_id: user.id }); on = true; }
      const { count } = await admin.from("photo_stars").select("photo_id", { count: "exact", head: true }).eq("photo_id", id);
      await admin.from("community_photos").update({ stars: count ?? 0 }).eq("id", id);
      return reply({ on, stars: count ?? 0 });
    }

    case "report": {
      const kind = String(b.kind ?? ""); const id = String(b.id ?? "");
      if (kind !== "photo" && kind !== "post") throw new Fail(400, "bad_kind");
      const user = await userFrom(req, false);
      const device = String(b.device ?? "").slice(0, 64);
      if (!user && device.length < 16) throw new Fail(400, "no_device");
      const voter = await sha(user ? "u:" + user.id : "d:" + device);
      const reason = REASONS.has(String(b.reason ?? "")) ? String(b.reason) : "other";
      const table = kind === "photo" ? "community_photos" : "community_posts";
      const { data: t } = await admin.from(table).select("id, reports").eq("id", id).maybeSingle();
      if (!t) throw new Fail(404, "not_found");
      const { error } = await admin.from("community_reports").insert({ kind, target: id, voter, reason });
      // three reports hide it until a moderator has looked
      if (!error) { const n = (t.reports ?? 0) + 1; await admin.from(table).update(n >= 3 ? { reports: n, status: "pending" } : { reports: n }).eq("id", id); }
      return reply({ ok: true });
    }

    case "posts": {
      const user = await userFrom(req, false);
      const { data } = await admin.from("community_posts").select("id, user_id, parent_id, kind, body, created_at, edited_at").eq("status", "approved")
        .order("created_at", { ascending: false }).limit(200);
      const nm = await names((data ?? []).map((p) => p.user_id));
      const all = (data ?? []).map((p) => ({ id: p.id, parent: p.parent_id, kind: p.kind, body: p.body, by: nm[p.user_id] ?? "", at: p.created_at, edited: !!p.edited_at, mine: user?.id === p.user_id }));
      const top = all.filter((p) => !p.parent).slice(0, 50).map((p) => ({ ...p, replies: all.filter((r) => r.parent === p.id).reverse() }));
      let pending = 0;
      if (user) { const { count } = await admin.from("community_posts").select("id", { count: "exact", head: true }).eq("user_id", user.id).eq("status", "pending"); pending = count ?? 0; }
      return reply({ posts: top, pending });
    }

    case "post": {
      const user = (await userFrom(req))!;
      const parent = b.parent ? String(b.parent) : null;
      let kind = String(b.kind ?? "question");
      if (parent) {
        const { data: p } = await admin.from("community_posts").select("id, parent_id").eq("id", parent).eq("status", "approved").maybeSingle();
        if (!p || p.parent_id) throw new Fail(404, "no_post");
        kind = "reply";
      } else if (!POST_KINDS.has(kind)) throw new Fail(400, "bad_kind");
      const body = cleanText(b.body, 3, 600);
      const since = new Date(Date.now() - 86400000).toISOString();
      if ((await countSince("community_posts", user.id, since)) >= 10) throw new Fail(429, "post_limit");
      const ins = await admin.from("community_posts").insert({ user_id: user.id, parent_id: parent, kind, body, status: "approved" }).select("id").single();
      if (ins.error) throw new Fail(500, "post_failed");
      return reply({ ok: true });
    }

    case "edit": {
      // people may change their own photo title or post text; the same rules as for new ones apply
      const user = (await userFrom(req))!;
      const kind = String(b.kind ?? ""), id = String(b.id ?? "");
      const table = kind === "photo" ? "community_photos" : kind === "post" ? "community_posts" : "";
      if (!table) throw new Fail(400, "bad_kind");
      const { data: row } = await admin.from(table).select("id").eq("id", id).eq("user_id", user.id).maybeSingle();
      if (!row) throw new Fail(404, "not_found");
      const since = new Date(Date.now() - 86400000).toISOString();
      if ((await countSince("community_edits", user.id, since)) >= 20) throw new Fail(429, "edit_limit");
      const now = new Date().toISOString();
      // status and reports stay as they are: an item hidden after reports stays hidden
      const change = kind === "photo"
        ? { title: cleanText(b.title, 3, 80), taken: b.taken ? cleanText(b.taken, 2, 60) : null, edited_at: now }
        : { body: cleanText(b.body, 3, 600), edited_at: now };
      const up = await admin.from(table).update(change).eq("id", id).eq("user_id", user.id);
      if (up.error) throw new Fail(500, "edit_failed");
      await admin.from("community_edits").insert({ user_id: user.id });
      return reply({ ok: true });
    }

    case "mine_delete": {
      // people can always remove their own photo or post
      const user = (await userFrom(req))!;
      const kind = String(b.kind ?? ""), id = String(b.id ?? "");
      const table = kind === "photo" ? "community_photos" : kind === "post" ? "community_posts" : "";
      if (!table) throw new Fail(400, "bad_kind");
      await admin.from(table).delete().eq("id", id).eq("user_id", user.id);
      return reply({ ok: true });
    }

    /* ---------- moderation ---------- */
    case "admin_queue": {
      await mustAdmin(req);
      const { data: ph } = await admin.from("community_photos").select("id, user_id, title, kind, taken, status, reports, created_at, thumb")
        .or("status.eq.pending,reports.gt.0").order("created_at").limit(40);
      const { data: po } = await admin.from("community_posts").select("id, user_id, parent_id, kind, body, status, reports, created_at")
        .or("status.eq.pending,reports.gt.0").order("created_at").limit(100);
      const parents = (po ?? []).filter((p) => p.parent_id).map((p) => p.parent_id);
      const { data: par } = parents.length ? await admin.from("community_posts").select("id, body").in("id", parents) : { data: [] };
      const pb = Object.fromEntries((par ?? []).map((p) => [p.id, p.body]));
      const nm = await names([...(ph ?? []).map((p) => p.user_id), ...(po ?? []).map((p) => p.user_id)]);
      const ids = [...(ph ?? []).map((p) => p.id), ...(po ?? []).map((p) => p.id)];
      const { data: rs } = ids.length ? await admin.from("community_reports").select("target, reason").in("target", ids) : { data: [] };
      const why: Record<string, Record<string, number>> = {};
      for (const r of rs ?? []) { const w = (why[r.target] ??= {}); w[r.reason || "other"] = (w[r.reason || "other"] ?? 0) + 1; }
      return reply({
        photos: (ph ?? []).map((p) => ({ id: p.id, by: nm[p.user_id] ?? "", title: p.title, kind: p.kind, taken: p.taken, status: p.status, reports: p.reports, why: why[p.id] ?? {}, at: p.created_at, thumb: b64(hexToBytes(p.thumb as unknown as string)) })),
        posts: (po ?? []).map((p) => ({ id: p.id, by: nm[p.user_id] ?? "", kind: p.kind, body: p.body, status: p.status, reports: p.reports, why: why[p.id] ?? {}, at: p.created_at, replyTo: p.parent_id ? pb[p.parent_id] ?? "" : null })),
      });
    }

    case "admin_photo": {
      await mustAdmin(req);
      const { data } = await admin.from("community_photos").select("img").eq("id", String(b.id ?? "")).maybeSingle();
      if (!data) throw new Fail(404, "no_photo");
      return reply({ full: b64(hexToBytes(data.img as unknown as string)) });
    }

    case "admin_decide": {
      await mustAdmin(req);
      const kind = String(b.kind ?? ""), id = String(b.id ?? ""), verdict = String(b.verdict ?? "");
      const table = kind === "photo" ? "community_photos" : kind === "post" ? "community_posts" : "";
      if (!table) throw new Fail(400, "bad_kind");
      if (verdict === "approve") {
        await admin.from(table).update({ status: "approved", reports: 0, decided_at: new Date().toISOString() }).eq("id", id);
        await admin.from("community_reports").delete().eq("kind", kind).eq("target", id);
      } else if (verdict === "remove") {
        await admin.from(table).delete().eq("id", id);
        await admin.from("community_reports").delete().eq("kind", kind).eq("target", id);
      } else throw new Fail(400, "bad_verdict");
      return reply({ ok: true });
    }

    default:
      throw new Fail(400, "unknown_action");
  }
}

async function image(url: URL): Promise<Response> {
  const id = url.searchParams.get("id") ?? "", full = url.searchParams.get("size") === "full";
  if (!/^[0-9a-f-]{36}$/.test(id)) return new Response("not found", { status: 404, headers: CORS });
  const { data } = await admin.from("community_photos").select(full ? "img" : "thumb").eq("id", id).eq("status", "approved").maybeSingle();
  if (!data) return new Response("not found", { status: 404, headers: CORS });
  // deno-lint-ignore no-explicit-any
  const bytes = hexToBytes((data as any)[full ? "img" : "thumb"]);
  return new Response(bytes, { headers: { ...CORS, "Content-Type": "image/jpeg", "Cache-Control": "public, max-age=3600" } });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  try {
    const url = new URL(req.url);
    if (req.method === "GET" && url.searchParams.get("action") === "img") return await image(url);
    if (req.method !== "POST") throw new Fail(405, "bad_method");
    const text = await req.text();
    if (text.length > 1_500_000) throw new Fail(413, "too_big");
    let body: unknown = {};
    try { body = text ? JSON.parse(text) : {}; } catch { throw new Fail(400, "bad_json"); }
    return await handle(req, body);
  } catch (e) {
    if (e instanceof Fail) return reply({ error: e.message }, e.status);
    console.error(e);
    return reply({ error: "server_error" }, 500);
  }
});
