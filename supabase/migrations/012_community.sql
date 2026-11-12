-- Astryl Community: "I saw it" sky reports, weekly challenges, polls, a photo gallery and a
-- discussion board. Photos and posts appear at once; reported ones go to the moderators.
-- Everything a person adds is tied to their account and is deleted with it (on delete cascade);
-- photos are kept in the database for exactly that reason.
-- Only the "community" Edge Function (service role) reads or writes these tables.

create table if not exists public.community_admins (
  user_id uuid primary key references auth.users (id) on delete cascade
);

create table if not exists public.sky_seen (
  id bigserial primary key,
  what text not null,
  voter text not null,                 -- a hash of the account id or of a random id kept in the browser
  user_id uuid references auth.users (id) on delete cascade,
  country text,
  day date not null default current_date,
  created_at timestamptz not null default now(),
  unique (what, voter, day)
);
create index if not exists sky_seen_day on public.sky_seen (day);

create table if not exists public.challenge_done (
  user_id uuid not null references auth.users (id) on delete cascade,
  week text not null,
  cid text not null,
  done_at timestamptz not null default now(),
  primary key (user_id, week, cid)
);

create table if not exists public.poll_votes (
  poll text not null,
  voter text not null,
  user_id uuid references auth.users (id) on delete cascade,
  choice int not null,
  voted_at timestamptz not null default now(),
  primary key (poll, voter)
);

create table if not exists public.community_photos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  title text not null,
  kind text not null,
  taken text,
  status text not null default 'pending',   -- pending | approved
  w int, h int,
  img bytea not null,
  thumb bytea not null,
  stars int not null default 0,
  reports int not null default 0,
  created_at timestamptz not null default now(),
  decided_at timestamptz
);
create index if not exists community_photos_status on public.community_photos (status, created_at desc);

create table if not exists public.photo_stars (
  photo_id uuid not null references public.community_photos (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  primary key (photo_id, user_id)
);

create table if not exists public.community_posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  parent_id uuid references public.community_posts (id) on delete cascade,
  kind text not null default 'question',     -- question | sky | idea | reply
  body text not null,
  status text not null default 'pending',   -- pending | approved
  reports int not null default 0,
  created_at timestamptz not null default now(),
  decided_at timestamptz
);
create index if not exists community_posts_status on public.community_posts (status, created_at desc);

create table if not exists public.community_reports (
  id bigserial primary key,
  kind text not null,
  target uuid not null,
  voter text not null,
  reason text,
  created_at timestamptz not null default now(),
  unique (kind, target, voter)
);

alter table public.community_admins enable row level security;
alter table public.sky_seen enable row level security;
alter table public.challenge_done enable row level security;
alter table public.poll_votes enable row level security;
alter table public.community_photos enable row level security;
alter table public.photo_stars enable row level security;
alter table public.community_posts enable row level security;
alter table public.community_reports enable row level security;

revoke all on public.community_admins, public.sky_seen, public.challenge_done, public.poll_votes, public.community_photos,
  public.photo_stars, public.community_posts, public.community_reports from anon, authenticated;
grant all on public.community_admins, public.sky_seen, public.challenge_done, public.poll_votes, public.community_photos,
  public.photo_stars, public.community_posts, public.community_reports to service_role;
grant usage, select on sequence public.sky_seen_id_seq, public.community_reports_id_seq to service_role;

-- Moderators are added by hand, for example:
--   insert into public.community_admins (user_id) select id from public.profiles where username = '<name>';
