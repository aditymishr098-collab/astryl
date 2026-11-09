// Astryl "account" Edge Function (v1.20.0)
//
// The one door between the app/website and the database. Accounts are made of
// a username and a password only (no e-mail). A recovery code that works 3
// times replaces "forgot password". The service role key stays inside this
// function; the app and the website only know the public (publishable) key.
//
// Deploy with "Verify JWT" switched OFF: the public key is not a JWT, and this
// function checks the user's own token itself (see userFrom).

import { createClient } from "npm:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const opts = { auth: { persistSession: false, autoRefreshToken: false } };
const admin = createClient(SUPABASE_URL, SERVICE_KEY, opts);
const fresh = () => createClient(SUPABASE_URL, SERVICE_KEY, opts);

const CORS: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-astryl-token",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
};

const CONSENT_VERSION = 1;
const MAX_DATA_CHARS = 60000;
// No I, L, O, 0 or 1: they are easy to mix up when a code is written down.
const CODE_ALPHABET = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";

class Fail extends Error {
  status: number;
  constructor(status: number, code: string) {
    super(code);
    this.status = status;
  }
}

function reply(body: unknown, status = 200, extra: Record<string, string> = {}) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, "Content-Type": "application/json", ...extra },
  });
}

async function sha256Hex(text: string): Promise<string> {
  const bytes = new TextEncoder().encode(text);
  const hash = await crypto.subtle.digest("SHA-256", bytes);
  return Array.from(new Uint8Array(hash))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

function emailFor(username: string): string {
  return `${username}@users.astryl.space`;
}

function cleanUser(raw: unknown): string {
  const name = typeof raw === "string" ? raw.trim().toLowerCase() : "";
  if (!/^[a-z0-9_]{3,20}$/.test(name)) throw new Fail(400, "bad_username");
  return name;
}

function cleanPass(raw: unknown): string {
  if (typeof raw !== "string" || raw.length < 8 || raw.length > 72) {
    throw new Fail(400, "bad_password");
  }
  return raw;
}

function makeCode(): string {
  const out: string[] = [];
  const n = CODE_ALPHABET.length;
  const limit = 256 - (256 % n);
  while (out.length < 16) {
    const buf = new Uint8Array(32);
    crypto.getRandomValues(buf);
    for (const b of buf) {
      if (b < limit && out.length < 16) out.push(CODE_ALPHABET[b % n]);
    }
  }
  const s = out.join("");
  return `${s.slice(0, 4)}-${s.slice(4, 8)}-${s.slice(8, 12)}-${s.slice(12, 16)}`;
}

function normCode(raw: unknown): string {
  const s = typeof raw === "string" ? raw.toUpperCase() : "";
  return Array.from(s).filter((ch) => CODE_ALPHABET.includes(ch)).join("");
}

async function codeHash(code: string): Promise<string> {
  return await sha256Hex("astryl-recovery:" + normCode(code));
}

function clientIp(req: Request): string {
  const f = req.headers.get("x-forwarded-for") || "";
  return f.split(",")[0].trim() || "unknown";
}

/** Counts a try under [key] and refuses when there were too many. */
async function hit(key: string, max: number, windowSec: number) {
  const k = await sha256Hex("astryl-rate:" + key);
  const { data } = await admin.from("rate").select("n, since").eq("k", k).maybeSingle();
  const now = Date.now();
  if (!data || now - new Date(data.since).getTime() > windowSec * 1000) {
    await admin.from("rate").upsert({ k, n: 1, since: new Date(now).toISOString() });
    return;
  }
  if (data.n >= max) throw new Fail(429, "rate_limited");
  await admin.from("rate").update({ n: data.n + 1 }).eq("k", k);
}

// deno-lint-ignore no-explicit-any
function pack(session: any) {
  return {
    access_token: session.access_token,
    refresh_token: session.refresh_token,
    expires_at: session.expires_at ?? Math.floor(Date.now() / 1000) + 3000,
    user_id: session.user?.id ?? "",
  };
}

async function signIn(username: string, password: string) {
  const { data, error } = await fresh().auth.signInWithPassword({
    email: emailFor(username),
    password,
  });
  if (error || !data.session) throw new Fail(401, "bad_login");
  return pack({ ...data.session, user: data.user });
}

async function userFrom(req: Request) {
  const token = req.headers.get("x-astryl-token") || "";
  if (!token) throw new Fail(401, "no_token");
  const { data, error } = await admin.auth.getUser(token);
  if (error || !data.user) throw new Fail(401, "bad_token");
  return data.user;
}

function bool(v: unknown): boolean {
  return v === true;
}

function cleanCountry(v: unknown): string | null {
  return typeof v === "string" && /^[A-Za-z]{2}$/.test(v) ? v.toUpperCase() : null;
}

// deno-lint-ignore no-explicit-any
async function handle(req: Request, b: any): Promise<Response> {
  const action = String(b.action ?? "");
  const ip = clientIp(req);

  switch (action) {
    case "stats": {
      const { data, error } = await admin.rpc("astryl_stats");
      if (error) throw new Fail(500, "stats_failed");
      return reply(data, 200, { "Cache-Control": "public, max-age=300" });
    }

    case "crash": {
      // Anonymous crash report from the app. Sizes are cut, and one address
      // can only send a limited number per hour.
      await hit("crash:" + ip, 30, 3600);
      const message = String(b.message ?? "").slice(0, 400);
      if (!message) throw new Fail(400, "bad_report");
      const { error } = await admin.from("crashes").insert({
        app_version: String(b.version ?? "").slice(0, 30),
        os: String(b.os ?? "").slice(0, 120),
        locale: String(b.locale ?? "").slice(0, 12),
        message,
        stack: String(b.stack ?? "").slice(0, 3000),
      });
      if (error) throw new Fail(500, "crash_failed");
      // Reports are kept for 90 days; tidy up now and then.
      if (Math.random() < 0.02) {
        await admin.from("crashes").delete().lt(
          "created_at",
          new Date(Date.now() - 90 * 86400000).toISOString(),
        );
      }
      return reply({ ok: true });
    }

    case "visit": {
      // One page view of astryl.space. Only counted, never tied to a person:
      // no IP address, no cookie, no id, no time of day is stored.
      await hit("visit:" + ip, 200, 3600);
      const page = String(b.page ?? "").toLowerCase();
      if (!/^[a-z0-9\/_.-]{1,60}$/.test(page)) throw new Fail(400, "bad_page");
      const lang = b.lang === "hi" ? "hi" : "en";
      const device = ["s", "m", "l"].includes(String(b.device)) ? String(b.device) : "";
      const ref = /^[a-z0-9.-]{1,80}$/.test(String(b.ref ?? "")) ? String(b.ref) : "";
      // The country comes from the request's edge location when it has one.
      const country = cleanCountry(req.headers.get("cf-ipcountry")) ?? "";
      const { error } = await admin.rpc("astryl_visit", {
        p_page: page,
        p_lang: lang,
        p_device: device,
        p_ref: ref,
        p_country: country,
      });
      if (error) throw new Fail(500, "visit_failed");
      return reply({ ok: true });
    }

    case "ping": {
      const device = String(b.device ?? "");
      if (!/^[A-Za-z0-9-]{8,64}$/.test(device)) throw new Fail(400, "bad_device");
      await hit("ping:" + device, 40, 3600);
      const { error } = await admin.rpc("astryl_ping", {
        p_device: device,
        p_country: cleanCountry(b.country),
      });
      if (error) throw new Fail(500, "ping_failed");
      return reply({ ok: true });
    }

    case "check": {
      const username = cleanUser(b.username);
      await hit("check:" + ip, 60, 3600);
      const { data } = await admin.from("profiles").select("id").eq("username", username).maybeSingle();
      return reply({ available: !data });
    }

    case "signup": {
      const username = cleanUser(b.username);
      const password = cleanPass(b.password);
      if (b.consent !== true) throw new Fail(400, "consent_required");
      await hit("signup:" + ip, 5, 3600);
      const taken = await admin.from("profiles").select("id").eq("username", username).maybeSingle();
      if (taken.data) throw new Fail(409, "username_taken");
      const created = await admin.auth.admin.createUser({
        email: emailFor(username),
        password,
        email_confirm: true,
        user_metadata: { username },
      });
      if (created.error || !created.data.user) {
        if (/already|registered|exists/i.test(created.error?.message ?? "")) {
          throw new Fail(409, "username_taken");
        }
        throw new Fail(500, "create_failed");
      }
      const id = created.data.user.id;
      const shareCountry = bool(b.shareCountry);
      const shareLocation = bool(b.shareLocation);
      const ins = await admin.from("profiles").insert({
        id,
        username,
        consent_version: CONSENT_VERSION,
        count_me: bool(b.countMe),
        share_country: shareCountry,
        share_location: shareLocation,
        country: shareCountry ? cleanCountry(b.country) : null,
      });
      if (ins.error) {
        await admin.auth.admin.deleteUser(id);
        throw new Fail(ins.error.code === "23505" ? 409 : 500, ins.error.code === "23505" ? "username_taken" : "create_failed");
      }
      const code = makeCode();
      await admin.from("recovery").insert({
        user_id: id,
        code_hash: await codeHash(code),
        uses_left: 3,
      });
      const session = await signIn(username, password);
      return reply({ session, username, code });
    }

    case "login": {
      const username = cleanUser(b.username);
      const password = typeof b.password === "string" ? b.password : "";
      await hit("login:" + username, 10, 900);
      await hit("login-ip:" + ip, 60, 900);
      const session = await signIn(username, password);
      await admin.from("profiles").update({ last_seen: new Date().toISOString() }).eq("username", username);
      return reply({ session, username });
    }

    case "refresh": {
      const rt = typeof b.refresh_token === "string" ? b.refresh_token : "";
      if (!rt) throw new Fail(401, "no_token");
      const { data, error } = await fresh().auth.refreshSession({ refresh_token: rt });
      if (error || !data.session) throw new Fail(401, "bad_token");
      return reply({ session: pack({ ...data.session, user: data.user }) });
    }

    case "recover": {
      const username = cleanUser(b.username);
      const password = cleanPass(b.password);
      const code = normCode(b.code);
      await hit("recover-ip:" + ip, 20, 3600);
      const prof = await admin.from("profiles").select("id").eq("username", username).maybeSingle();
      if (!prof.data || code.length !== 16) throw new Fail(401, "bad_recovery");
      const id: string = prof.data.id;
      const rec = await admin.from("recovery").select("*").eq("user_id", id).maybeSingle();
      if (!rec.data) throw new Fail(401, "bad_recovery");
      if (rec.data.locked_until && new Date(rec.data.locked_until) > new Date()) {
        throw new Fail(429, "locked");
      }
      if ((await codeHash(code)) !== rec.data.code_hash) {
        const failed = (rec.data.failed ?? 0) + 1;
        const lock = failed >= 5;
        await admin.from("recovery").update({
          failed: lock ? 0 : failed,
          locked_until: lock ? new Date(Date.now() + 15 * 60 * 1000).toISOString() : null,
        }).eq("user_id", id);
        throw new Fail(401, "bad_recovery");
      }
      if (rec.data.uses_left <= 0) throw new Fail(401, "code_used_up");
      const upd = await admin.auth.admin.updateUserById(id, { password });
      if (upd.error) throw new Fail(500, "update_failed");
      const left = rec.data.uses_left - 1;
      await admin.from("recovery").update({ uses_left: left, failed: 0, locked_until: null }).eq("user_id", id);
      const session = await signIn(username, password);
      return reply({ session, username, usesLeft: left });
    }

    case "newcode": {
      const user = await userFrom(req);
      const code = makeCode();
      const { error } = await admin.from("recovery").upsert({
        user_id: user.id,
        code_hash: await codeHash(code),
        uses_left: 3,
        failed: 0,
        locked_until: null,
      });
      if (error) throw new Fail(500, "code_failed");
      return reply({ code });
    }

    case "pull": {
      const user = await userFrom(req);
      const [d, p] = await Promise.all([
        admin.from("user_data").select("data, updated_at").eq("user_id", user.id).maybeSingle(),
        admin.from("profiles").select("username, count_me, share_country, share_location").eq("id", user.id).maybeSingle(),
      ]);
      if (!p.data) throw new Fail(404, "no_profile");
      await admin.from("profiles").update({ last_seen: new Date().toISOString() }).eq("id", user.id);
      return reply({
        data: d.data ? d.data.data : null,
        updatedMs: d.data ? new Date(d.data.updated_at).getTime() : 0,
        username: p.data.username,
        prefs: {
          countMe: p.data.count_me,
          shareCountry: p.data.share_country,
          shareLocation: p.data.share_location,
        },
      });
    }

    case "push": {
      const user = await userFrom(req);
      const data = b.data;
      if (!data || typeof data !== "object" || Array.isArray(data)) throw new Fail(400, "bad_data");
      if (JSON.stringify(data).length > MAX_DATA_CHARS) throw new Fail(413, "too_big");
      const now = new Date();
      const { error } = await admin.from("user_data").upsert({
        user_id: user.id,
        data,
        updated_at: now.toISOString(),
      });
      if (error) throw new Fail(500, "push_failed");
      return reply({ updatedMs: now.getTime() });
    }

    case "prefs": {
      const user = await userFrom(req);
      const shareCountry = bool(b.shareCountry);
      const shareLocation = bool(b.shareLocation);
      const row: Record<string, unknown> = {
        count_me: bool(b.countMe),
        share_country: shareCountry,
        share_location: shareLocation,
        country: shareCountry ? cleanCountry(b.country) : null,
      };
      if (!shareLocation) {
        row.lat = null;
        row.lon = null;
        row.loc_at = null;
      }
      const { error } = await admin.from("profiles").update(row).eq("id", user.id);
      if (error) throw new Fail(500, "prefs_failed");
      return reply({ ok: true });
    }

    case "location": {
      const user = await userFrom(req);
      const lat = Number(b.lat);
      const lon = Number(b.lon);
      if (!Number.isFinite(lat) || !Number.isFinite(lon) || Math.abs(lat) > 90 || Math.abs(lon) > 180) {
        throw new Fail(400, "bad_location");
      }
      const prof = await admin.from("profiles").select("share_location").eq("id", user.id).maybeSingle();
      if (!prof.data || !prof.data.share_location) throw new Fail(403, "not_allowed");
      // About 10 km: one decimal of a degree. Nothing more exact is kept.
      const { error } = await admin.from("profiles").update({
        lat: Math.round(lat * 10) / 10,
        lon: Math.round(lon * 10) / 10,
        loc_at: new Date().toISOString(),
      }).eq("id", user.id);
      if (error) throw new Fail(500, "location_failed");
      return reply({ ok: true });
    }

    case "delete": {
      const user = await userFrom(req);
      const prof = await admin.from("profiles").select("username").eq("id", user.id).maybeSingle();
      const password = typeof b.password === "string" ? b.password : "";
      await hit("delete:" + user.id, 5, 900);
      if (prof.data) await signIn(prof.data.username, password);
      await admin.from("user_data").delete().eq("user_id", user.id);
      await admin.from("recovery").delete().eq("user_id", user.id);
      await admin.from("profiles").delete().eq("id", user.id);
      const { error } = await admin.auth.admin.deleteUser(user.id);
      if (error) throw new Fail(500, "delete_failed");
      return reply({ ok: true });
    }

    default:
      throw new Fail(400, "unknown_action");
  }
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  try {
    let body: Record<string, unknown> = {};
    if (req.method === "POST") {
      const text = await req.text();
      if (text.length > 100000) throw new Fail(413, "too_big");
      try {
        body = text ? JSON.parse(text) : {};
      } catch {
        throw new Fail(400, "bad_json");
      }
    } else if (req.method === "GET") {
      body = { action: new URL(req.url).searchParams.get("action") ?? "" };
    } else {
      throw new Fail(405, "bad_method");
    }
    return await handle(req, body);
  } catch (e) {
    if (e instanceof Fail) return reply({ error: e.message }, e.status);
    console.error(e);
    return reply({ error: "server_error" }, 500);
  }
});
