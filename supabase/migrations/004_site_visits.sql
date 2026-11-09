-- Page views on astryl.space, counted without identifying anyone.
-- One row per day, page, language, device size, referring site and country,
-- with a counter. There is no IP address, no cookie, no id and no time of day,
-- so a row cannot be tied to a person. Rows are kept for 400 days.
create table if not exists public.site_visits (
  day      date not null default current_date,
  page     text not null,
  lang     text not null default '',
  device   text not null default '',
  ref      text not null default '',
  country  text not null default '',
  n        int  not null default 0,
  primary key (day, page, lang, device, ref, country)
);

alter table public.site_visits enable row level security;
revoke all on public.site_visits from anon, authenticated;
grant all on public.site_visits to service_role;

create or replace function public.astryl_visit(
  p_page text, p_lang text, p_device text, p_ref text, p_country text
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
  if random() < 0.02 then
    delete from public.site_visits where day < current_date - 400;
  end if;
end;
$$;

revoke all on function public.astryl_visit(text, text, text, text, text)
  from public, anon, authenticated;
grant execute on function public.astryl_visit(text, text, text, text, text)
  to service_role;

-- The public counter now also has the page views of the last 30 days.
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
    'views_30d',    (select coalesce(sum(n), 0) from public.site_visits where day > current_date - 30),
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
