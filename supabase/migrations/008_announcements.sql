-- Announcements: short notes from the Astryl team that every phone shows as a
-- notification. Written by hand in the Supabase dashboard (or SQL editor);
-- read only through the "account" function (action "news").

create table if not exists public.announcements (
  id bigint generated always as identity primary key,
  title_en text not null,
  body_en text not null,
  title_hi text,
  body_hi text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.announcements enable row level security;
revoke all on public.announcements from anon, authenticated;
grant all on public.announcements to service_role;
