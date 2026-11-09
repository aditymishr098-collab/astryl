-- Daily 5 quiz and leaderboard (v1.20.0).
-- Everyone gets the same 5 questions each day (UTC). The questions are made
-- by the Edge Function from a fixed seed, so they are not stored. A run is
-- one row per person per day: it is started (time noted by the server) and
-- then finished once, and the function works out the score itself.
-- Same lock as everything else: RLS on, no policy, only service_role.

alter table public.profiles
  add column if not exists show_on_board boolean not null default true;

create table if not exists public.daily_runs (
  user_id      uuid not null references auth.users(id) on delete cascade,
  day          date not null,
  started_at   timestamptz not null default now(),
  finished_at  timestamptz,
  correct      int  not null default 0,
  ms           int  not null default 0,
  points       int  not null default 0,
  primary key (user_id, day)
);

create index if not exists daily_runs_day_points
  on public.daily_runs (day, points desc, ms asc) where finished_at is not null;

alter table public.daily_runs enable row level security;
revoke all on public.daily_runs from anon, authenticated;
grant all on public.daily_runs to service_role;

-- The leaderboard: today's best 20 and the best 20 of all time, only people
-- who left "show me on the leaderboard" on. "me" is the asking person's own
-- standing (their rank counts everybody who played, shown or not).
create or replace function public.astryl_board(p_day date, p_user uuid)
returns jsonb
language sql
security definer
set search_path = public
as $$
  with shown as (
    select r.user_id, p.username, r.points, r.correct, r.ms
    from public.daily_runs r
    join public.profiles p on p.id = r.user_id
    where r.day = p_day and r.finished_at is not null and p.show_on_board
  ),
  today_top as (
    select username, points, correct, ms from shown
    order by points desc, ms asc, username asc limit 20
  ),
  totals as (
    select r.user_id, p.username, p.show_on_board,
           sum(r.points)::int as points, count(*)::int as days
    from public.daily_runs r
    join public.profiles p on p.id = r.user_id
    where r.finished_at is not null
    group by r.user_id, p.username, p.show_on_board
  ),
  all_top as (
    select username, points, days from totals
    where show_on_board
    order by points desc, days desc, username asc limit 20
  ),
  mine_today as (
    select r.points, r.correct, r.ms,
      (select count(*) from public.daily_runs o
        where o.day = p_day and o.finished_at is not null
          and (o.points > r.points or (o.points = r.points and o.ms < r.ms)))::int + 1 as rank
    from public.daily_runs r
    where r.user_id = p_user and r.day = p_day and r.finished_at is not null
  ),
  mine_all as (
    select t.points, t.days,
      (select count(*) from totals o where o.points > t.points)::int + 1 as rank
    from totals t where t.user_id = p_user
  )
  select jsonb_build_object(
    'day', p_day,
    'today', coalesce((select jsonb_agg(jsonb_build_object('u', username, 'p', points, 'c', correct, 'ms', ms) order by points desc, ms asc, username asc) from today_top), '[]'::jsonb),
    'all',   coalesce((select jsonb_agg(jsonb_build_object('u', username, 'p', points, 'd', days) order by points desc, days desc, username asc) from all_top), '[]'::jsonb),
    'players_today', (select count(*) from public.daily_runs where day = p_day and finished_at is not null),
    'me_today', (select to_jsonb(m) from mine_today m),
    'me_all',   (select to_jsonb(m) from mine_all m)
  );
$$;

revoke all on function public.astryl_board(date, uuid) from public, anon, authenticated;
grant execute on function public.astryl_board(date, uuid) to service_role;
