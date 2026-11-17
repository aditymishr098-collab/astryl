-- When a person last changed their username (the "rename" Edge Function allows it once every 30 days).
alter table public.profiles add column if not exists username_changed_at timestamptz;
