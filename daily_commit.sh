#!/bin/bash

# GitHub Daily Commit Script for Grass Planting
# This script creates multiple daily commits, PR, and code reviews to maintain GitHub contribution graph

# Configuration
REPO_DIR="$HOME/daily"
COMMIT_FILE="daily.txt"
BASE_BRANCH="main"

# Navigate to repository directory
cd "$REPO_DIR" || exit 1

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed."
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if gh is authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: GitHub CLI is not authenticated."
    echo "Please run: gh auth login"
    exit 1
fi

# Get current date for branch name
BRANCH_DATE=$(date '+%Y-%m-%d')
BRANCH_NAME="daily-update-$BRANCH_DATE"

# Generate random number between 1 and 10
COMMIT_COUNT=$((RANDOM % 10 + 1))

echo "Making $COMMIT_COUNT commits today"
echo "Creating branch: $BRANCH_NAME"

# Ensure we're on main branch and it's up to date
git checkout "$BASE_BRANCH" 2>/dev/null || git checkout -b "$BASE_BRANCH"
git pull origin "$BASE_BRANCH" 2>/dev/null || true

# Create new branch for today's updates
git checkout -b "$BRANCH_NAME" 2>/dev/null || git checkout "$BRANCH_NAME"

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

# Push branch to remote
echo "Pushing branch to remote..."
if git push origin "$BRANCH_NAME" 2>&1; then
    echo "Branch $BRANCH_NAME pushed successfully"
else
    echo "Error: Failed to push branch $BRANCH_NAME"
    git push origin "$BRANCH_NAME" -f 2>&1 || {
        echo "Fatal: Unable to push branch. Exiting."
        exit 1
    }
fi

# Wait a moment for GitHub to process the push
sleep 2

# Create PR
echo "Creating Pull Request..."
PR_TITLE="Daily update for $BRANCH_DATE"
PR_BODY="자동 생성된 일일 업데이트 PR입니다. ($COMMIT_COUNT commits)"

# Check if PR already exists
EXISTING_PR=$(gh pr list --head "$BRANCH_NAME" --json number --jq '.[0].number' 2>/dev/null)

PR_NUMBER=""

if [ -z "$EXISTING_PR" ] || [ "$EXISTING_PR" = "null" ]; then
    # Create new PR with error output
    echo "Attempting to create PR from $BRANCH_NAME to $BASE_BRANCH..."
    PR_OUTPUT=$(gh pr create \
        --title "$PR_TITLE" \
        --body "$PR_BODY" \
        --base "$BASE_BRANCH" \
        --head "$BRANCH_NAME" \
        --json number,url 2>&1)
    
    PR_EXIT_CODE=$?
    
    if [ $PR_EXIT_CODE -eq 0 ]; then
        PR_NUMBER=$(echo "$PR_OUTPUT" | jq -r '.number' 2>/dev/null || echo "")
        PR_URL=$(echo "$PR_OUTPUT" | jq -r '.url' 2>/dev/null || echo "")
        
        if [ -n "$PR_NUMBER" ] && [ "$PR_NUMBER" != "null" ] && [ "$PR_NUMBER" != "" ]; then
        echo "PR #$PR_NUMBER created successfully"
        
        # Add code review comments
        echo "Adding code review comments..."
        
        # Generate random review comments
        REVIEW_COMMENTS=(
            "좋은 업데이트입니다! 👍"
            "코드가 깔끔하게 작성되었네요."
            "잘하셨습니다! 계속 좋은 작업 부탁드립니다."
            "훌륭한 개선이네요. 👍"
            "코드 리뷰 완료했습니다!"
        )
        
        RANDOM_INDEX=$((RANDOM % ${#REVIEW_COMMENTS[@]}))
        REVIEW_COMMENT="${REVIEW_COMMENTS[$RANDOM_INDEX]}"
        
        # Approve PR and add comment
        gh pr review "$PR_NUMBER" --approve --body "$REVIEW_COMMENT" 2>/dev/null || \
        gh pr comment "$PR_NUMBER" --body "$REVIEW_COMMENT" 2>/dev/null
        
        echo "Code review added to PR #$PR_NUMBER"
        
        # Merge PR automatically to make commits count for contribution graph
        echo "Merging PR to main branch..."
        sleep 2  # Wait a moment before merging
        gh pr merge "$PR_NUMBER" --merge --delete-branch 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "PR #$PR_NUMBER merged successfully!"
            # Pull merged changes
            git pull origin "$BASE_BRANCH" 2>/dev/null || true
        else
            echo "Warning: Failed to merge PR automatically. Please merge manually to show commits in contribution graph."
        fi
    else
            echo "Warning: Failed to parse PR number from output"
            echo "PR creation output: $PR_OUTPUT"
            echo "You can manually create PR for branch: $BRANCH_NAME"
        fi
    else
        echo "Error: Failed to create PR (exit code: $PR_EXIT_CODE)"
        echo "PR creation output: $PR_OUTPUT"
        echo ""
        echo "Troubleshooting:"
        echo "1. Check if branch exists: git branch -r | grep $BRANCH_NAME"
        echo "2. Check GitHub CLI auth: gh auth status"
        echo "3. Try creating PR manually: gh pr create --head $BRANCH_NAME --base $BASE_BRANCH"
        echo ""
        echo "Branch $BRANCH_NAME has been pushed. You can create PR manually."
    fi
else
    PR_NUMBER="$EXISTING_PR"
    echo "PR #$EXISTING_PR already exists for this branch"
    
    # Update existing PR with review comment
    REVIEW_COMMENTS=(
        "추가 업데이트 완료! 👍"
        "변경사항 확인했습니다."
        "좋은 작업입니다!"
    )
    RANDOM_INDEX=$((RANDOM % ${#REVIEW_COMMENTS[@]}))
    REVIEW_COMMENT="${REVIEW_COMMENTS[$RANDOM_INDEX]}"
    
    gh pr comment "$EXISTING_PR" --body "$REVIEW_COMMENT" 2>/dev/null || true
    echo "Updated existing PR #$EXISTING_PR with review comment"
fi

# Switch back to main branch
git checkout "$BASE_BRANCH" 2>/dev/null || true

echo "Daily commits completed: $COMMIT_COUNT commits made"

# Show PR link if available
if [ -n "$PR_NUMBER" ] && [ "$PR_NUMBER" != "null" ]; then
    REPO_INFO=$(gh repo view --json owner,name -q '.owner.login + "/" + .name' 2>/dev/null)
    if [ -n "$REPO_INFO" ]; then
        echo "PR: https://github.com/$REPO_INFO/pull/$PR_NUMBER"
    else
        echo "PR #$PR_NUMBER created/updated"
    fi
else
    echo "Branch: $BRANCH_NAME"
fi