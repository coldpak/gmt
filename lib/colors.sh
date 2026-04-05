#!/usr/bin/env bash
# colors.sh — ANSI color constants and utilities

# Basic colors
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_DIM="\033[2m"
C_WHITE="\033[37m"
C_GRAY="\033[90m"
C_GREEN="\033[32m"
C_YELLOW="\033[33m"
C_BLUE="\033[34m"
C_CYAN="\033[36m"
C_RED="\033[31m"
C_MAGENTA="\033[35m"

# Heatmap colors (256-color)
COLOR_NONE="\033[38;5;237m"
COLOR_LOW="\033[38;5;22m"
COLOR_MED="\033[38;5;28m"
COLOR_HIGH="\033[38;5;34m"
COLOR_MAX="\033[38;5;46m"

# Check if terminal supports 256 colors
supports_256_color() {
  [[ "${TERM}" =~ 256color ]] || [[ -n "${COLORTERM}" ]]
}
