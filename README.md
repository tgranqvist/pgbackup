# PostgreSQL backup

This is a very simple backup image for containerized [PostgreSQL]. It runs a cron job using
[Supercronic] that dumps the given database using `pg_dump`. The dump is compressed using [zstd] and
encrypted using [age].

## Configuration

Configuration is through environment variables.

|Variable           |What                                         |Mandatory?|Default                    |
|-------------------|---------------------------------------------|----------|---------------------------|
|PGBAK_AGE_RECIPIENT|The age public key to encrypt backup against |✔️       |                            | 
|PGBAK_DB_HOST      |The database host                            |✔️       |                            | 
|PGBAK_DB_PASS      |The password                                 |✔️       |                            |
|PGBAK_DB_NAME      |The database to back up                      |✔️       |                            |
|PGBAK_CRON_SCHEDULE|Cronatb schedule how often to run the backup |❌       |* */6 * * * (every 6th hour)|          
|PGBAK_DB_USER      |The user for connecting to the database      |❌       |postgres                    | 
|PGBAK_DB_PORT      |The port for connecting to the database      |❌       |5432                        |

If you are unfamiliar with crontab scheduling, see [crontab.guru].

## Volumes

You need to provide an output location for the backups to `/backups`. 

## Lifecycle hooks

Features `pre`, `post`, and `failure` hooks. Mount Bash scripts into `/hooks/{pre,post,fail}` to run
them at the particular lifecycle event of the backup job. Can be used e.g. to signal a health check.

If your hook scripts need parameters, e.g. healthcheck URL, ntfy topic or Slack channel, pass that
as environment variable to the container and read it in the script:

```bash
curl -fsS --max-time 30 --retry 5 "${HEALTHCHECK_URL}/start" > /dev/null
```

## Example

This repository has an example compose file to run the container. It stands up PostgreSQL, [Adminer],
and pgbackup containers and features begin and end scripts that signal progress to [healthcheck.io].

[PostgreSQL]: https://www.postgresql.org
[Supercronic]: https://github.com/aptible/supercronic
[zstd]: https://en.wikipedia.org/wiki/Zstd
[age]: https://github.com/FiloSottile/age
[crontab.guru]: https://crontab.guru/
[Adminer]: https://adminer.org
[healthcheck.io]: https://healthcheck.io