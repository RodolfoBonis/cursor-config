#!/bin/bash

# Script to create symlink of cursor rules
# Usage: ./link-rules.sh [project_directory]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
    echo -e "${BLUE}🔗 Cursor Rules Link${NC}"
    echo "This script creates a symlink of cursor rules from central repository to a project."
    echo "Useful for development, as it keeps rules always automatically updated."
    echo ""
    echo "Usage:"
    echo "  $0 [project_directory]"
    echo ""
    echo "Examples:"
    echo "  $0                           # Create symlink in current directory"
    echo "  $0 ~/projects/my-project     # Create symlink in specific project"
    echo "  $0 .                         # Create symlink in current directory"
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

# Check if rules exist to link
if [[ ! -d "$CURSOR_CONFIG_DIR/rules" ]] || [[ -z "$(ls -A "$CURSOR_CONFIG_DIR/rules" 2>/dev/null)" ]]; then
    echo -e "${RED}❌ Error: No rules found at '$CURSOR_CONFIG_DIR/rules'!${NC}"
    exit 1
fi

echo -e "${BLUE}🔗 Creating symlink of cursor rules...${NC}"
echo -e "${YELLOW}📂 Source: $CURSOR_CONFIG_DIR/rules${NC}"
echo -e "${YELLOW}📁 Target: $TARGET_DIR/.cursor/rules${NC}"

# Create .cursor directory if it doesn't exist
mkdir -p "$TARGET_DIR/.cursor"

# Remove rules directory if it exists (to avoid conflicts)
if [[ -d "$TARGET_DIR/.cursor/rules" ]] || [[ -L "$TARGET_DIR/.cursor/rules" ]]; then
    echo -e "${YELLOW}⚠️  Removing existing directory/symlink...${NC}"
    rm -rf "$TARGET_DIR/.cursor/rules"
fi

# Create symlink
ln -s "$CURSOR_CONFIG_DIR/rules" "$TARGET_DIR/.cursor/rules"

# Check if symlink was created correctly
if [[ -L "$TARGET_DIR/.cursor/rules" ]] && [[ -d "$TARGET_DIR/.cursor/rules" ]]; then
    echo -e "${GREEN}✅ Symlink created successfully!${NC}"
    
    # List available files through symlink
    echo -e "${BLUE}📁 Available files:${NC}"
    for file in "$TARGET_DIR/.cursor/rules"/*.mdc; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            echo -e "   ${GREEN}✓${NC} $filename"
        fi
    done
    
    echo -e "${BLUE}💡 Rules are now automatically updated when you modify the central repository!${NC}"
else
    echo -e "${RED}❌ Error creating symlink!${NC}"
    exit 1
fi

# Check if it's a git repository
if [[ -d "$TARGET_DIR/.git" ]]; then
    echo -e "${YELLOW}📝 Remember to add .cursor/rules to .gitignore if needed.${NC}"
    echo -e "${BLUE}💡 To add to .gitignore:${NC}"
    echo -e "   echo '.cursor/rules' >> '$TARGET_DIR/.gitignore'"
fi

echo -e "${GREEN}🎉 Symlink created successfully!${NC}"
