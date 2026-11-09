-- 001 revoked everything from the public roles, which also removed the
-- permissions of service_role (the role the "account" Edge Function uses).
-- Without this, signup failed with a 500. anon and authenticated stay locked.
grant usage on schema public to service_role;
grant all on public.profiles, public.recovery, public.user_data, public.pings, public.rate to service_role;
revoke all on public.profiles, public.recovery, public.user_data, public.pings, public.rate from anon, authenticated;
