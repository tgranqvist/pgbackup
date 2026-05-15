#!/usr/bin/env bash
set -Eeuo pipefail

echo "Sending healthcheck.io done signal"
curl -fsS --max-time 30 --retry 5 "${HEALTHCHECK_URL}" > /dev/null