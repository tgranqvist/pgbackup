#!/usr/bin/env bash
set -Eeuo pipefail

echo "Sending healthcheck.io start signal"
curl -fsS --max-time 30 --retry 5 "${HEALTHCHECK_URL}/start" > /dev/null