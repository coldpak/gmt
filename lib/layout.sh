#!/usr/bin/env bash
# layout.sh — Box drawing, alignment, and padding utilities

# Get terminal width (cached per render cycle)
_gmt_term_width() {
  if [[ -z "$_GMT_COLS" ]]; then
    _GMT_COLS=$(tput cols 2>/dev/null || echo 80)
  fi
  echo "$_GMT_COLS"
}

# Reset cached terminal width (call at start of each render)
_gmt_reset_term_width() {
  unset _GMT_COLS
}

# Display width — accounts for CJK and emoji double-width characters
# Usage: _gmt_display_width <string>
_gmt_display_width() {
  local str="$1"
  printf '%s' "$str" | python3 -c "
import sys, unicodedata
s = sys.stdin.read()
w = 0
for c in s:
    eaw = unicodedata.east_asian_width(c)
    cp = ord(c)
    if eaw in ('W', 'F'):
        w += 2
    elif cp > 0x1F000 or (0x2600 <= cp <= 0x27BF) or (0x2300 <= cp <= 0x23FF) or (0xFE00 <= cp <= 0xFE0F):
        w += 2
    else:
        w += 1
print(w)
" 2>/dev/null || echo ${#str}
}

# Draw a horizontal line
# Usage: draw_line [width]
draw_line() {
  local width="${1:-50}"
  local i
  for (( i = 0; i < width; i++ )); do
    printf '─'
  done
}

# Draw a box around content lines
# Usage: draw_box <content> [width]
#   content: newline-separated string, width auto-adjusts to terminal
draw_box() {
  local content="$1"
  local cols=""
  cols="$(_gmt_term_width)"
  local max_width=$(( cols - 2 ))
  local width="${2:-54}"
  (( width > max_width )) && width=$max_width
  (( width < 20 )) && width=20
  local inner=$(( width - 4 ))

  # Top border
  printf ' ┌'
  draw_line $(( width - 2 ))
  printf '┐\n'

  # Content lines
  while IFS= read -r line; do
    # Strip ANSI for width calculation
    local stripped=""
    stripped="$(printf '%s' "$line" | sed 's/\x1b\[[0-9;]*m//g')"
    local len=""
    len="$(_gmt_display_width "$stripped")"
    local pad=$(( inner - len ))
    (( pad < 0 )) && pad=0
    printf ' │  %b%*s│\n' "$line" $(( pad + 1 )) ""
  done <<< "$content"

  # Bottom border
  printf ' └'
  draw_line $(( width - 2 ))
  printf '┘\n'
}

# Section header with icon
# Usage: section_header <icon> <title>
section_header() {
  local icon="$1"
  local title="$2"
  printf "\n ${C_BOLD}%s %s${C_RESET}\n" "$icon" "$title"
}

# Print with padding
# Usage: padded <indent> <text>
padded() {
  local indent="$1"
  shift
  printf '%*s%b\n' "$indent" "" "$*"
}

# Visible string length (strips ANSI codes, CJK-aware)
# Usage: visible_len <string>
visible_len() {
  local stripped=""
  stripped="$(printf '%s' "$1" | sed 's/\x1b\[[0-9;]*m//g')"
  _gmt_display_width "$stripped"
}
