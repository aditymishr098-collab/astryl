-- The name a person chooses to show to others (the username stays the login name).
alter table public.profiles add column if not exists display_name text;
alter table public.profiles drop constraint if exists profiles_display_name_len;
alter table public.profiles add constraint profiles_display_name_len check (display_name is null or char_length(display_name) between 2 and 30);
