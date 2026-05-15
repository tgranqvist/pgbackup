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

require_env AGE_RECIPIENT
require_env DB_HOST
require_env DB_PASS
require_env DB_NAME

CRON_SCHEDULE="${CRON_SCHEDULE:-0 */6 * * *}"
DB_USER="${DB_USER:-postgres}"
DB_PORT="${DB_PORT:-5432}"

if [[ ! -d /backups ]]; then
  err "Output directory missing, exiting"
  exit 1
fi

if [[ ! -f /etc/crontab ]]; then
  log "Generating crontab"
  printf '%s %s\n' "$CRON_SCHEDULE" "/usr/local/bin/backup.sh" > /etc/crontab
fi

log "Output location mounted"
log "Schedule: $CRON_SCHEDULE"
log "AGE recipient: ${AGE_RECIPIENT:0:16}"

export DB_USER DB_PORT

exec /usr/local/bin/supercronic -split-logs /etc/crontab