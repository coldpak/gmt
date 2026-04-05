#!/usr/bin/env bash
# projects.sh — Recent project tracking & quick navigation

_GMT_PROJECTS_LOG="${GMT_DIR}/data/projects.log"
_GMT_PROJECTS_CACHE="${GMT_DIR}/cache/recent_projects.txt"

# ── Relative time formatting (pure bash arithmetic) ──
_gmt_relative_time() {
  local ts="$1"
  local now
  now=$(_gmt_now)
  local diff=$(( now - ts ))

  if (( diff < 60 )); then
    echo "$L_TIME_JUST_NOW"
  elif (( diff < 3600 )); then
    printf "$L_TIME_MINUTES_AGO" $(( diff / 60 ))
  elif (( diff < 86400 )); then
    printf "$L_TIME_HOURS_AGO" $(( diff / 3600 ))
  elif (( diff < 172800 )); then
    echo "$L_TIME_YESTERDAY"
  elif (( diff < 604800 )); then
    printf "$L_TIME_DAYS_AGO" $(( diff / 86400 ))
  else
    printf "$L_TIME_WEEKS_AGO" $(( diff / 604800 ))
  fi
}

# ── Build deduplicated recent projects list ──
_gmt_build_project_list() {
  if [[ ! -f "$_GMT_PROJECTS_LOG" ]] || [[ ! -s "$_GMT_PROJECTS_LOG" ]]; then
    return 1
  fi

  local count="${GMT_PROJECTS_COUNT:-5}"

  # Read log in reverse (most recent first), deduplicate by path
  # Output: timestamp|path (deduplicated, latest timestamp wins)
  local -a seen_paths=()
  local -a result_lines=()

  while IFS='|' read -r ts path; do
    [[ -z "$path" ]] && continue
    # Skip if already seen
    local found=false
    for sp in "${seen_paths[@]}"; do
      if [[ "$sp" == "$path" ]]; then
        found=true
        break
      fi
    done
    if [[ "$found" == "false" ]]; then
      seen_paths+=("$path")
      result_lines+=("${ts}|${path}")
      (( ${#result_lines[@]} >= count )) && break
    fi
  done < <(tail -r "$_GMT_PROJECTS_LOG" 2>/dev/null || tac "$_GMT_PROJECTS_LOG" 2>/dev/null)

  # Write cache file (paths only, for gmt go)
  mkdir -p "${GMT_DIR}/cache"
  : > "$_GMT_PROJECTS_CACHE"
  for entry in "${result_lines[@]}"; do
    echo "${entry#*|}" >> "$_GMT_PROJECTS_CACHE"
  done

  # Print formatted output
  local idx=1
  for entry in "${result_lines[@]}"; do
    local ts="${entry%%|*}"
    local path="${entry#*|}"
    local display_path="${path/#$HOME/~}"
    local rel_time
    rel_time=$(_gmt_relative_time "$ts")
    printf "  ${C_CYAN}[%d]${C_RESET} %-35s ${C_DIM}%s${C_RESET}\n" "$idx" "$display_path" "$rel_time"
    idx=$(( idx + 1 ))
  done
}

# ── Render ──
_gmt_projects_render() {
  section_header "📂" "$L_PROJ_TITLE"

  local output
  output=$(_gmt_build_project_list)

  if [[ -z "$output" ]]; then
    printf "  ${C_DIM}%s${C_RESET}\n" "$L_PROJ_EMPTY"
    printf "  ${C_DIM}%s${C_RESET}\n" "$L_PROJ_HINT"
    return
  fi

  echo "$output"
  echo ""
  printf "  ${C_DIM}%s${C_RESET}\n" "$L_PROJ_GO_HINT"
}

# ── Navigate to project ──
_gmt_project_go() {
  local num="$1"
  if [[ -z "$num" ]] || ! [[ "$num" =~ ^[0-9]+$ ]]; then
    echo "  $L_ERR_INVALID_NUM"
    return 1
  fi

  if [[ ! -f "$_GMT_PROJECTS_CACHE" ]]; then
    # Rebuild cache
    _gmt_build_project_list > /dev/null 2>&1
  fi

  local target
  target=$(sed -n "${num}p" "$_GMT_PROJECTS_CACHE" 2>/dev/null)

  if [[ -n "$target" && -d "$target" ]]; then
    cd "$target" || return 1
  else
    echo "  $L_PROJ_NOT_FOUND"
    return 1
  fi
}
