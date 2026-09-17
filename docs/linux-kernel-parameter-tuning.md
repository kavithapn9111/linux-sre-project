# Linux Kernel Parameter Tuning - Semaphore Example

## Purpose

This document explains a safe SRE-style workflow for validating and changing Linux kernel parameters such as `kernel.sem`.

## Background

Database and middleware workloads may use System V semaphores. If semaphore limits are too low, applications can fail when creating semaphore sets.

Example error pattern:

```text
semget failed
No space left on device
```

This does not always mean disk space is full. It can mean the system exhausted a kernel resource limit.

## Check Current Value

```bash
sysctl kernel.sem
```

Example:

```text
kernel.sem = 250 32000 100 128
```

## Field Meaning

```text
SEMMSL - max semaphores per array
SEMMNS - max semaphores system wide
SEMOPM - max operations per semop call
SEMMNI - max semaphore arrays
```

## Temporary Runtime Change

```bash
sudo sysctl -w kernel.sem="250 64000 100 256"
```

This applies immediately but may not persist after reboot or profile reapplication.

## Persistent Change

Use configuration management such as Ansible, Puppet, or a managed Linux profile. Avoid manual one-off changes unless required for urgent mitigation.

## SRE Validation Checklist

- Confirm affected hosts and scope
- Capture current value before change
- Check current semaphore usage with `ipcs -s`
- Apply change in non-production first
- Run configuration management in noop/check mode if available
- Confirm change does not affect unrelated host groups
- Implement during approved change window
- Validate value after implementation
- Validate value after reboot or profile reapplication if required
- Document rollback steps

## Rollback Example

```bash
sudo sysctl -w kernel.sem="250 32000 100 128"
```

## Post-Change Validation

```bash
sysctl kernel.sem
ipcs -s
```
