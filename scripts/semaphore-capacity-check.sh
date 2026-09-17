#!/usr/bin/env bash
set -euo pipefail

echo "Linux semaphore capacity check"
echo "Time: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo

if ! command -v sysctl >/dev/null 2>&1; then
  echo "ERROR: sysctl command is required" >&2
  exit 2
fi

KERNEL_SEM="$(sysctl -n kernel.sem)"
read -r SEMMSL SEMMNS SEMOPM SEMMNI <<< "$KERNEL_SEM"

echo "Current kernel.sem:"
echo "kernel.sem = $KERNEL_SEM"
echo
echo "Meaning:"
echo "SEMMSL: max semaphores per array      = $SEMMSL"
echo "SEMMNS: max semaphores system wide    = $SEMMNS"
echo "SEMOPM: max operations per semop call = $SEMOPM"
echo "SEMMNI: max semaphore arrays          = $SEMMNI"
echo

if command -v ipcs >/dev/null 2>&1; then
  echo "Current semaphore usage:"
  ipcs -s || true
else
  echo "INFO: ipcs command not found"
fi

echo
echo "SRE validation notes:"
echo "- Confirm current application demand before increasing limits."
echo "- Apply changes through configuration management for persistence."
echo "- Validate after Puppet/Ansible/TuneD/profile reapplication."
echo "- Document rollback value before implementation."
