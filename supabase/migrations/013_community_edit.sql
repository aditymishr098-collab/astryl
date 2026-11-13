-- Astryl Community: people can edit their own photo titles and posts. An edited item shows
-- "(edited)", and edits are counted so that nobody can spam by editing over and over.
-- Nothing existing is deleted or changed.

alter table public.community_posts add column if not exists edited_at timestamptz;
alter table public.community_photos add column if not exists edited_at timestamptz;

create table if not exists public.community_edits (
  id bigserial primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);
create index if not exists community_edits_user on public.community_edits (user_id, created_at desc);

alter table public.community_edits enable row level security;
revoke all on public.community_edits from anon, authenticated;
grant all on public.community_edits to service_role;
grant usage, select on sequence public.community_edits_id_seq to service_role;
