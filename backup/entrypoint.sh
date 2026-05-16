#!/usr/bin/env bash
set -Eeuo pipefail

source /usr/local/bin/lib/logging.sh

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    err "Missing required environment variable: $name"
    exit 1
  fi
}

log "===# Backup container starting #==="

require_env PGBAK_AGE_RECIPIENT
require_env PGBAK_DB_HOST
require_env PGBAK_DB_PASSWORD
require_env PGBAK_DB_NAME

cron_schedule="${PGBAK_CRON_SCHEDULE:-0 */6 * * *}"
db_user="${PGBAK_DB_USER:-postgres}"
db_port="${PGBAK_DB_PORT:-5432}"

if [[ ! -d /backups ]]; then
  err "Output directory missing, exiting"
  exit 1
fi

if [[ ! -f /etc/crontab ]]; then
  log "Generating crontab"
  printf '%s %s\n' "${cron_schedule}" "/usr/local/bin/backup.sh" > /etc/crontab
fi

# Set these in the container for pg_dump to use
export PGHOST="${PGBAK_DB_HOST}"
export PGPORT="${db_port}"
export PGUSER="${db_user}"
export PGPASSWORD="${PGBAK_DB_PASSWORD}"
export PGDATABASE="${PGBAK_DB_NAME}"

log "Output location mounted"
log "Schedule: ${cron_schedule}"
log "PostgreSQL client version: $(pg_dump --version | awk '{print $3}')"
log "PostgreSQL server version: $(psql -Atc "SHOW server_version;")"
log "AGE recipient: ${PGBAK_AGE_RECIPIENT:0:16}"

exec /usr/local/bin/supercronic -split-logs /etc/crontab