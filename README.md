# PostgreSQL backup

This is a very simple backup image for containerized [PostgreSQL]. It runs a cron job using
[Supercronic] that dumps the given database using `pg_dump`. The dump is encrypted using [age].
Encryption is mandatory.

## Configuration

Configuration is through environment variables.

|Variable    |What                                         |Mandatory?|Default                   |
|------------|---------------------------------------------|---------|---------------------------|
AGE_RECIPIENT|The age public key to encrypt backup against |✔️      |                            | 
DB_HOST      |The database host                            |✔️      |                            | 
DB_PASS      |The password                                 |✔️      |                            |
DB_NAME      |The database to back up                      |✔️      |                            |
CRON_SCHEDULE|Cronatb schedule how often to run the backup |❌      |* */6 * * * (every 6th hour)|          
DB_USER      |The user for connecting to the database      |❌      |postgres                    | 
DB_PORT      |The port for connecting to the database      |❌      |5432                        |

## Volumes

You need to provide an output location for the backups to `/backups`. 

## Hook scripts

Features pre, post, and failure hooks. Mount Bash scripts into `/hooks/{pre,post,fail}` to run them
at the particular lifecycle event of the backup job. Can be used e.g. to signal a health check.

## Example

This repository has an example compose file to run the container. It features begin and end scripts
that signal progress to [healthcheck.io].

[PostgreSQL]: https://www.postgresql.org
[Supercronic]: https://github.com/aptible/supercronic
[age]: https://github.com/FiloSottile/age
[healthcheck.io]: https://healthcheck.io