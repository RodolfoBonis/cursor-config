#!/bin/bash

# Script to configure a new project with cursor rules
# Usage: ./setup-project.sh [project_directory] [mode]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
    echo -e "${BLUE}🚀 Cursor Project Setup${NC}"
    echo "This script configures a project with cursor rules."
    echo ""
    echo "Usage:"
    echo "  $0 [directory] [mode]"
    echo ""
    echo "Modes:"
    echo "  copy    - Copy rules (default)"
    echo "  link    - Create symlink (recommended for development)"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Configure current project with copy"
    echo "  $0 ~/projects/new-project            # Configure specific project"
    echo "  $0 ~/projects/new-project link       # Configure with symlink"
    echo "  $0 . link                            # Configure current with symlink"
}

# Check if user asked for help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Define parameters
TARGET_DIR="${1:-$(pwd)}"
MODE="${2:-copy}"

# Validate mode
if [[ "$MODE" != "copy" && "$MODE" != "link" ]]; then
    echo -e "${RED}❌ Error: Invalid mode '$MODE'. Use 'copy' or 'link'.${NC}"
    exit 1
fi

# Resolve absolute path
TARGET_DIR=$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")

# Check if directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${YELLOW}📁 Directory '$TARGET_DIR' does not exist. Creating...${NC}"
    mkdir -p "$TARGET_DIR"
fi

# Path to cursor rules repository
CURSOR_CONFIG_DIR="$HOME/cursor-config"
SCRIPTS_DIR="$CURSOR_CONFIG_DIR/scripts"

echo -e "${PURPLE}🚀 Configuring project with cursor rules...${NC}"
echo -e "${BLUE}📁 Project: $TARGET_DIR${NC}"
echo -e "${BLUE}🔧 Mode: $MODE${NC}"

# Execute appropriate script
if [[ "$MODE" == "link" ]]; then
    if [[ -f "$SCRIPTS_DIR/link-rules.sh" ]]; then
        echo -e "${BLUE}🔗 Creating symlink...${NC}"
        bash "$SCRIPTS_DIR/link-rules.sh" "$TARGET_DIR"
    else
        echo -e "${RED}❌ Script link-rules.sh not found!${NC}"
        exit 1
    fi
else
    if [[ -f "$SCRIPTS_DIR/sync-rules.sh" ]]; then
        echo -e "${BLUE}📋 Copying rules...${NC}"
        bash "$SCRIPTS_DIR/sync-rules.sh" "$TARGET_DIR"
    else
        echo -e "${RED}❌ Script sync-rules.sh not found!${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Project configured successfully!${NC}"
echo -e "${PURPLE}🎯 Project ready to use with cursor rules!${NC}"
