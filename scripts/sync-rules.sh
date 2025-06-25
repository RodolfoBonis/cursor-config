#!/bin/bash

# Script to synchronize cursor rules to a project
# Usage: ./sync-rules.sh [project_directory]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
    echo -e "${BLUE}🔄 Cursor Rules Sync${NC}"
    echo "This script synchronizes cursor rules from central repository to a project."
    echo ""
    echo "Usage:"
    echo "  $0 [project_directory]"
    echo ""
    echo "Examples:"
    echo "  $0                           # Synchronize in current directory"
    echo "  $0 ~/projects/my-project     # Synchronize in specific project"
    echo "  $0 .                         # Synchronize in current directory"
}

# Check if user asked for help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Define target directory
TARGET_DIR="${1:-$(pwd)}"

# Resolve absolute path
TARGET_DIR=$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")

# Check if directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${RED}❌ Error: Directory '$TARGET_DIR' does not exist!${NC}"
    exit 1
fi

# Path to cursor rules repository
CURSOR_CONFIG_DIR="$HOME/cursor-config"

# Check if cursor rules repository exists
if [[ ! -d "$CURSOR_CONFIG_DIR" ]]; then
    echo -e "${RED}❌ Error: cursor-config repository not found at '$CURSOR_CONFIG_DIR'!${NC}"
    echo -e "${YELLOW}💡 Make sure cursor-config repository is at ~/cursor-config${NC}"
    exit 1
fi

# Check if rules exist to synchronize
if [[ ! -d "$CURSOR_CONFIG_DIR/rules" ]] || [[ -z "$(ls -A "$CURSOR_CONFIG_DIR/rules" 2>/dev/null)" ]]; then
    echo -e "${RED}❌ Error: No rules found at '$CURSOR_CONFIG_DIR/rules'!${NC}"
    exit 1
fi

echo -e "${BLUE}🔄 Synchronizing cursor rules...${NC}"
echo -e "${YELLOW}📂 Source: $CURSOR_CONFIG_DIR/rules${NC}"
echo -e "${YELLOW}📁 Target: $TARGET_DIR/.cursor/rules${NC}"

# Create .cursor/rules structure if it doesn't exist
mkdir -p "$TARGET_DIR/.cursor/rules"

# Count files to synchronize
TOTAL_FILES=$(find "$CURSOR_CONFIG_DIR/rules" -name "*.mdc" | wc -l | tr -d ' ')

if [[ "$TOTAL_FILES" -eq 0 ]]; then
    echo -e "${RED}❌ No .mdc files found to synchronize!${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Synchronizing $TOTAL_FILES file(s)...${NC}"

# Copy all rules
cp "$CURSOR_CONFIG_DIR/rules"/*.mdc "$TARGET_DIR/.cursor/rules/" 2>/dev/null || {
    echo -e "${RED}❌ Error copying files!${NC}"
    exit 1
}

# List synchronized files
echo -e "${GREEN}✅ Rules synchronized successfully!${NC}"
echo -e "${BLUE}📁 Synchronized files:${NC}"

for file in "$TARGET_DIR/.cursor/rules"/*.mdc; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        echo -e "   ${GREEN}✓${NC} $filename"
    fi
done

# Check if it's a git repository
if [[ -d "$TARGET_DIR/.git" ]]; then
    cd "$TARGET_DIR"
    
    # Check if there are changes in rules
    if git status --porcelain .cursor/rules/ | grep -q .; then
        echo -e "${YELLOW}📝 Changes detected in cursor rules from git.${NC}"
        echo -e "${BLUE}💡 To commit changes, run:${NC}"
        echo -e "   cd '$TARGET_DIR'"
        echo -e "   git add .cursor/rules/"
        echo -e "   git commit -m 'chore: update cursor rules'"
    else
        echo -e "${GREEN}✅ No changes detected in git.${NC}"
    fi
fi

echo -e "${GREEN}🎉 Synchronization completed!${NC}"
