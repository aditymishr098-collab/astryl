-- Unique visitors of astryl.space and approximate places, without keeping
-- any IP address.
--
-- site_visitors: one row per day and visitor. "h" is a one-way code made in
-- the account function from the IP address, the UTC day and a secret, so it
-- cannot be turned back into an address and is different every day (a person
-- cannot be followed from one day to the next). Rows are kept for 90 days.
--
-- visitor_places: how many visitors agreed to share an approximate place
-- (rounded to 0.1 degree, about 10 km) on a day. No code, no account, no IP.

create table if not exists public.site_visitors (
  day date not null default current_date,
  h   text not null,
  primary key (day, h)
);

create table if not exists public.visitor_places (
  day date not null default current_date,
  lat numeric(5,1) not null,
  lon numeric(5,1) not null,
  n   int not null default 1,
  primary key (day, lat, lon)
);

alter table public.site_visitors enable row level security;
alter table public.visitor_places enable row level security;
revoke all on public.site_visitors from anon, authenticated;
revoke all on public.visitor_places from anon, authenticated;
grant all on public.site_visitors to service_role;
grant all on public.visitor_places to service_role;

drop function if exists public.astryl_visit(text, text, text, text, text);

create or replace function public.astryl_visit(
  p_page text, p_lang text, p_device text, p_ref text, p_country text,
  p_visitor text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.site_visits(day, page, lang, device, ref, country, n)
  values (current_date, p_page, p_lang, p_device, p_ref, p_country, 1)
  on conflict (day, page, lang, device, ref, country)
    do update set n = public.site_visits.n + 1;
  if p_visitor is not null and length(p_visitor) = 64 then
    insert into public.site_visitors(day, h) values (current_date, p_visitor)
    on conflict do nothing;
  end if;
  if random() < 0.02 then
    delete from public.site_visits where day < current_date - 400;
    delete from public.site_visitors where day < current_date - 90;
    delete from public.visitor_places where day < current_date - 400;
  end if;
end;
$$;

revoke all on function public.astryl_visit(text, text, text, text, text, text)
  from public, anon, authenticated;
grant execute on function public.astryl_visit(text, text, text, text, text, text)
  to service_role;

create or replace function public.astryl_place(p_lat numeric, p_lon numeric)
returns void
language sql
security definer
set search_path = public
as $$
  insert into public.visitor_places(day, lat, lon, n)
  values (current_date, round(p_lat, 1), round(p_lon, 1), 1)
  on conflict (day, lat, lon) do update set n = public.visitor_places.n + 1;
$$;

revoke all on function public.astryl_place(numeric, numeric)
  from public, anon, authenticated;
grant execute on function public.astryl_place(numeric, numeric) to service_role;

create or replace function public.astryl_stats()
returns jsonb
language sql
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'registered',     (select count(*) from public.profiles),
    'active_today',   (select count(distinct device) from public.pings where day = current_date),
    'active_7d',      (select count(distinct device) from public.pings where day > current_date - 7),
    'active_30d',     (select count(distinct device) from public.pings where day > current_date - 30),
    'views_30d',      (select coalesce(sum(n), 0) from public.site_visits where day > current_date - 30),
    'visitors_today', (select count(*) from public.site_visitors where day = current_date),
    'visitors_30d',   (select count(*) from public.site_visitors where day > current_date - 30),
    'countries',      coalesce((
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
