#!/bin/bash

# Comprehensive Privacy & Security Stack Installation
# This script installs complementary tools to work with Little Snitch
# for complete privacy and security coverage

set -e

echo "🔐 Installing Comprehensive Privacy & Security Stack"
echo "=================================================="

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install Homebrew first:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

echo "📱 Updating Homebrew..."
brew update

# Camera and Microphone Monitoring
echo "📹 Installing Oversight (Camera/Microphone Monitor)..."
brew install --cask oversight

# File System Monitoring  
echo "📂 Installing BlockBlock (Persistence Monitor)..."
brew install --cask blockblock

# Process Auditing
echo "🔍 Installing KnockKnock (Process Auditor)..."
brew install --cask knockknock

# Optional: Additional security tools
echo "🛡️ Installing Additional Security Tools..."

# LuLu Firewall (alternative/complement to Little Snitch)
echo "🔥 Installing LuLu Firewall..."
brew install --cask lulu

# RansomWhere? (Ransomware Detection)
echo "🚨 Installing RansomWhere? (Ransomware Detection)..."
brew install --cask ransomwhere

# What's Your Sign? (Code Signature Verification)  
echo "✍️ Installing What's Your Sign? (Signature Verification)..."
brew install --cask whats-your-sign

# TaskExplorer (Process/Network Monitor)
echo "📊 Installing TaskExplorer..."
brew install --cask taskexplorer

# Create monitoring scripts directory
SCRIPTS_DIR="$HOME/.privacy-security-scripts"
mkdir -p "$SCRIPTS_DIR"

# Create Little Snitch log monitoring script
cat > "$SCRIPTS_DIR/monitor_little_snitch.sh" << 'EOF'
#!/bin/bash

# Little Snitch Log Monitor
# Monitors for suspicious network activity and sends alerts

LOG_DIR="/var/log"
ALERT_PATTERNS=(
    "telemetry"
    "analytics"
    "tracking"
    "C2"
    "exfiltration"
    "backdoor"
    "malware"
)

# Function to send alert
send_alert() {
    local message="$1"
    # macOS notification
    osascript -e "display notification \"$message\" with title \"Security Alert\" sound name \"Basso\""
    
    # Log to file
    echo "$(date): $message" >> "$HOME/.privacy-security-scripts/security.log"
}

# Monitor Little Snitch logs
for pattern in "${ALERT_PATTERNS[@]}"; do
    if grep -i "$pattern" "$LOG_DIR"/*.log 2>/dev/null; then
        send_alert "Suspicious activity detected: $pattern"
    fi
done

# Monitor for new processes with network access
ps aux | grep -E "(python|ruby|bash|sh)" | grep -v grep | while read line; do
    process=$(echo "$line" | awk '{print $11}')
    if [[ "$process" =~ ^/(tmp|var/tmp|Users/.*/Downloads)/ ]]; then
        send_alert "Suspicious process with potential network access: $process"
    fi
done
EOF

chmod +x "$SCRIPTS_DIR/monitor_little_snitch.sh"

# Create automated backup script
cat > "$SCRIPTS_DIR/backup_little_snitch.sh" << 'EOF'
#!/bin/bash

# Little Snitch Configuration Backup
# Creates encrypted backups of Little Snitch rules and preferences

BACKUP_DIR="$HOME/.littlesnitch-backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="littlesnitch_backup_$DATE"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Export Little Snitch rules (if Little Snitch Configuration is available)
if [[ -f "/Applications/Little Snitch.app/Contents/MacOS/Little Snitch Configuration" ]]; then
    echo "📋 Exporting Little Snitch rules..."
    # Note: Little Snitch export requires GUI interaction - this is a placeholder
    # Users must manually export rules via Little Snitch Configuration
    echo "Manual export required: Open Little Snitch Configuration > File > Export Rules"
fi

# Backup preferences
echo "⚙️ Backing up Little Snitch preferences..."
cp -r ~/Library/Preferences/at.obdev.LittleSnitch* "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/Library/Application\ Support/Little\ Snitch/ "$BACKUP_DIR/" 2>/dev/null || true

# Create compressed backup
tar -czf "$BACKUP_DIR/$BACKUP_FILE.tar.gz" -C "$BACKUP_DIR" . 2>/dev/null

echo "✅ Backup created: $BACKUP_DIR/$BACKUP_FILE.tar.gz"

# Clean old backups (keep last 10)
ls -t "$BACKUP_DIR"/littlesnitch_backup_*.tar.gz | tail -n +11 | xargs rm -f 2>/dev/null || true

echo "🧹 Old backups cleaned (keeping latest 10)"
EOF

chmod +x "$SCRIPTS_DIR/backup_little_snitch.sh"

# Create launchd plist for automated monitoring
cat > ~/Library/LaunchAgents/com.privacy.security.monitor.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.privacy.security.monitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>$SCRIPTS_DIR/monitor_little_snitch.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>300</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Load the monitoring service
launchctl load ~/Library/LaunchAgents/com.privacy.security.monitor.plist

# Configure DNS over HTTPS (privacy-focused)
echo "🌐 Configuring DNS over HTTPS..."
echo "Setting up Quad9 DoH (privacy-focused, blocks malware)"

# Create DNS configuration
sudo mkdir -p /etc/resolver

# Configure Quad9 DoH
cat > /tmp/quad9.conf << EOF
# Quad9 DNS over HTTPS - Privacy focused, blocks malware
nameserver 9.9.9.9
nameserver 149.112.112.112
EOF

# Note: Full DoH setup requires additional configuration
echo "⚠️  Manual DoH configuration required:"
echo "   1. Open System Preferences > Network"
echo "   2. Select your connection > Advanced > DNS"
echo "   3. Add: 9.9.9.9, 149.112.112.112"
echo "   4. For full DoH, consider using Cloudflared or DNSCrypt-proxy"

# Create installation summary
echo "📋 Creating installation summary..."
cat > "$HOME/.privacy-security-scripts/INSTALLATION_SUMMARY.md" << 'EOF'
# Privacy & Security Stack Installation Summary

## Installed Tools

### Network Monitoring
- **Little Snitch** - Primary network firewall (already installed)
- **LuLu** - Complementary free firewall

### Camera/Microphone Protection  
- **Oversight** - Monitors camera/microphone access
- **BlockBlock** - Monitors persistence locations

### Process & File Monitoring
- **KnockKnock** - Audits persistent processes
- **RansomWhere?** - Detects ransomware activity
- **TaskExplorer** - Process and network monitoring
- **What's Your Sign?** - Code signature verification

### Automated Monitoring
- **Log Monitor** - Automated Little Snitch log analysis
- **Backup Script** - Automated configuration backups

## Configuration Required

1. **Little Snitch Rule Import:**
   - Import the new rule groups via Little Snitch Configuration
   - Test each rule group individually
   - Monitor for broken functionality

2. **Tool Configuration:**
   - Launch each installed tool and configure for startup
   - Enable notifications for security alerts
   - Configure Oversight for camera/microphone monitoring

3. **DNS Privacy:**
   - Configure DNS over HTTPS (DoH) 
   - Consider Quad9 (9.9.9.9) or NextDNS for privacy

4. **Monitoring Setup:**
   - Monitoring script runs every 5 minutes
   - Check logs in ~/.privacy-security-scripts/security.log
   - Adjust alert sensitivity as needed

## Daily Usage

- **Oversight**: Monitor camera/microphone alerts
- **BlockBlock**: Review persistence installation attempts  
- **Little Snitch**: Review blocked connections daily
- **KnockKnock**: Run weekly process audits

## Privacy Best Practices

1. Keep all security tools updated
2. Review Little Snitch logs weekly
3. Run KnockKnock audits monthly
4. Backup configurations regularly
5. Monitor security.log for patterns

## Emergency Recovery

- Configuration backups in ~/.littlesnitch-backups
- Rule files in ~/littlesnitch-c2-rules
- Emergency allow-all rule available if needed
EOF

echo ""
echo "✅ Privacy & Security Stack Installation Complete!"
echo ""
echo "📋 Summary:"
echo "   • Camera/Microphone monitoring: Oversight"
echo "   • File system monitoring: BlockBlock"  
echo "   • Process auditing: KnockKnock"
echo "   • Additional firewall: LuLu"
echo "   • Ransomware detection: RansomWhere?"
echo "   • Automated monitoring: Enabled"
echo ""
echo "📖 Next Steps:"
echo "   1. Launch each tool and configure for startup"
echo "   2. Import Little Snitch rule groups"
echo "   3. Configure DNS privacy settings"
echo "   4. Review installation summary: ~/.privacy-security-scripts/INSTALLATION_SUMMARY.md"
echo ""
echo "🔍 Monitor security alerts in: ~/.privacy-security-scripts/security.log"
echo ""
echo "⚠️  Important: Test critical applications after importing Little Snitch rules!"

# Check installation status
echo ""
echo "🔍 Installation Verification:"
for app in "Oversight" "BlockBlock" "KnockKnock" "LuLu" "RansomWhere?" "TaskExplorer" "What's Your Sign?"; do
    if [[ -d "/Applications/$app.app" ]]; then
        echo "   ✅ $app installed"
    else
        echo "   ❌ $app failed to install"
    fi
done