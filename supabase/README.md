# Astryl online backend (Supabase)

Optional accounts, sync and the public counter. The app and the website talk to
**one** function, `account`. Every table is locked (row level security with no
policy), so the public key cannot read or write anything by itself.

| Part | File |
|---|---|
| Tables, locks, counter functions | `migrations/001_init.sql` |
| The only door: signup, login, recovery, sync, delete, counter | `functions/account/index.ts` |
| Keeps the free project awake | `../.github/workflows/keepalive.yml` |

Project: `pmfjjlfggzihbnbmqkao`. The public (publishable) key is in
`lib/data/sync.dart` and `tools/site_src/app.js`. **The service role / secret key
must never be put in the app, the website or this repository.** The function
reads it from Supabase's own environment (`SUPABASE_SERVICE_ROLE_KEY`), which is
set automatically.

## One-time setup (about 10 minutes, in the Supabase dashboard)

1. **Tables.** SQL Editor → New query → paste all of `migrations/001_init.sql` →
   Run. It says "Success". Running it again is harmless.
2. **Sign-in settings.** Authentication → Sign In / Providers → Email:
   *Confirm email* **off** (usernames have no real e-mail; the function marks
   them confirmed itself). Leave *Allow new users to sign up* on.
3. **The function.** Edge Functions → Deploy a new function → *Via Editor* →
   name it exactly `account` → replace the sample code with the whole of
   `functions/account/index.ts` → Deploy.
4. **Verify JWT off.** Edge Functions → `account` → Details → switch **Verify
   JWT with legacy secret** (or "Verify JWT") **off**, and save. The public
   key is not a JWT; the function checks the user's own token itself. If this
   is left on, every call answers 401.
5. **Check.** Open
   `https://pmfjjlfggzihbnbmqkao.supabase.co/functions/v1/account?action=stats`
   in a browser. It should show `{"registered":0,"active_today":0,...}`.

## Seeing and managing the data

Table Editor shows `profiles` (username, switches, country, rounded location),
`user_data` (the synced settings), `pings` (anonymous daily counts). Passwords
are not visible anywhere: they live hashed inside Supabase Auth. Deleting a user
in Authentication → Users removes all their rows too (cascade).

## What is stored

| Table | Contents | Removed when |
|---|---|---|
| `auth.users` | fake address `username@users.astryl.space`, password hash | the user deletes the account |
| `profiles` | username, dates, three switches, country, latest location rounded to 0.1° | the user deletes the account |
| `recovery` | hash of the recovery code, uses left, failed tries | the user deletes the account |
| `user_data` | synced settings (JSON) | the user deletes the account |
| `pings` | day, random device id, country | after 90 days |
| `rate` | hashed key and a counter (limits abuse) | after 2 days |

## Free plan

A free project is paused after about a week without use. `keepalive.yml` asks
for the public counter every 3 days, and the website does too whenever someone
opens it. If a project is ever paused, press *Restore* in the dashboard.
