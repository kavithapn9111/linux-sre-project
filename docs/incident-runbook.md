# Incident Runbook - Linux High Disk Usage

## Purpose

This runbook provides a structured approach for investigating high disk usage alerts on Linux servers.

## Alert

```text
HighDiskUsage
```

## Impact

High disk usage can cause application failures, logging failures, database issues, deployment failures, and service instability.

## Initial Checks

```bash
df -hT
lsblk
mount
```

## Identify Large Directories

```bash
du -xhd 1 / | sort -hr | head -20
du -xhd 1 /var | sort -hr | head -20
```

## Identify Large Files

```bash
find /var -xdev -type f -size +100M -printf '%s %p\n' | sort -nr | head -20
```

## Check Logs

```bash
journalctl --disk-usage
du -sh /var/log/*
```

## Check Docker Usage

```bash
docker system df
docker ps
docker images
```

## Safe Cleanup Examples

Only clean files after confirming ownership and impact.

```bash
journalctl --vacuum-time=7d
```

## Escalation Criteria

Escalate when:

- Root filesystem is above 90 percent
- Application writes are failing
- Database storage is impacted
- Cleanup requires application owner approval
- Filesystem expansion is required

## Validation

```bash
df -hT
systemctl --failed
journalctl -p err --since "1 hour ago"
```

## Closure Notes

Document:

- Root cause
- Impact duration
- Cleanup or expansion performed
- Preventive action
- Monitoring or alert tuning required
