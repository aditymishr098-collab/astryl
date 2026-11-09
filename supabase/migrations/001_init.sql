-- Astryl online features (v1.18.0)
--
-- Run this whole file once: Supabase dashboard -> SQL Editor -> New query ->
-- paste -> Run. It is safe to run again.
--
-- Design: every table is locked with row level security and has NO policy, so
-- the public (publishable) key can read and write nothing directly. Only the
-- Edge Function "account" (which holds the service role inside Supabase) can
-- touch the data, and it checks who is asking.

create table if not exists public.profiles (
  id               uuid primary key references auth.users(id) on delete cascade,
  username         text not null unique,
  created_at       timestamptz not null default now(),
  last_seen        timestamptz not null default now(),
  consent_at       timestamptz not null default now(),
  consent_version  int  not null default 1,
  count_me         boolean not null default false,
  share_country    boolean not null default false,
  share_location   boolean not null default false,
  country          text,
  lat              numeric(5,1),
  lon              numeric(6,1),
  loc_at           timestamptz,
  constraint username_format check (username ~ '^[a-z0-9_]{3,20}$')
);

create table if not exists public.recovery (
  user_id       uuid primary key references auth.users(id) on delete cascade,
  code_hash     text not null,
  uses_left     int  not null default 3,
  failed        int  not null default 0,
  locked_until  timestamptz
);

create table if not exists public.user_data (
  user_id     uuid primary key references auth.users(id) on delete cascade,
  data        jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

-- One row per anonymous device per day. "device" is a random id made by the
-- app; it is not linked to any account or person.
create table if not exists public.pings (
  day      date not null default current_date,
  device   text not null,
  country  text,
  primary key (day, device)
);

-- Rate limiting. "k" is a hash, never a raw IP address or name.
create table if not exists public.rate (
  k       text primary key,
  n       int  not null default 0,
  since   timestamptz not null default now()
);

alter table public.profiles  enable row level security;
alter table public.recovery  enable row level security;
alter table public.user_data enable row level security;
alter table public.pings     enable row level security;
alter table public.rate      enable row level security;

revoke all on public.profiles, public.recovery, public.user_data, public.pings, public.rate
  from anon, authenticated;

-- Numbers for the public counter on the app and the website.
create or replace function public.astryl_stats()
returns jsonb
language sql
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'registered',   (select count(*) from public.profiles),
    'active_today', (select count(distinct device) from public.pings where day = current_date),
    'active_7d',    (select count(distinct device) from public.pings where day > current_date - 7),
    'active_30d',   (select count(distinct device) from public.pings where day > current_date - 30),
    'countries',    coalesce((
      select jsonb_agg(jsonb_build_object('c', country, 'n', n) order by n desc)
      from (
        select country, count(distinct device) as n
        from public.pings
        where day > current_date - 30 and country is not null
        group by country
        order by n desc
        limit 10
      ) t
    ), '[]'::jsonb)
  );
$$;

create or replace function public.astryl_ping(p_device text, p_country text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.pings(day, device, country)
  values (current_date, p_device, p_country)
  on conflict (day, device) do update
    set country = coalesce(excluded.country, public.pings.country);
  -- Keep nothing older than 90 days.
  delete from public.pings where day < current_date - 90;
  delete from public.rate where since < now() - interval '2 days';
end;
$$;

revoke all on function public.astryl_stats()                from public, anon, authenticated;
revoke all on function public.astryl_ping(text, text)       from public, anon, authenticated;
grant execute on function public.astryl_stats()             to service_role;
grant execute on function public.astryl_ping(text, text)    to service_role;
