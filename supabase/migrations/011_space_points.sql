-- Space Points: every quiz round checked by the "quiz" Edge Function earns points.
-- Only the function (service role) reads or writes these tables; RLS is on with no policies.
create table if not exists public.quiz_runs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  kind text not null,
  qids text[] not null,
  keys jsonb not null default '[]',      -- the option keys shown for each question
  answers jsonb not null default '[]',   -- what was picked, whether it was right, how fast
  correct int not null default 0,
  score numeric not null default 0,
  points int not null default 0,
  started_at timestamptz not null default now(),
  last_at timestamptz not null default now(),
  finished_at timestamptz
);
create index if not exists quiz_runs_user_time on public.quiz_runs (user_id, started_at desc);

create table if not exists public.space_points (
  user_id uuid primary key references auth.users (id) on delete cascade,
  total int not null default 0,
  week int not null default 0,
  week_start date not null default (date_trunc('week', now() at time zone 'utc'))::date,
  updated_at timestamptz not null default now()
);
create index if not exists space_points_total on public.space_points (total desc);

alter table public.quiz_runs enable row level security;
alter table public.space_points enable row level security;
revoke all on public.quiz_runs, public.space_points from anon, authenticated;
grant select, insert, update, delete on public.quiz_runs, public.space_points to service_role;

-- Adds points (resetting the weekly count on a new UTC week) and returns the new totals.
create or replace function public.astryl_add_points(p_user uuid, p_points int)
returns json language plpgsql security definer set search_path = public as $$
declare
  wk date := (date_trunc('week', now() at time zone 'utc'))::date;
  r public.space_points;
begin
  insert into public.space_points as s (user_id, total, week, week_start, updated_at)
  values (p_user, p_points, p_points, wk, now())
  on conflict (user_id) do update set
    total = s.total + p_points,
    week = case when s.week_start = wk then s.week + p_points else p_points end,
    week_start = wk,
    updated_at = now()
  returning * into r;
  return json_build_object('total', r.total, 'week', r.week);
end $$;

-- The Space Points leaderboard: top 20 this week and of all time, plus the caller's own standing.
create or replace function public.astryl_points_board(p_user uuid)
returns json language sql security definer set search_path = public as $$
  with wk as (select (date_trunc('week', now() at time zone 'utc'))::date as d),
  pts as (
    select s.user_id, p.username, p.show_on_board, s.total,
           case when s.week_start = (select d from wk) then s.week else 0 end as week
    from public.space_points s join public.profiles p on p.id = s.user_id
  ),
  ranked as (
    select *, rank() over (order by week desc) as rw, rank() over (order by total desc) as ra from pts
  )
  select json_build_object(
    'week', coalesce((select json_agg(json_build_object('u', username, 'p', week) order by week desc) from (select * from ranked where show_on_board and week > 0 order by week desc limit 20) x), '[]'),
    'all', coalesce((select json_agg(json_build_object('u', username, 'p', total) order by total desc) from (select * from ranked where show_on_board and total > 0 order by total desc limit 20) y), '[]'),
    'me', (select json_build_object('total', total, 'week', week, 'rank_week', case when week > 0 then rw end, 'rank_all', case when total > 0 then ra end) from ranked where user_id = p_user),
    'players', (select count(*) from pts where total > 0)
  );
$$;
revoke all on function public.astryl_add_points(uuid, int), public.astryl_points_board(uuid) from public, anon, authenticated;
grant execute on function public.astryl_add_points(uuid, int), public.astryl_points_board(uuid) to service_role;
