#!/bin/sh
#
# Install git-colorblame
#
# This script offers two installation methods:
# 1. Copy to ~/.local/bin (recommended, standard location)
# 2. Git alias (alternative, points to current location)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="git-colorblame"
SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_NAME"

# Colors for output (if terminal supports it)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

info() {
    printf "${GREEN}%s${NC}\n" "$1"
}

warn() {
    printf "${YELLOW}%s${NC}\n" "$1"
}

error() {
    printf "${RED}%s${NC}\n" "$1" >&2
}

# Check prerequisites
if [ ! -f "$SCRIPT_PATH" ]; then
    error "Error: $SCRIPT_NAME not found in $SCRIPT_DIR"
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    error "Error: git is not installed"
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    error "Error: python3 is not installed"
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || { [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 9 ]; }; then
    error "Error: Python 3.9+ required, found $PYTHON_VERSION"
    exit 1
fi

# Ensure script is executable
chmod +x "$SCRIPT_PATH"

# Determine installation method
install_to_path() {
    # Prefer ~/.local/bin (XDG standard)
    LOCAL_BIN="$HOME/.local/bin"

    mkdir -p "$LOCAL_BIN"
    cp "$SCRIPT_PATH" "$LOCAL_BIN/$SCRIPT_NAME"
    chmod +x "$LOCAL_BIN/$SCRIPT_NAME"

    info "Installed $SCRIPT_NAME to $LOCAL_BIN"

    # Check if ~/.local/bin is in PATH
    case ":$PATH:" in
        *":$LOCAL_BIN:"*)
            info "Ready to use: git colorblame <file>"
            ;;
        *)
            warn ""
            warn "Note: $LOCAL_BIN is not in your PATH."
            warn "Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
            warn ""
            warn "    export PATH=\"\$HOME/.local/bin:\$PATH\""
            warn ""
            ;;
    esac
}

install_as_alias() {
    git config --global alias.colorblame "!$SCRIPT_PATH"
    info "Installed git alias pointing to $SCRIPT_PATH"
    warn "Note: Moving or deleting this directory will break the alias."
}

uninstall() {
    # Remove from ~/.local/bin if present
    LOCAL_BIN="$HOME/.local/bin"
    if [ -f "$LOCAL_BIN/$SCRIPT_NAME" ]; then
        rm "$LOCAL_BIN/$SCRIPT_NAME"
        info "Removed $LOCAL_BIN/$SCRIPT_NAME"
    fi

    # Remove git alias if present
    if git config --global --get alias.colorblame >/dev/null 2>&1; then
        git config --global --unset alias.colorblame
        info "Removed git alias"
    fi

    info "Uninstall complete"
}

show_help() {
    cat << EOF
Usage: $0 [OPTION]

Install git-colorblame.

Options:
  --path      Install to ~/.local/bin (recommended)
  --alias     Install as git alias (points to this directory)
  --uninstall Remove git-colorblame
  --help      Show this help

If no option is given, installs to ~/.local/bin by default.
EOF
}

# Parse arguments
case "${1:-}" in
    --path)
        install_to_path
        ;;
    --alias)
        install_as_alias
        ;;
    --uninstall)
        uninstall
        ;;
    --help|-h)
        show_help
        ;;
    "")
        # Default: install to path
        install_to_path
        ;;
    *)
        error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
