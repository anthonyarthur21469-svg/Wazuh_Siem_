<#
.SYNOPSIS
    Wazuh Homelab - Windows Endpoint (WIN11PRO-ENDPOINT-01) Commands

.DESCRIPTION
    Consolidated Windows PowerShell / command-line commands from all four
    phases of the Wazuh homelab: agent deployment, security auditing, file
    integrity monitoring, privileged-account lifecycle testing, and brute-
    force simulation.

    Run interactively, section by section, on the monitored Windows 11 Pro
    endpoint. Several commands are intentionally repeated at different
    checkpoints (e.g. Get-ADUser-style verification queries, service checks)
    as before/after validation evidence, not accidental duplicates.

.NOTES
    Author: Anthony Arthur
    Full write-up with screenshots: the phase READMEs in this repo.
#>

# ---------------------------------------------------------------------------
# Phase 1: Wazuh agent deployment and endpoint verification
# ---------------------------------------------------------------------------

Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.14.7-1.msi -OutFile $env:tmp\wazuh-agent
msiexec.exe /i $env:tmp\wazuh-agent /q WAZUH_MANAGER='172.30.227.145' WAZUH_AGENT_NAME='WIN11PRO-ENDPOINT-01'

Get-Service -Name WazuhSvc
Start-Service -Name WazuhSvc
Get-Service -Name WazuhSvc
Restart-Service -Name WazuhSvc

# Windows Security auditing baseline
auditpol /get /subcategory:"Logon"

# ---------------------------------------------------------------------------
# Phase 2: File Integrity Monitoring (FIM) test directory/file
# ---------------------------------------------------------------------------

New-Item -Path "C:\SOC-Lab" -ItemType Directory -Force
Set-Content -Path "C:\SOC-Lab\critical-config.txt" -Value "AUTHORIZED CONFIGURATION - VERSION 1"
Get-Content "C:\SOC-Lab\critical-config.txt"

# Simulate an unauthorized configuration change (detected by Wazuh Syscheck)
Set-Content -Path "C:\SOC-Lab\critical-config.txt" -Value "UNAUTHORIZED CONFIGURATION CHANGE"
Get-Content "C:\SOC-Lab\critical-config.txt"

# Restore the authorized baseline and confirm Wazuh detects the remediation
Set-Content -Path "C:\SOC-Lab\critical-config.txt" -Value "AUTHORIZED CONFIGURATION - VERSION 1"
Get-Content "C:\SOC-Lab\critical-config.txt"

# ---------------------------------------------------------------------------
# Phase 3: Identity and privileged-account activity monitoring
# ---------------------------------------------------------------------------

# Enable Success/Failure auditing for account-management activity
auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
auditpol /get /subcategory:"User Account Management"

# Create and verify a controlled local test account (Event ID 4720)
net user SOC-TestUser "LabOnly!2026#" /add
net user SOC-TestUser

# Simulate privilege escalation: add to local Administrators (Event ID 4732, Rule 60154)
net localgroup Administrators SOC-TestUser /add
net localgroup Administrators

# Remove privileged access (Event ID 4733)
net localgroup Administrators SOC-TestUser /delete
net localgroup Administrators

# Delete and verify account cleanup (Event ID 4726)
net user SOC-TestUser /delete
net user SOC-TestUser

# ---------------------------------------------------------------------------
# Phase 4: Controlled failed logons for custom brute-force correlation rule
# ---------------------------------------------------------------------------

# Generate repeated failed authentication attempts against a nonexistent
# account to produce Windows Event ID 4625 / Wazuh Rule 60122 telemetry.
# Run this 5+ times within 60 seconds to trigger the custom Rule 100002.
runas /user:FakeSOCUser cmd
