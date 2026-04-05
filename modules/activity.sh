#!/usr/bin/env bash
# activity.sh — Terminal activity heatmap (GitHub-style)

_GMT_ACTIVITY_LOG="${GMT_DIR}/data/activity.log"
_GMT_HEATMAP_CACHE="${GMT_DIR}/cache/heatmap.txt"

# ── Intensity character based on count ──
_gmt_activity_char() {
  local count="$1"
  if supports_256_color; then
    if (( count == 0 )); then
      printf "${COLOR_NONE}·${C_RESET}"
    elif (( count <= 10 )); then
      printf "${COLOR_LOW}░${C_RESET}"
    elif (( count <= 30 )); then
      printf "${COLOR_MED}▒${C_RESET}"
    else
      printf "${COLOR_HIGH}▓${C_RESET}"
    fi
  else
    if (( count == 0 )); then
      printf "·"
    elif (( count <= 10 )); then
      printf "░"
    elif (( count <= 30 )); then
      printf "▒"
    else
      printf "▓"
    fi
  fi
}

# ── Build date-to-count lookup from activity.log ──
# Populates associative array _GMT_ACT_DATA
_gmt_activity_load_data() {
  # Use a temp approach since bash 3 (macOS) lacks associative arrays
  # Store as lines: YYYY-MM-DD|count in a variable
  _GMT_ACT_RAW=""
  if [[ -f "$_GMT_ACTIVITY_LOG" ]]; then
    _GMT_ACT_RAW=$(cat "$_GMT_ACTIVITY_LOG")
  fi
}

# Lookup count for a date
_gmt_activity_count_for() {
  local date="$1"
  local line
  line=$(echo "$_GMT_ACT_RAW" | grep "^${date}|" 2>/dev/null)
  if [[ -n "$line" ]]; then
    echo "${line#*|}"
  else
    echo "0"
  fi
}

# ── Render heatmap ──
_gmt_activity_render_heatmap() {
  local weeks="${GMT_ACTIVITY_WEEKS:-12}"
  local total_days=$(( weeks * 7 ))

  _gmt_activity_load_data

  # Calculate start date (total_days ago, aligned to Monday)
  local now_ts
  now_ts=$(_gmt_now)
  local today_dow
  today_dow=$(date +%u)  # 1=Mon, 7=Sun

  # We render rows for Mon(1), Wed(3), Fri(5)
  local -a row_dows=(1 3 5)
  local -a row_labels=("Mon" "Wed" "Fri")

  # Start from (weeks * 7) days ago, find the nearest Monday
  local start_offset=$(( total_days + (today_dow - 1) ))
  local start_ts=$(( now_ts - start_offset * 86400 ))

  for row_idx in 0 1 2; do
    local dow="${row_dows[$row_idx]}"
    local label="${row_labels[$row_idx]}"
    printf "  ${C_DIM}%-3s${C_RESET}  " "$label"

    # For this row's day-of-week, iterate through each week
    local day_offset=$(( dow - 1 ))  # offset from start (Monday=0)
    local w
    for (( w = 0; w < weeks; w++ )); do
      local cell_ts=$(( start_ts + (w * 7 + day_offset) * 86400 ))
      local cell_date
      if [[ "$GMT_OS" == "macos" ]]; then
        cell_date=$(date -r "$cell_ts" +%Y-%m-%d 2>/dev/null)
      else
        cell_date=$(date -d "@${cell_ts}" +%Y-%m-%d 2>/dev/null)
      fi
      local count
      count=$(_gmt_activity_count_for "$cell_date")
      _gmt_activity_char "$count"
    done
    echo ""
  done

  # Footer line showing "today" marker
  local marker_pad=$(( 5 + weeks ))
  printf "  ${C_DIM}%*s%s${C_RESET}\n" "$marker_pad" "" "today"
}

# ── Main render ──
_gmt_activity_render() {
  local weeks="${GMT_ACTIVITY_WEEKS:-12}"
  local label
  label=$(printf "$L_ACTIVITY_WEEKS" "$weeks")

  section_header "📊" "${L_ACTIVITY_TITLE} (${label})"

  # Check if cache is valid (compare log mtime vs cache mtime)
  local use_cache=false
  if [[ -f "$_GMT_HEATMAP_CACHE" && -f "$_GMT_ACTIVITY_LOG" ]]; then
    local log_mtime cache_mtime
    log_mtime=$(_gmt_stat_mtime "$_GMT_ACTIVITY_LOG")
    cache_mtime=$(_gmt_stat_mtime "$_GMT_HEATMAP_CACHE")
    if (( cache_mtime > log_mtime )); then
      use_cache=true
    fi
  elif [[ -f "$_GMT_HEATMAP_CACHE" && ! -f "$_GMT_ACTIVITY_LOG" ]]; then
    use_cache=true
  fi

  if [[ "$use_cache" == "true" ]]; then
    cat "$_GMT_HEATMAP_CACHE"
  else
    local output
    output=$(_gmt_activity_render_heatmap)
    echo "$output"
    # Cache the result
    printf '%s' "$output" > "$_GMT_HEATMAP_CACHE"
  fi
}
