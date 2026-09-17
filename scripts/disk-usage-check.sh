#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH="${1:-/}"
DEPTH="${DEPTH:-1}"
WARN_PERCENT="${WARN_PERCENT:-80}"
CRIT_PERCENT="${CRIT_PERCENT:-90}"

if [[ ! -d "$TARGET_PATH" ]]; then
  echo "ERROR: $TARGET_PATH is not a directory" >&2
  exit 2
fi

echo "Disk usage check"
echo "Path: $TARGET_PATH"
echo "Time: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo

df -hT "$TARGET_PATH"
echo

USE_PERCENT="$(df -P "$TARGET_PATH" | awk 'NR == 2 { gsub("%", "", $5); print $5 }')"
if [[ "$USE_PERCENT" -ge "$CRIT_PERCENT" ]]; then
  echo "CRITICAL: filesystem usage is ${USE_PERCENT}%"
elif [[ "$USE_PERCENT" -ge "$WARN_PERCENT" ]]; then
  echo "WARNING: filesystem usage is ${USE_PERCENT}%"
else
  echo "OK: filesystem usage is ${USE_PERCENT}%"
fi

echo
echo "Largest directories under $TARGET_PATH"
du -xhd "$DEPTH" "$TARGET_PATH" 2>/dev/null | sort -hr | head -20

echo
echo "Large files under $TARGET_PATH"
find "$TARGET_PATH" -xdev -type f -size +100M -printf '%s %p\n' 2>/dev/null | sort -nr | head -20 | awk '{ size=$1; $1=""; printf "%.2f MB %s\n", size/1024/1024, $0 }'
