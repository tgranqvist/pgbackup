#!/usr/bin/env bash
set -Eeuo pipefail

pg_isready --quiet -h "$PGBAK_DB_HOST"