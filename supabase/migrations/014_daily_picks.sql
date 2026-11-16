-- Daily 5: keep the answers a person picked, so the review after playing can show them.
alter table public.daily_runs add column if not exists picks text[];
