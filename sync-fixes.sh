#!/bin/bash

# EKS Troubleshooting Workshop - Git Sync Helper
# This script helps sync fixes back to the GitHub repository

set -e

echo "=== EKS Workshop - Git Sync Helper ==="

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check for uncommitted changes or untracked files
if ! git diff-index --quiet HEAD -- || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo "📝 Found uncommitted changes:"
    git status --porcelain
    echo ""
    
    # Ask user if they want to commit
    read -p "🤔 Do you want to commit these changes? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Get commit message from user
        echo "💬 Enter commit message (or press Enter for default):"
        read -r commit_msg
        
        if [ -z "$commit_msg" ]; then
            commit_msg="Fix: Workshop troubleshooting updates"
        fi
        
        # Add all changes and commit
        git add .
        git commit -m "$commit_msg"
        echo "✅ Changes committed successfully"
        
        # Ask if they want to push
        read -p "🚀 Push to GitHub? (y/n): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push origin main
            echo "🎉 Changes pushed to GitHub successfully!"
        else
            echo "📦 Changes committed locally. Run 'git push origin main' to sync to GitHub."
        fi
    else
        echo "⏸️  Changes not committed. Run this script again when ready."
    fi
else
    echo "✅ Repository is up to date - no changes to sync"
fi

echo ""
echo "🔗 Repository: https://github.com/pravinmenghani1/eks-troubleshooting-workshop"
