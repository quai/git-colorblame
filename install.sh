#!/bin/bash
#
# Install git-colorblame for the current user
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/git-colorblame"

if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo "Error: git-colorblame not found in $SCRIPT_DIR"
    exit 1
fi

# Ensure script is executable
chmod +x "$SCRIPT_PATH"

# Add git alias pointing to the script
git config --global alias.colorblame "!$SCRIPT_PATH"

echo "Installed git-colorblame as 'git colorblame'"
echo "Usage: git colorblame <file>"
