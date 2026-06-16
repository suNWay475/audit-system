#!/bin/bash
set -euo pipefail

REPORT_DIR="/var/log/audit"
REPORT_FILE="$REPORT_DIR/report_$(date +%F).txt"
threshold=80

# 1. Create the DIRECTORY if it doesn't exist (not the file itself)
mkdir -p "$REPORT_FILE"

df_values=$(df -h | grep '^/dev/' | awk '{print $5}' | tr -d '%')
cpu="$(ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6)"

# memory total,used,and free
mem="$(free -h | awk '/Mem:/ {print "Total: " $2 " | Used: " $3 " | Free: " $4}')"

Time="$(date +%Y-%m-%d)"
times="$(date +%H:%M:%S)"
# THE TRICK: Open a code block. Everything inside will be saved to the file!
{
    echo "========== INFORMATION-ABOUT-SYSTEM =========="
    echo "Date: $Time | Time: $times"
    echo "Hostname:   $(hostname)"
    echo "Uptime:     $(uptime -p)"
    echo "OS Version: $(grep 'PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '"')"
    echo "----------------------------------------------"
    
    echo "--- DISK USAGE (Checking threshold $threshold%) ---"
    # Show the actual disk status so the report remains informative
    df -h | grep -E '^Filesystem|^/dev/'
    
    # for every process in dev
    for i in $df_values; do 
        if [ "$i" -gt "$threshold" ]; then 
            echo "[WARNING] One of the partitions is filled up to $i% (greater than $threshold%)!"
        fi 
    done
    echo "----------------------------------------------"

    echo "--- RAM USAGE ---"
    echo "$mem"
    echo "----------------------------------------------"

    echo "--- TOP-5 PROCESSES BY CPU ---"
    echo "$cpu"
    echo "----------------------------------------------"

    # REQUIREMENT 6: Last 5 failed system logins (SSH fails)
    echo "--- LAST 5 FAILED LOGINS (SSH FAILS) ---"
    if [ -f /var/log/auth.log ]; then
        grep -E "Failed password|Invalid user" /var/log/auth.log | tail -n 5 || echo "No failed login attempts found."
    else
        echo "Log file /var/log/auth.log not found (rsyslog might be missing)."
    fi
    
    echo "=================================================="
} > "$REPORT_FILE" 

# =====================================================================
# END OF BLOCK. We specified > "$REPORT_FILE" once here, and everything is saved!
# =====================================================================

echo " Report successfully generated!"
echo " Saved to: $REPORT_FILE"