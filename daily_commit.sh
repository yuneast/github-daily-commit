#!/bin/bash

# GitHub Daily Commit Script for Grass Planting
# This script creates a daily commit to maintain GitHub contribution graph

# Configuration
REPO_DIR="$HOME/daily"
COMMIT_FILE="daily.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Navigate to repository directory
cd "$REPO_DIR" || exit 1

# Create or update the daily file
echo "Daily commit on $DATE" >> "$COMMIT_FILE"

# Add changes to git
git add "$COMMIT_FILE"

# Create commit with current date
git commit -m "Daily commit: $DATE"

# Push to remote repository
git push origin main

echo "Daily commit completed: $DATE"