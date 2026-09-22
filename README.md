# Wazuh SIEM Homelab

**Wazuh · Ubuntu 22.04 LTS · Windows 11 Pro · Hyper-V · PowerShell · Windows Security Auditing · Detection Engineering**

A hands-on SOC / detection-engineering homelab built around a self-hosted Wazuh SIEM, monitoring a Windows 11 Pro endpoint. The lab was built and documented in four sequential phases, then archived (including this repository) before the Ubuntu/Wazuh virtual machine was retired.

Portfolio documentation | September 2026 | Owner: Anthony Arthur

---

## Lab Architecture

| Component | Role |
|---|---|
| Windows 11 Pro host | Hyper-V host and monitored endpoint (`WIN11PRO-ENDPOINT-01`) |
| Hyper-V | Virtualization platform |
| Ubuntu 22.04 LTS VM | Wazuh all-in-one server / manager environment |
| Wazuh Windows agent | Collected endpoint telemetry and sent it to the manager |
| Wazuh dashboard / Threat Hunting | Centralized alert review and investigation interface |

## Phases

| # | Phase | Focus |
|---|---|---|
| 1 | [SIEM Deployment & Windows Endpoint Monitoring](01-siem-deployment-endpoint-monitoring/) | Stand up the Wazuh server on Ubuntu, deploy the Windows agent, verify telemetry ingestion, enable Windows Security auditing |
| 2 | [File Integrity Monitoring & Configuration Change Detection](02-file-integrity-monitoring/) | Configure Syscheck real-time FIM, simulate and investigate an unauthorized file change, remediate and validate |
| 3 | [Windows Identity & Privileged Account Activity Monitoring](03-identity-privileged-account-monitoring/) | Monitor account creation, privileged-group membership changes, and account deletion (Event IDs 4720/4732/4733/4726) |
| 4 | [Custom Brute-Force Detection & SIEM Correlation](04-brute-force-detection-siem-correlation/) | Build a custom Wazuh correlation rule that escalates 5 failed logons in 60 seconds to a Level 10 alert mapped to MITRE ATT&CK T1110 |

Each phase folder has its own README with the full objective, implementation steps, evidence screenshots, analyst interpretation, and resume/LinkedIn-ready summaries.

## Command Reference

All commands used across the four phases are consolidated and reusable from [`scripts/`](scripts/):

- [`scripts/ubuntu-wazuh-server-commands.sh`](scripts/ubuntu-wazuh-server-commands.sh) — Linux-side Wazuh manager commands (resource validation, custom-rule deployment)
- [`scripts/windows-endpoint-commands.ps1`](scripts/windows-endpoint-commands.ps1) — Windows-side PowerShell/command-line commands (agent deployment, auditing, FIM testing, account lifecycle, brute-force simulation)
- [`scripts/wazuh-custom-rules.xml`](scripts/wazuh-custom-rules.xml) — the custom brute-force correlation rule from Phase 4

**Reference note:** this archive preserves the commands and configuration that were actually captured during the lab. Where an early one-time installation command was not preserved, the documentation says so rather than inventing one — this is intended as an honest portfolio record.

## Skills Demonstrated

- SIEM deployment and administration (Wazuh manager + Windows agent)
- Hyper-V virtualization and Linux/Windows VM administration
- Windows Security auditing (logon, account management) and Event ID investigation
- File Integrity Monitoring (Syscheck) — configuration, detection, before/after hash and diff analysis
- Identity and privileged-access lifecycle monitoring (account create → privilege escalate → privilege remove → delete)
- Detection engineering: writing, validating, and deploying a custom Wazuh correlation rule mapped to MITRE ATT&CK
- SOC-style alert triage and disposition (true positive vs. authorized activity)
