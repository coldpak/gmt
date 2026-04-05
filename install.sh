#!/usr/bin/env bash
# install.sh — GMT installer
# Usage: bash install.sh
#   or:  curl -sL <url>/install.sh | bash

set -euo pipefail

GMT_DIR="${HOME}/.gmt"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "  ☀ Installing Good Morning Terminal..."
echo ""

# Copy files to ~/.gmt
if [[ "$REPO_DIR" != "$GMT_DIR" ]]; then
  mkdir -p "$GMT_DIR"
  cp -r "$REPO_DIR"/gmt.sh "$GMT_DIR/"
  cp -r "$REPO_DIR"/modules "$GMT_DIR/"
  cp -r "$REPO_DIR"/lib "$GMT_DIR/"
  cp -r "$REPO_DIR"/lang "$GMT_DIR/"
  # Only copy config.sh if it doesn't exist (preserve user settings)
  [[ ! -f "$GMT_DIR/config.sh" ]] && cp "$REPO_DIR"/config.sh "$GMT_DIR/"
else
  echo "  Already in ~/.gmt, skipping copy."
fi

mkdir -p "$GMT_DIR/data" "$GMT_DIR/cache"

# Detect shell and rc file
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in
  zsh)  RC_FILE="$HOME/.zshrc" ;;
  bash) RC_FILE="$HOME/.bashrc" ;;
  *)    RC_FILE="$HOME/.${SHELL_NAME}rc" ;;
esac

# Add source line if not present
SOURCE_LINE="source \"${GMT_DIR}/gmt.sh\""
if [[ -f "$RC_FILE" ]] && grep -qF "gmt.sh" "$RC_FILE"; then
  echo "  Already added to ${RC_FILE}"
else
  echo "" >> "$RC_FILE"
  echo "# Good Morning Terminal" >> "$RC_FILE"
  echo "$SOURCE_LINE" >> "$RC_FILE"
  echo "  Added to ${RC_FILE}"
fi

echo ""
echo "  Done! Restart your terminal or run:"
echo "    source ${RC_FILE}"
echo ""
