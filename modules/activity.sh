#!/usr/bin/env bash
# activity.sh — Activity streak counter (compact, inline)

_GMT_ACTIVITY_LOG="${GMT_DIR}/data/activity.log"

_gmt_activity_streak() {
  if [[ ! -f "$_GMT_ACTIVITY_LOG" ]] || [[ ! -s "$_GMT_ACTIVITY_LOG" ]]; then
    echo "0"
    return
  fi

  local today=""
  today="$(date +%Y-%m-%d)"
  local streak=0
  local check_date="$today"
  local log_data=""
  log_data="$(cat "$_GMT_ACTIVITY_LOG")"

  while true; do
    if echo "$log_data" | grep -q "^${check_date}|"; then
      streak=$(( streak + 1 ))
      if [[ "$GMT_OS" == "macos" ]]; then
        check_date="$(date -j -v-${streak}d +%Y-%m-%d 2>/dev/null)"
      else
        check_date="$(date -d "${today} -${streak} days" +%Y-%m-%d 2>/dev/null)"
      fi
    else
      break
    fi
  done

  echo "$streak"
}

_gmt_activity_today_count() {
  if [[ ! -f "$_GMT_ACTIVITY_LOG" ]]; then
    echo "0"
    return
  fi

  local today=""
  today="$(date +%Y-%m-%d)"
  local line=""
  line="$(grep "^${today}|" "$_GMT_ACTIVITY_LOG" 2>/dev/null)"
  if [[ -n "$line" ]]; then
    echo "${line#*|}"
  else
    echo "0"
  fi
}

# ── Render as footer line ──
_gmt_activity_render() {
  local streak=""
  streak="$(_gmt_activity_streak)"
  local today_count=""
  today_count="$(_gmt_activity_today_count)"

  if (( streak > 0 )); then
    local fire=""
    if (( streak >= 7 )); then
      fire="🔥🔥🔥"
    elif (( streak >= 3 )); then
      fire="🔥🔥"
    else
      fire="🔥"
    fi
    printf "  %s ${C_BOLD}%d${C_RESET}${C_DIM}%s %s${C_RESET}  ${C_DIM}·  %s %s${C_RESET}\n" \
      "$fire" "$streak" "$L_ACTIVITY_DAYS" "$L_ACTIVITY_STREAK" "$L_ACTIVITY_TODAY" "$today_count"
  fi
}
