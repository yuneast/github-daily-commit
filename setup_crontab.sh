#!/bin/bash

# Setup script for crontab configuration

echo "GitHub Daily Commit Crontab Setup"
echo "=================================="

# Get current directory
CURRENT_DIR=$(pwd)
SCRIPT_PATH="$CURRENT_DIR/daily_commit.sh"
LOG_PATH="$CURRENT_DIR/cron.log"

echo "Script path: $SCRIPT_PATH"
echo "Log path: $LOG_PATH"

# Make sure script is executable
chmod +x "$SCRIPT_PATH"

echo ""
echo "Crontab entry options:"
echo "1. Daily at 9:00 AM:"
echo "   0 9 * * * $SCRIPT_PATH >> $LOG_PATH 2>&1"
echo ""
echo "2. Daily at 6:00 PM:"
echo "   0 18 * * * $SCRIPT_PATH >> $LOG_PATH 2>&1"
echo ""
echo "3. Daily at random time (9-18 hours):"
echo "   0 \$(shuf -i 9-18 -n 1) * * * $SCRIPT_PATH >> $LOG_PATH 2>&1"
echo ""

read -p "Do you want to add crontab entry automatically? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter hour (0-23) for daily execution: " HOUR
    
    # Add to crontab
    (crontab -l 2>/dev/null; echo "0 $HOUR * * * $SCRIPT_PATH >> $LOG_PATH 2>&1") | crontab -
    
    echo "Crontab entry added successfully!"
    echo "Current crontab:"
    crontab -l
else
    echo "Please manually add one of the above entries to your crontab using:"
    echo "crontab -e"
fi

echo ""
echo "Setup completed!"