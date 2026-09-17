#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-}"
PORT="${2:-443}"
WARN_DAYS="${WARN_DAYS:-30}"

if [[ -z "$HOST" ]]; then
  echo "Usage: $0 <hostname> [port]" >&2
  exit 2
fi

if ! command -v openssl >/dev/null 2>&1; then
  echo "ERROR: openssl is required" >&2
  exit 2
fi

CERT_DATA="$(echo | openssl s_client -servername "$HOST" -connect "${HOST}:${PORT}" 2>/dev/null | openssl x509 -noout -subject -issuer -serial -dates -ext subjectAltName)"
NOT_AFTER="$(printf '%s\n' "$CERT_DATA" | awk -F= '/notAfter/ {print $2}')"

if date -d "$NOT_AFTER" +%s >/dev/null 2>&1; then
  EXPIRY_EPOCH="$(date -d "$NOT_AFTER" +%s)"
else
  EXPIRY_EPOCH="$(date -j -f "%b %e %T %Y %Z" "$NOT_AFTER" +%s)"
fi

NOW_EPOCH="$(date +%s)"
DAYS_LEFT="$(( (EXPIRY_EPOCH - NOW_EPOCH) / 86400 ))"

echo "TLS certificate check"
echo "Host: $HOST"
echo "Port: $PORT"
echo
printf '%s\n' "$CERT_DATA"
echo

if [[ "$DAYS_LEFT" -lt 0 ]]; then
  echo "CRITICAL: certificate expired $((-DAYS_LEFT)) days ago"
  exit 2
elif [[ "$DAYS_LEFT" -le "$WARN_DAYS" ]]; then
  echo "WARNING: certificate expires in ${DAYS_LEFT} days"
  exit 1
else
  echo "OK: certificate expires in ${DAYS_LEFT} days"
fi
