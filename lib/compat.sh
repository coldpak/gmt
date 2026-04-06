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
  command date +%s
}

# Format date — returns localized date string
# Usage: _gmt_format_date
_gmt_format_date() {
  local dow_num="" month="" day="" hour="" minute=""
  dow_num="$(date +%w)"  # 0=Sun, 1=Mon, ...
  month="$(date +%-m)"
  day="$(date +%-d)"
  hour="$(date +%-H)"
  minute="$(date +%M)"

  # zsh arrays are 1-indexed, bash arrays are 0-indexed
  local weekday=""
  if [[ -n "$ZSH_VERSION" ]]; then
    weekday="${L_WEEKDAYS[$((dow_num + 1))]}"
  else
    weekday="${L_WEEKDAYS[$dow_num]}"
  fi

  # Build date string directly (avoid %m/%d pattern clash)
  local date_str=""
  if [[ "$GMT_LANG" == "ko" ]]; then
    date_str="${month}월 ${day}일 ${weekday}요일"
  else
    date_str="${weekday}, ${month}/${day}"
  fi

  # Build time string
  local time_str="" display_hour=""
  if (( hour < 12 )); then
    display_hour=$hour
    (( display_hour == 0 )) && display_hour=12
    if [[ "$GMT_LANG" == "ko" ]]; then
      time_str="${L_TIME_AM} ${display_hour}:${minute}"
    else
      time_str="${display_hour}:${minute} AM"
    fi
  else
    display_hour=$(( hour - 12 ))
    (( display_hour == 0 )) && display_hour=12
    if [[ "$GMT_LANG" == "ko" ]]; then
      time_str="${L_TIME_PM} ${display_hour}:${minute}"
    else
      time_str="${display_hour}:${minute} PM"
    fi
  fi

  printf '%s %s %s' "$date_str" "$L_DATE_SEP" "$time_str"
}

# Initialize OS detection
_gmt_detect_os
