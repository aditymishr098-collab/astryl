-- Profile photos (v1.36.0). One small square JPEG per person (256 x 256, about
-- 30 KB), kept as base64 text. Same lock as everything else: RLS on, no
-- policy, only service_role. It goes away with the account.

create table if not exists public.avatars (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  image      text not null,
  updated_at timestamptz not null default now()
);

alter table public.avatars enable row level security;
revoke all on public.avatars from anon, authenticated;
grant all on public.avatars to service_role;
