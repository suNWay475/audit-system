# System Audit Report Script

A Bash script that automatically collects a system health snapshot and saves it as a dated report file. Built as a Junior SysAdmin / DevOps practice project.

## Features

- Collects hostname, uptime, and OS version
- Checks disk usage on all real partitions (`/dev/*`)
- Prints `[WARNING]` if any partition exceeds 80% usage
- Reports RAM usage (total / used / free)
- Lists top 5 processes by CPU consumption
- Shows last 5 failed SSH login attempts from `auth.log`
- Saves a timestamped report file per run to `/var/log/audit/`

## Project Structure

```
system-audit-script/
├── monitor-system.sh       # Main script
└── README.md
```

## Requirements

- Linux (Ubuntu 22.04+ recommended)
- Bash 4+
- Standard utilities: `df`, `ps`, `free`, `awk`, `grep`
- Root or sudo access (required to write to `/var/log/audit/`)

## Setup

1. Clone the repository

```bash
git clone https://github.com/suNWay475/audit-system
cd system-audit-script
```

2. Make the script executable

```bash
chmod +x audit.sh
```

3. Run with sudo

```bash
sudo ./audit.sh
```

The report will be saved to:

```
/var/log/audit/report_YYYY-MM-DD.txt
```

## Configuration

The disk usage warning threshold can be changed directly in the script:

```bash
threshold=80
```

## Sample Output

```
========== INFORMATION-ABOUT-SYSTEM ==========
Date: 2025-06-10 | Time: 14:32:07
Hostname:   my-server
Uptime:     up 3 days, 5 hours, 12 minutes
OS Version: Ubuntu 22.04.3 LTS
----------------------------------------------
--- DISK USAGE (Checking threshold 80%) ---
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   43G    7G  86% /
[WARNING] One of the partitions is filled up to 86% (greater than 80%)!
----------------------------------------------
--- RAM USAGE ---
Total: 3.8Gi | Used: 1.2Gi | Free: 2.1Gi
----------------------------------------------
--- TOP-5 PROCESSES BY CPU ---
  PID  PPID CMD                         %CPU
 1234     1 /usr/bin/python3 app.py      4.2
----------------------------------------------
--- LAST 5 FAILED LOGINS (SSH FAILS) ---
Jun 10 13:05:21 my-server sshd[5678]: Failed password for root from 192.168.1.5
==================================================
```

## Skills Practiced

- Bash scripting (`set -euo pipefail`, loops, output redirection)
- System monitoring (`df`, `ps`, `free`)
- Text processing (`awk`, `grep`, `tr`, `cut`)
- Structured logging to files using block redirection
- Writing reusable, readable shell scripts

## Author

Vitaliy — Junior DevOps learner building hands-on Linux and Bash skills.