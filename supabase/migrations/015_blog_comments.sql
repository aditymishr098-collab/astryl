-- Astryl blog comments. Anyone can comment without an account. No IP address is stored: only
-- "voter" (a hash of a random id kept in the browser, so people can delete their own comment)
-- and "ipkey" (a hash of the IP address that changes every day, used only for rate limits).
-- Comments appear at once; three reports hide one until a moderator decides.
-- Only the "community" Edge Function (service role) reads or writes this table.

create table if not exists public.blog_comments (
  id uuid primary key default gen_random_uuid(),
  slug text not null,
  name text not null default 'Guest',
  body text not null,
  voter text not null,
  ipkey text not null,
  status text not null default 'approved',   -- approved | pending
  reports int not null default 0,
  created_at timestamptz not null default now(),
  decided_at timestamptz
);
create index if not exists blog_comments_slug on public.blog_comments (slug, status, created_at);
create index if not exists blog_comments_ip on public.blog_comments (ipkey, created_at);
create index if not exists blog_comments_voter on public.blog_comments (voter, created_at);

alter table public.blog_comments enable row level security;
revoke all on public.blog_comments from anon, authenticated;
grant all on public.blog_comments to service_role;
