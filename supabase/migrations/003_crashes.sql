-- Crash reports sent by the app (Settings > Send crash reports, on by default).
-- A report has the error text, the app version, the Android build string and
-- the language. It has no name, no account, no device id and no location.
create table if not exists public.crashes (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  app_version text not null default '',
  os          text not null default '',
  locale      text not null default '',
  message     text not null,
  stack       text not null default ''
);

create index if not exists crashes_created_idx on public.crashes (created_at desc);

alter table public.crashes enable row level security;

-- Same lock as every other table: no policies, nothing for the public roles.
-- Only the "account" Edge Function (service_role) writes, and only the owner
-- reads (Supabase dashboard).
revoke all on public.crashes from anon, authenticated;
grant all on public.crashes to service_role;
