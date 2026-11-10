-- Daily 5: streaks, badges numbers and a weekly leaderboard (v1.35.0).
-- Same function as before with more in the answer. Old apps ignore the new keys.
-- A "streak" is a run of UTC days in a row with a finished Daily 5. It is still
-- alive when the last finished day is today or yesterday.

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
  wk as (
    select date_trunc('week', p_day::timestamp)::date as start
  ),
  week_totals as (
    select r.user_id, p.username, p.show_on_board,
           sum(r.points)::int as points, count(*)::int as days
    from public.daily_runs r
    join public.profiles p on p.id = r.user_id, wk
    where r.finished_at is not null and r.day >= wk.start and r.day < wk.start + 7
    group by r.user_id, p.username, p.show_on_board
  ),
  week_top as (
    select username, points, days from week_totals
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
  mine_week as (
    select t.points, t.days,
      (select count(*) from week_totals o where o.points > t.points)::int + 1 as rank
    from week_totals t where t.user_id = p_user
  ),
  mine_all as (
    select t.points, t.days,
      (select count(*) from totals o where o.points > t.points)::int + 1 as rank
    from totals t where t.user_id = p_user
  ),
  my_days as (
    select day from public.daily_runs
    where user_id = p_user and finished_at is not null
  ),
  islands as (
    select day, day - (row_number() over (order by day))::int as grp from my_days
  ),
  streaks as (
    select count(*)::int as len, max(day) as last_day from islands group by grp
  ),
  mine_stats as (
    select
      coalesce((select len from streaks where last_day >= p_day - 1 order by last_day desc limit 1), 0) as streak,
      coalesce((select max(len) from streaks), 0) as best,
      (select count(*) from public.daily_runs where user_id = p_user and finished_at is not null and correct = 5)::int as perfect,
      (select count(*) from my_days)::int as plays
    where p_user is not null
  )
  select jsonb_build_object(
    'day', p_day,
    'week_start', (select start from wk),
    'today', coalesce((select jsonb_agg(jsonb_build_object('u', username, 'p', points, 'c', correct, 'ms', ms) order by points desc, ms asc, username asc) from today_top), '[]'::jsonb),
    'week',  coalesce((select jsonb_agg(jsonb_build_object('u', username, 'p', points, 'd', days) order by points desc, days desc, username asc) from week_top), '[]'::jsonb),
    'all',   coalesce((select jsonb_agg(jsonb_build_object('u', username, 'p', points, 'd', days) order by points desc, days desc, username asc) from all_top), '[]'::jsonb),
    'players_today', (select count(*) from public.daily_runs where day = p_day and finished_at is not null),
    'me_today', (select to_jsonb(m) from mine_today m),
    'me_week',  (select to_jsonb(m) from mine_week m),
    'me_all',   (select to_jsonb(m) from mine_all m),
    'me_stats', (select to_jsonb(m) from mine_stats m)
  );
$$;

revoke all on function public.astryl_board(date, uuid) from public, anon, authenticated;
grant execute on function public.astryl_board(date, uuid) to service_role;
