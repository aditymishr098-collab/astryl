# Backups

The Backup workflow (`.github/workflows/backup.yml`) runs every night and from the
Actions tab ("Run workflow"). It saves the profiles, recovery hashes, synced data
and Daily 5 runs, encrypts them with `BACKUP_PASSPHRASE` and keeps the file for
30 days as the artifact `astryl-backup` (Actions > the run > Artifacts).

Passwords themselves live in Supabase Auth and are not in the file. If the
database were ever lost, people sign in again with their recovery code and set a
new password; their data comes back from this file.

## Open a backup

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 \
  -in astryl-backup-2026-11-11.enc -out backup.json
```

It asks for the passphrase. Keep `backup.json` private and delete it when done.
