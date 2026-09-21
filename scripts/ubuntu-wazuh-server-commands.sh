#!/usr/bin/env bash
#
# Wazuh Homelab - Ubuntu / Wazuh Server Commands
# Environment: Ubuntu 22.04 LTS (Wazuh all-in-one manager), Hyper-V
#
# Consolidated Linux-side commands from the Wazuh homelab (Phases 1 and 4).
# Run interactively / section by section - not intended as an unattended script.

# ---------------------------------------------------------------------------
# Phase 1: Pre-deployment validation and storage work
# ---------------------------------------------------------------------------

free -h                    # Memory and swap usage - confirm the Wazuh VM has sufficient RAM
nproc                      # Number of available CPU processing units
df -h /                    # Used/available storage on the Ubuntu root filesystem
lsblk                      # Disks, partitions, and mount points - verify storage layout
hostname -I                # Ubuntu/Wazuh VM IP address (dashboard access, agent enrollment)
hostname -I | awk '{print $1}'   # First IP address only, for quick reference

# Note: the exact Wazuh all-in-one installer command used during the earliest
# installation step was not preserved in the archived command history, so it
# is intentionally not reconstructed here (see the project README for why).

# ---------------------------------------------------------------------------
# Phase 4: Custom correlation rule - create, validate, load
# ---------------------------------------------------------------------------

sudo nano /var/ossec/etc/rules/local_rules.xml
# Add the custom brute-force correlation rule (see wazuh-custom-rules.xml
# in this scripts/ folder), then save and exit.

sudo /var/ossec/bin/wazuh-analysisd -t          # Validate the rules/config before restarting
sudo systemctl restart wazuh-manager            # Restart the manager so the new rule loads
sudo systemctl status wazuh-manager --no-pager  # Confirm the manager returned to active/running
