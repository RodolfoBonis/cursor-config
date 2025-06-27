#!/bin/bash

# Script to update central cursor rules and apply to current project
# Usage: ./cursor-update-rules.sh [sync|link] [project_directory]

set -e

# Colors for output  
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
    echo -e "${BLUE}🔄 Cursor Rules Update${NC}"
    echo "This script updates central cursor rules and applies them to the project."
    echo ""
    echo "Usage:"
    echo "  $0 [mode] [project_directory]"
    echo ""
    echo "Modes:"
    echo "  sync    - Copy rules to project (default)"
    echo "  link    - Create symlink to project"
    echo ""
    echo "Examples:"
    echo "  $0                           # Update and apply sync in current directory"
    echo "  $0 sync                      # Update and apply sync in current directory"
    echo "  $0 link                      # Update and apply link in current directory"
    echo "  $0 sync ~/projects/my-project # Update and apply sync to specific project"
    echo "  $0 link ~/projects/my-project # Update and apply link to specific project"
    echo ""
    echo "The script executes:"
    echo "  1. git pull on cursor-config repository"
    echo "  2. Apply rules to project using specified mode"
}

# Check if user asked for help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Define mode (sync or link)
MODE=""
TARGET_DIR=""

# Parse arguments
if [[ "$1" == "sync" || "$1" == "link" ]]; then
    MODE="$1"
    TARGET_DIR="${2:-$(pwd)}"
elif [[ -n "$1" && "$1" != "sync" && "$1" != "link" ]]; then
    # If first argument is not sync or link, assume it's a directory
    MODE="sync"
    TARGET_DIR="$1"
else
    # No arguments, use sync in current directory
    MODE="sync"
    TARGET_DIR="$(pwd)"
fi

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

echo -e "${CYAN}🚀 Cursor Rules Update${NC}"
echo -e "${BLUE}📂 Repository: $CURSOR_CONFIG_DIR${NC}"
echo -e "${BLUE}🎯 Project: $TARGET_DIR${NC}"
echo -e "${BLUE}🔧 Mode: $MODE${NC}"
echo ""

# Step 1: Update cursor-config repository
echo -e "${YELLOW}📥 Step 1: Updating cursor-config repository...${NC}"
cd "$CURSOR_CONFIG_DIR"

# Check if it's a git repository
if [[ ! -d ".git" ]]; then
    echo -e "${RED}❌ Error: '$CURSOR_CONFIG_DIR' is not a git repository!${NC}"
    exit 1
fi

# Check for uncommitted local changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️  Warning: There are uncommitted changes in cursor-config repository.${NC}"
    echo -e "${YELLOW}   Local changes will be preserved.${NC}"
fi

# Perform pull
echo -e "${BLUE}🔄 Running git pull...${NC}"
if git pull; then
    echo -e "${GREEN}✅ Repository updated successfully!${NC}"
else
    echo -e "${RED}❌ Error updating repository!${NC}"
    echo -e "${YELLOW}💡 Check for conflicts or connectivity issues.${NC}"
    exit 1
fi

echo ""

# Step 2: Apply rules to project
echo -e "${YELLOW}📋 Step 2: Applying rules to project...${NC}"

# Determine which script to use
if [[ "$MODE" == "link" ]]; then
    SCRIPT_PATH="$CURSOR_CONFIG_DIR/scripts/link-rules.sh"
    echo -e "${BLUE}🔗 Creating symlinks...${NC}"
else
    SCRIPT_PATH="$CURSOR_CONFIG_DIR/scripts/sync-rules.sh"
    echo -e "${BLUE}📋 Synchronizing files...${NC}"
fi

# Check if script exists
if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo -e "${RED}❌ Error: Script '$SCRIPT_PATH' not found!${NC}"
    exit 1
fi

# Execute script
if bash "$SCRIPT_PATH" "$TARGET_DIR"; then
    echo ""
    echo -e "${GREEN}🎉 Update completed successfully!${NC}"
    echo ""
    echo -e "${CYAN}📊 Summary:${NC}"
    echo -e "   ${GREEN}✓${NC} cursor-config repository updated"
    echo -e "   ${GREEN}✓${NC} Rules applied to project using '$MODE' mode"
    echo -e "   ${GREEN}✓${NC} Project: $TARGET_DIR"
    
    # Additional information based on mode
    if [[ "$MODE" == "link" ]]; then
        echo ""
        echo -e "${YELLOW}💡 Symlink mode active:${NC}"
        echo -e "   - Future updates will be automatic"
        echo -e "   - Add .cursor/rules to .gitignore if needed"
    else
        echo ""
        echo -e "${YELLOW}💡 Sync mode active:${NC}"
        echo -e "   - Run 'cursor-update-rules' for future updates"
        echo -e "   - Rules have been copied and can be versioned"
    fi
else
    echo -e "${RED}❌ Error applying rules to project!${NC}"
    exit 1
fi 