-- Cache for the public "daily" function: orbit data (TLE) of the space station,
-- Tiangong and Hubble, and NASA's Astronomy Picture of the Day. Only the
-- function (service role) reads or writes it; RLS is on with no policies.
create table if not exists public.feed_cache (
  key text primary key,
  body jsonb not null,
  fetched_at timestamptz not null default now()
);
alter table public.feed_cache enable row level security;
revoke all on public.feed_cache from anon, authenticated;
grant select, insert, update, delete on public.feed_cache to service_role;
