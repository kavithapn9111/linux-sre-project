# Ansible Linux Baseline Checks

This folder contains a simple Ansible playbook for Linux baseline validation.

## Run Locally

```bash
ansible-playbook -i ansible/inventory.ini ansible/linux-baseline-check.yml
```

## What It Checks

- OS and kernel details
- Filesystem usage
- Memory usage
- System load
- Failed systemd units
- Kernel semaphore settings

## Why This Is Useful For SRE

SRE and Linux administration work often requires repeatable validation before and after changes. This playbook demonstrates how operational checks can be automated and documented in a consistent way.
