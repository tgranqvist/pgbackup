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

filename="${DB_NAME}_$(date +'%Y%m%d%H%M%S').sql.zst.age"
connection="postgres://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
if  pg_dump --dbname="$connection" | zstd | age -r "$AGE_RECIPIENT" > "/backups/$filename"
then
  run_hooks /hooks/post
else
  run_hooks /hooks/fail
  exit 1
fi