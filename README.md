# Little Snitch C2 Defense Rules

Advanced Command & Control (C2) defense rules for Little Snitch, designed to detect and block malicious network communications while preserving legitimate traffic.

## Rule Groups

### Core C2 Protection
- **c2_frameworks.lsrules** - Blocks Cobalt Strike, Metasploit, and suspicious TLDs
- **crypto_mining.lsrules** - Blocks cryptocurrency mining pools used by malware
- **dynamic_dns.lsrules** - Blocks Dynamic DNS services commonly used for C2
- **suspicious_processes.lsrules** - Blocks network access for pentesting tools
- **tor_block.lsrules** - Blocks Tor network access to prevent anonymous C2

### VM-Specific Protection
- **smart_vm_c2_detection.lsrules** - Intelligent C2 detection for VM traffic
- **vm_c2_detection.lsrules** - Enhanced VM monitoring rules

## How to Use

1. **Import via Remote Rule Group in Little Snitch Configuration:**
   ```
   https://YOUR_USERNAME.github.io/littlesnitch-c2-rules/FILENAME.lsrules
   ```

2. **Example URLs:**
   ```
   https://YOUR_USERNAME.github.io/littlesnitch-c2-rules/smart_vm_c2_detection.lsrules
   https://YOUR_USERNAME.github.io/littlesnitch-c2-rules/c2_frameworks.lsrules
   ```

## Features

- **Smart Detection**: Blocks known bad domains while allowing legitimate traffic
- **VM Protection**: Special rules for detecting C2 traffic hiding behind VM processes
- **Behavioral Analysis**: Focuses on suspicious patterns rather than blanket blocking
- **Regular Updates**: Rules can be updated by pushing to this repository

## Security Note

These rules are designed for defense against advanced persistent threats (APTs) and sophisticated malware that uses legitimate infrastructure for C2 communications.

## Installation

1. Open **Little Snitch Configuration**
2. Go to **Rule Groups**
3. Click **"+" → Remote Rule Group**
4. Enter the GitHub Pages URL for each rule file
5. Enable the imported rule groups

## Updates

Rules are automatically updated when you refresh the remote rule groups in Little Snitch.
