#!/usr/bin/env bash
# compat.sh — Cross-platform compatibility wrappers (macOS/Linux)

_gmt_detect_os() {
  case "$(uname -s)" in
    Darwin) GMT_OS="macos" ;;
    Linux)  GMT_OS="linux" ;;
    *)      GMT_OS="unknown" ;;
  esac
}

# Get file modification time as unix timestamp
# Usage: _gmt_stat_mtime /path/to/file
_gmt_stat_mtime() {
  local file="$1"
  if [[ "$GMT_OS" == "macos" ]]; then
    stat -f %m "$file" 2>/dev/null
  else
    stat -c %Y "$file" 2>/dev/null
  fi
}

# In-place sed replacement (handles macOS vs Linux)
# Usage: _gmt_sed_inplace 's/old/new/' /path/to/file
_gmt_sed_inplace() {
  local expr="$1"
  local file="$2"
  if [[ "$GMT_OS" == "macos" ]]; then
    sed -i '' "$expr" "$file"
  else
    sed -i "$expr" "$file"
  fi
}

# Get current unix timestamp (portable)
_gmt_now() {
  date +%s
}

# Format date — returns localized date string
# Usage: _gmt_format_date
_gmt_format_date() {
  local dow_num
  dow_num=$(date +%w)  # 0=Sun, 1=Mon, ...
  local weekday="${L_WEEKDAYS[$dow_num]}"
  local month=$(date +%-m)
  local day=$(date +%-d)
  local hour=$(date +%-H)
  local minute=$(date +%M)

  # Build date string from locale format
  local date_str="${L_DATE_FMT}"
  date_str="${date_str/\{weekday\}/$weekday}"
  date_str="${date_str//%m/$month}"
  date_str="${date_str//%d/$day}"

  # Build time string
  local time_str
  if [[ "$GMT_LANG" == "ko" ]]; then
    if (( hour < 12 )); then
      local display_hour=$hour
      (( display_hour == 0 )) && display_hour=12
      time_str="${L_TIME_AM} ${display_hour}:${minute}"
    else
      local display_hour=$(( hour - 12 ))
      (( display_hour == 0 )) && display_hour=12
      time_str="${L_TIME_PM} ${display_hour}:${minute}"
    fi
  else
    if (( hour < 12 )); then
      local display_hour=$hour
      (( display_hour == 0 )) && display_hour=12
      time_str="${display_hour}:${minute} AM"
    else
      local display_hour=$(( hour - 12 ))
      (( display_hour == 0 )) && display_hour=12
      time_str="${display_hour}:${minute} PM"
    fi
  fi

  printf '%s %s %s' "$date_str" "$L_DATE_SEP" "$time_str"
}

# Initialize OS detection
_gmt_detect_os
