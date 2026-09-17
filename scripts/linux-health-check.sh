#!/usr/bin/env bash
set -euo pipefail

HOSTNAME_VALUE="$(hostname)"
REPORT_TIME="$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
DISK_WARN="${DISK_WARN:-80}"
DISK_CRIT="${DISK_CRIT:-90}"
LOAD_WARN="${LOAD_WARN:-5}"

section() {
  printf '\n== %s ==\n' "$1"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

print_status() {
  local status="$1"
  local message="$2"
  printf '[%s] %s\n' "$status" "$message"
}

section "Linux Health Check"
printf 'Host: %s\n' "$HOSTNAME_VALUE"
printf 'Time: %s\n' "$REPORT_TIME"

section "Uptime And Load"
uptime
LOAD_1M="$(awk '{print $1}' /proc/loadavg)"
if awk "BEGIN { exit !($LOAD_1M >= $LOAD_WARN) }"; then
  print_status "WARN" "1 minute load average is ${LOAD_1M}, threshold is ${LOAD_WARN}"
else
  print_status "OK" "1 minute load average is ${LOAD_1M}"
fi

section "Memory"
if command_exists free; then
  free -h
else
  print_status "WARN" "free command not found"
fi

section "Disk Usage"
df -hT | awk -v warn="$DISK_WARN" -v crit="$DISK_CRIT" '
NR == 1 { print; next }
{
  use=$6
  gsub("%", "", use)
  print
  if (use >= crit) {
    printf("[CRIT] %s is %s%% used\n", $7, use)
  } else if (use >= warn) {
    printf("[WARN] %s is %s%% used\n", $7, use)
  }
}'

section "Top Processes By CPU"
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -10

section "Top Processes By Memory"
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%mem | head -10

section "Failed systemd Units"
if command_exists systemctl; then
  systemctl --failed --no-pager || true
else
  print_status "INFO" "systemctl not available"
fi

section "Recent Kernel Errors"
if command_exists journalctl; then
  journalctl -k -p err --since "24 hours ago" --no-pager | tail -30 || true
else
  dmesg --level=err 2>/dev/null | tail -30 || true
fi

section "Docker Summary"
if command_exists docker; then
  docker system df || true
  docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' || true
else
  print_status "INFO" "docker not installed or not available in PATH"
fi

section "Listening Ports"
if command_exists ss; then
  ss -tulpen | head -40
else
  print_status "INFO" "ss command not found"
fi

section "Summary"
print_status "OK" "Health check completed"
