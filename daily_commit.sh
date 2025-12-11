#!/bin/bash

# GitHub Daily Commit Script for Grass Planting
# This script creates multiple daily commits to maintain GitHub contribution graph

# Configuration
REPO_DIR="$HOME/daily"
COMMIT_FILE="daily.txt"

# Navigate to repository directory
cd "$REPO_DIR" || exit 1

# Generate random number between 1 and 10
COMMIT_COUNT=$((RANDOM % 10 + 1))

echo "Making $COMMIT_COUNT commits today"

# Make random number of commits
for i in $(seq 1 $COMMIT_COUNT); do
    # Get current date and time for each commit
    DATE=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Create or update the daily file
    echo "Daily commit #$i on $DATE" >> "$COMMIT_FILE"
    
    # Add changes to git
    git add "$COMMIT_FILE"
    
    # Create commit with current date
    git commit -m "Daily commit #$i: $DATE"
    
    # Small delay between commits (optional)
    sleep 1
done

# Push all commits to remote repository
git push origin main

echo "Daily commits completed: $COMMIT_COUNT commits made"