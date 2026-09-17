# Linux SRE Observability Lab

This project is a hands-on Linux SRE lab that demonstrates monitoring, alerting, automation, troubleshooting, and incident documentation using open source tools.

It is designed as a resume and LinkedIn portfolio project for Site Reliability Engineer, Linux Administrator, DevOps, Cloud Operations, and Production Support roles.

## What This Project Shows

- Linux infrastructure monitoring with Prometheus and Grafana
- Alerting workflow with Alertmanager
- Node level metrics using Node Exporter
- Linux health check automation using shell scripts
- Disk, memory, CPU, load, Docker, journal, and certificate checks
- Ansible based Linux baseline validation
- Incident runbook and RCA documentation
- Kernel parameter validation example for database style workloads

## Architecture

```text
Linux host / Docker Desktop
        |
        | metrics
        v
Node Exporter ---> Prometheus ---> Grafana
                       |
                       | alerts
                       v
                 Alertmanager
```

## Tools Used

- Linux
- Docker Compose
- Prometheus
- Grafana
- Alertmanager
- Node Exporter
- Ansible
- Bash shell scripting
- OpenSSL

## Project Structure

```text
linux-sre-observability-lab/
  docker-compose.yml
  prometheus/
    prometheus.yml
    alert-rules.yml
  alertmanager/
    alertmanager.yml
  grafana/
    provisioning/
      datasources/
      dashboards/
    dashboards/
  scripts/
    linux-health-check.sh
    disk-usage-check.sh
    tls-cert-check.sh
    semaphore-capacity-check.sh
  ansible/
    inventory.ini
    linux-baseline-check.yml
    README.md
  docs/
    incident-runbook.md
    rca-template.md
    linux-kernel-parameter-tuning.md
    linkedin-project-description.md
```

## Quick Start

From the project directory:

```bash
docker compose up -d
```

If your system uses the older Docker Compose binary:

```bash
docker-compose up -d
```

Open:

```text
Grafana:      http://localhost:3000
Prometheus:  http://localhost:9090
Alertmanager: http://localhost:9093
```

Default Grafana login:

```text
Username: admin
Password: admin
```

Prometheus will automatically scrape Node Exporter and load the alert rules from `prometheus/alert-rules.yml`.

## Run Linux Health Checks

On a Linux system:

```bash
chmod +x scripts/*.sh
./scripts/linux-health-check.sh
./scripts/disk-usage-check.sh /
./scripts/tls-cert-check.sh example.com 443
./scripts/semaphore-capacity-check.sh
```

## Run Ansible Baseline Check

On a Linux system with Ansible installed:

```bash
ansible-playbook -i ansible/inventory.ini ansible/linux-baseline-check.yml
```

## Resume Project Summary

Built a Linux SRE observability and automation lab using Docker Compose, Prometheus, Grafana, Alertmanager, Node Exporter, Ansible, and shell scripting. Implemented Linux health checks, infrastructure alert rules, certificate validation, disk usage checks, kernel parameter validation, incident runbooks, and RCA templates to simulate production support and reliability workflows.

## LinkedIn Project Summary

Linux SRE Observability and Automation Lab: Designed a hands-on SRE lab for Linux infrastructure monitoring, alerting, automation, and incident response using Prometheus, Grafana, Alertmanager, Node Exporter, Ansible, shell scripting, and OpenSSL.

## Notes

This project is intentionally generic and does not include any company internal data, server names, customer information, ticket IDs, logs, or private infrastructure details.
