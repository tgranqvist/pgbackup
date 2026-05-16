#!/usr/bin/env bash
set -Eeuo pipefail

source /usr/local/bin/lib/logging.sh

run_hooks() {
    DIR="$1"
    log "Running hooks from $DIR"
    [ -d "$DIR" ] || return 0
    for f in "$DIR"/*; do
        [ -x "$f" ] && "$f"
    done 
}

run_hooks /hooks/pre

filename="${PGBAK_DB_NAME}_$(date +'%Y%m%d%H%M%S').sql.zst.age"
if  pg_dump | zstd | age -r "${PGBAK_AGE_RECIPIENT}" > "/backups/$filename"
then
  run_hooks /hooks/post
else
  run_hooks /hooks/fail
  exit 1
fi