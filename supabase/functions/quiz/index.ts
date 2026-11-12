// Astryl "quiz" Edge Function: ranked quiz rounds that earn Space Points.
//
//   start  {kind}            picks the questions and their options; the answers stay here
//   answer {run, i, pick}    checks one answer and says what was right
//   finish {run}             adds up the points (at most 5 counted rounds per kind per UTC day)
//   board  {}                Space Points leaderboard (this week and all time) and your own standing
//
// The bank (bank.json) is made by tools/quizbank.py from the same data as the website.
// Deploy with "Verify JWT" switched OFF: the user's own token comes in x-astryl-token.

import { createClient } from "npm:@supabase/supabase-js@2";
import bank from "./bank.json" with { type: "json" };

const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
  auth: { persistSession: false, autoRefreshToken: false },
});

const CORS: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type, x-astryl-token",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type Item = { a: string | number; pool?: string[] | "*"; o?: string[]; min?: number; max?: number; log?: boolean };
const BANK = bank as Record<string, { n: number; items: Record<string, Item> }>;
const RUNS_PER_HOUR = 60;
const COUNTED_PER_DAY = 5;
const MIN_MS = 700; // faster than this is not a person reading the question
const RUN_HOURS = 2;

class Fail extends Error {
  status: number;
  constructor(status: number, code: string) { super(code); this.status = status; }
}

function reply(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...CORS, "Content-Type": "application/json" } });
}

function rand(n: number): number {
  const b = new Uint32Array(1);
  crypto.getRandomValues(b);
  return b[0] % n;
}

function shuffled<T>(list: T[]): T[] {
  const a = list.slice();
  for (let i = a.length - 1; i > 0; i--) { const j = rand(i + 1); [a[i], a[j]] = [a[j], a[i]]; }
  return a;
}

/** Points (0 to 10) for a guess, by how close it is. */
export function closeness(guess: number, it: Item): number {
  const a = Number(it.a);
  if (!Number.isFinite(guess)) return 0;
  if (it.log) {
    if (guess <= 0) return 0;
    const r = Math.max(guess / a, a / guess);
    return r <= 1.1 ? 10 : r <= 1.25 ? 8 : r <= 1.5 ? 6 : r <= 2 ? 4 : r <= 3 ? 2 : 0;
  }
  const d = Math.abs(guess - a) / ((it.max ?? 1) - (it.min ?? 0));
  return d <= 0.02 ? 10 : d <= 0.05 ? 8 : d <= 0.1 ? 6 : d <= 0.2 ? 4 : d <= 0.3 ? 2 : 0;
}

async function userFrom(req: Request, required = true) {
  const token = req.headers.get("x-astryl-token") || "";
  if (!token) { if (required) throw new Fail(401, "no_token"); return null; }
  const { data, error } = await admin.auth.getUser(token);
  if (error || !data.user) { if (required) throw new Fail(401, "bad_token"); return null; }
  return data.user;
}

// deno-lint-ignore no-explicit-any
async function handle(req: Request, b: any): Promise<Response> {
  const action = String(b.action ?? "");
  switch (action) {
    case "start": {
      const user = await userFrom(req);
      const kind = String(b.kind ?? "");
      const round = BANK[kind];
      if (!round) throw new Fail(400, "bad_kind");
      const since = new Date(Date.now() - 3600 * 1000).toISOString();
      const { count } = await admin.from("quiz_runs").select("id", { count: "exact", head: true }).eq("user_id", user.id).gte("started_at", since);
      if ((count ?? 0) >= RUNS_PER_HOUR) throw new Fail(429, "rate_limited");
      const qids = shuffled(Object.keys(round.items)).slice(0, round.n);
      const keys = qids.map((id) => {
        const it = round.items[id];
        if (it.pool) {
          // "*" means: the answers of the other questions in this round
          const pool = it.pool === "*" ? Object.values(round.items).map((x) => String(x.a)).filter((x) => x !== String(it.a)) : it.pool;
          return shuffled([String(it.a), ...shuffled(pool).slice(0, 3)]);
        }
        if (it.o) return shuffled(it.o);
        return [];
      });
      const ins = await admin.from("quiz_runs").insert({ user_id: user.id, kind, qids, keys }).select("id").single();
      if (ins.error || !ins.data) throw new Fail(500, "start_failed");
      return reply({ run: ins.data.id, questions: qids.map((id, i) => ({ id, keys: keys[i] })) });
    }

    case "answer": {
      const user = await userFrom(req);
      const { data: run } = await admin.from("quiz_runs").select("*").eq("id", String(b.run ?? "")).eq("user_id", user.id).maybeSingle();
      if (!run || run.finished_at) throw new Fail(404, "no_run");
      if (Date.now() - Date.parse(run.started_at) > RUN_HOURS * 3600 * 1000) throw new Fail(410, "run_expired");
      const i = Number(b.i);
      const answers = Array.isArray(run.answers) ? run.answers : [];
      if (!Number.isInteger(i) || i !== answers.length || i >= run.qids.length) throw new Fail(409, "out_of_order");
      const it = BANK[run.kind]?.items[run.qids[i]];
      if (!it) throw new Fail(500, "bad_bank");
      const ms = Date.now() - Date.parse(run.last_at);
      const fast = ms < MIN_MS;
      let ok = false, score = 0;
      if (it.pool || it.o) {
        const pick = String(b.pick ?? "");
        if (!(run.keys[i] as string[]).includes(pick)) throw new Fail(400, "bad_pick");
        ok = pick === String(it.a);
        score = ok ? 10 : 0;
      } else {
        score = closeness(Number(b.pick), it);
        ok = score >= 6;
      }
      if (fast) score = 0;
      answers.push({ p: b.pick, ok, s: score, ms });
      const upd = await admin.from("quiz_runs").update({
        answers, correct: run.correct + (ok ? 1 : 0), score: Number(run.score) + score, last_at: new Date().toISOString(),
      }).eq("id", run.id).is("finished_at", null);
      if (upd.error) throw new Fail(500, "answer_failed");
      return reply({ ok, a: it.a, s: score, fast });
    }

    case "finish": {
      const user = await userFrom(req);
      const { data: run } = await admin.from("quiz_runs").select("*").eq("id", String(b.run ?? "")).eq("user_id", user.id).maybeSingle();
      if (!run || run.finished_at) throw new Fail(404, "no_run");
      const answers = Array.isArray(run.answers) ? run.answers : [];
      if (answers.length < run.qids.length) throw new Fail(409, "not_done");
      const allRight = answers.every((a: { s: number }) => a.s === 10);
      let points = Math.round(Number(run.score)) + (allRight ? 5 : 0);
      const day = new Date().toISOString().slice(0, 10) + "T00:00:00Z";
      const { count } = await admin.from("quiz_runs").select("id", { count: "exact", head: true })
        .eq("user_id", user.id).eq("kind", run.kind).gte("started_at", day).gt("points", 0).not("finished_at", "is", null);
      const capped = (count ?? 0) >= COUNTED_PER_DAY;
      if (capped) points = 0;
      const upd = await admin.from("quiz_runs").update({ finished_at: new Date().toISOString(), points }).eq("id", run.id).is("finished_at", null).select("id");
      if (upd.error || !upd.data?.length) throw new Fail(409, "already_done");
      let totals = { total: 0, week: 0 };
      if (points > 0) {
        const r = await admin.rpc("astryl_add_points", { p_user: user.id, p_points: points });
        if (r.error) throw new Fail(500, "points_failed");
        totals = r.data;
      } else {
        const { data } = await admin.from("space_points").select("total, week").eq("user_id", user.id).maybeSingle();
        if (data) totals = data;
      }
      return reply({ points, capped, correct: run.correct, n: run.qids.length, perfect: allRight, ...totals });
    }

    case "board": {
      const user = await userFrom(req, false);
      const { data, error } = await admin.rpc("astryl_points_board", { p_user: user ? user.id : null });
      if (error) throw new Fail(500, "board_failed");
      return reply(data);
    }

    default:
      throw new Fail(400, "unknown_action");
  }
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  try {
    if (req.method !== "POST") throw new Fail(405, "bad_method");
    const text = await req.text();
    if (text.length > 4000) throw new Fail(413, "too_big");
    let body: unknown = {};
    try { body = text ? JSON.parse(text) : {}; } catch { throw new Fail(400, "bad_json"); }
    return await handle(req, body);
  } catch (e) {
    if (e instanceof Fail) return reply({ error: e.message }, e.status);
    console.error(e);
    return reply({ error: "server_error" }, 500);
  }
});
