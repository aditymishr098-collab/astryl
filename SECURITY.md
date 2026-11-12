# Security

If you find a security problem in Astryl (the app, astryl.space or its server), please do not open a
public issue. Write to aditym02@outlook.com with the details, and it will be fixed as soon as possible.

## How Astryl keeps data safe

* No secret is stored in this repository. The website and the app contain only the Supabase
  publishable key, which is public by design and cannot read or write any table.
* Every database table has row level security switched on and no public access. Only the Edge
  Functions (server code in `supabase/functions/`) can read or write them, and each one checks the
  user's own login token.
* The APK signing key and passwords live only in the repository's Actions secrets.
* The nightly database backup is encrypted before it is stored.
