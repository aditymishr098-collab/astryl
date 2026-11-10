// Astryl "backup" Edge Function.
//
// Hands the irreplaceable tables (accounts' profiles, recovery hashes, synced
// data and Daily 5 runs) to the nightly backup job in .github/workflows/backup.yml.
// It only answers when the request carries the secret BACKUP_TOKEN (set as an
// Edge Function secret and as a repository secret). The job encrypts the file
// before it is stored, because this repository is public.
//
// Deploy with "Verify JWT" switched OFF (the caller sends its own token).

import { createClient } from "npm:@supabase/supabase-js@2";

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  { auth: { persistSession: false, autoRefreshToken: false } },
);

const TABLES = ["profiles", "recovery", "user_data", "daily_runs"];

function same(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

function reply(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json", "Cache-Control": "no-store" },
  });
}

Deno.serve(async (req: Request) => {
  const secret = Deno.env.get("BACKUP_TOKEN") ?? "";
  const given = req.headers.get("x-backup-token") ?? "";
  if (secret.length < 24 || !same(secret, given)) return reply({ error: "forbidden" }, 403);

  const out: Record<string, unknown> = { format: 1, made_at: new Date().toISOString() };
  for (const table of TABLES) {
    const rows: unknown[] = [];
    for (let from = 0; ; from += 1000) {
      const { data, error } = await admin.from(table).select("*").range(from, from + 999);
      if (error) return reply({ error: "backup_failed", table }, 500);
      rows.push(...data);
      if (data.length < 1000) break;
    }
    out[table] = rows;
  }
  return reply(out);
});
