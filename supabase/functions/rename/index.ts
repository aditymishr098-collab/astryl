// Astryl "rename" Edge Function: lets a logged-in person change their username.
//
// The username is also the login name, so the change needs the current password, and it is
// allowed once every 30 days. Photos, posts and points stay with the account (they are tied to
// the account id, not the name).
//
// Deploy with "Verify JWT" switched OFF: the user's own token comes in x-astryl-token.

import { createClient } from "npm:@supabase/supabase-js@2";

const URL_ = Deno.env.get("SUPABASE_URL")!;
const admin = createClient(URL_, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, { auth: { persistSession: false, autoRefreshToken: false } });
const fresh = () => createClient(URL_, Deno.env.get("SUPABASE_ANON_KEY")!, { auth: { persistSession: false, autoRefreshToken: false } });
const CORS: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-astryl-token",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const WAIT_DAYS = 30;
const emailFor = (u: string) => `${u}@users.astryl.space`;

function reply(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...CORS, "Content-Type": "application/json" } });
}
async function sha(s: string) {
  const d = await crypto.subtle.digest("SHA-256", new TextEncoder().encode("astryl-rate:" + s));
  return Array.from(new Uint8Array(d)).map((b) => b.toString(16).padStart(2, "0")).join("");
}
/** At most max tries in a time window (the same "rate" table the account function uses). */
async function tooMany(key: string, max: number, windowSec: number) {
  const k = await sha(key), now = Date.now();
  const { data } = await admin.from("rate").select("n, since").eq("k", k).maybeSingle();
  if (!data || now - new Date(data.since).getTime() > windowSec * 1000) { await admin.from("rate").upsert({ k, n: 1, since: new Date(now).toISOString() }); return false; }
  if (data.n >= max) return true;
  await admin.from("rate").update({ n: data.n + 1 }).eq("k", k);
  return false;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return reply({ error: "bad_method" }, 405);
  try {
    const text = await req.text();
    if (text.length > 2000) return reply({ error: "too_big" }, 413);
    let b: Record<string, unknown> = {};
    try { b = JSON.parse(text || "{}"); } catch { return reply({ error: "bad_json" }, 400); }

    const token = req.headers.get("x-astryl-token") || "";
    if (!token) return reply({ error: "no_token" }, 401);
    const got = await admin.auth.getUser(token);
    const user = got.data?.user;
    if (got.error || !user) return reply({ error: "bad_token" }, 401);

    const name = typeof b.username === "string" ? b.username.trim().toLowerCase() : "";
    if (!/^[a-z0-9_]{3,20}$/.test(name)) return reply({ error: "bad_username" }, 400);
    const password = typeof b.password === "string" ? b.password : "";
    if (password.length < 8 || password.length > 200) return reply({ error: "bad_login" }, 401);

    const { data: prof } = await admin.from("profiles").select("username, username_changed_at").eq("id", user.id).maybeSingle();
    if (!prof) return reply({ error: "no_profile" }, 401);
    if (prof.username === name) return reply({ error: "same_username" }, 400);
    if (prof.username_changed_at) {
      const next = new Date(prof.username_changed_at).getTime() + WAIT_DAYS * 86_400_000;
      if (Date.now() < next) return reply({ error: "too_soon", next: new Date(next).toISOString() }, 429);
    }
    if (await tooMany("rename:" + user.id, 8, 3600)) return reply({ error: "rate_limited" }, 429);

    // the current password must be right
    const check = await fresh().auth.signInWithPassword({ email: emailFor(prof.username), password });
    if (check.error || !check.data.session) return reply({ error: "bad_login" }, 401);

    const { data: taken } = await admin.from("profiles").select("id").eq("username", name).maybeSingle();
    if (taken) return reply({ error: "username_taken" }, 409);

    const up = await admin.auth.admin.updateUserById(user.id, { email: emailFor(name), email_confirm: true, user_metadata: { ...(user.user_metadata ?? {}), username: name } });
    if (up.error) return reply({ error: /already|exists|registered/i.test(up.error.message) ? "username_taken" : "rename_failed" }, /already|exists|registered/i.test(up.error.message) ? 409 : 500);
    const pr = await admin.from("profiles").update({ username: name, username_changed_at: new Date().toISOString() }).eq("id", user.id);
    if (pr.error) {
      // put the login name back so the account never ends up half renamed
      await admin.auth.admin.updateUserById(user.id, { email: emailFor(prof.username), email_confirm: true, user_metadata: { ...(user.user_metadata ?? {}), username: prof.username } });
      return reply({ error: pr.error.code === "23505" ? "username_taken" : "rename_failed" }, pr.error.code === "23505" ? 409 : 500);
    }
    const again = await fresh().auth.signInWithPassword({ email: emailFor(name), password });
    const s = again.data?.session;
    return reply({
      username: name,
      session: s ? { access_token: s.access_token, refresh_token: s.refresh_token, expires_at: s.expires_at ?? Math.floor(Date.now() / 1000) + 3000, user_id: user.id } : null,
    });
  } catch (e) {
    console.error(e);
    return reply({ error: "server_error" }, 500);
  }
});
