#!/usr/bin/env bash
# todos.sh — Task management + daily goal

_GMT_TODOS_FILE="${GMT_DIR}/data/todos.txt"
_GMT_GOAL_FILE="${GMT_DIR}/data/goal.txt"

# ── Render ──
_gmt_todos_render() {
  # Goal
  local today=""
  today="$(date +%Y-%m-%d)"
  local goal=""
  if [[ -f "$_GMT_GOAL_FILE" ]]; then
    local goal_line=""
    goal_line="$(cat "$_GMT_GOAL_FILE")"
    local goal_date="${goal_line%%|*}"
    if [[ "$goal_date" == "$today" ]]; then
      goal="${goal_line#*|}"
    fi
  fi

  if [[ -n "$goal" ]]; then
    printf "\n  ${C_BOLD}🎯 %s${C_RESET}\n" "$goal"
  fi

  # Todos
  if [[ ! -f "$_GMT_TODOS_FILE" ]] || [[ ! -s "$_GMT_TODOS_FILE" ]]; then
    if [[ -z "$goal" ]]; then
      printf "\n  ${C_DIM}%s${C_RESET}\n" "$L_TODO_EMPTY"
      printf "  ${C_DIM}%s${C_RESET}\n" "$L_TODO_HINT"
    fi
    return
  fi

  echo ""
  local idx=1
  while IFS='|' read -r task_status _ts content; do
    [[ -z "$content" ]] && continue
    if [[ "$task_status" == "1" ]]; then
      printf "  ${C_DIM}  ✓ %s${C_RESET}\n" "$content"
    else
      printf "    ○ %s\n" "$content"
    fi
    idx=$(( idx + 1 ))
  done < "$_GMT_TODOS_FILE"
}

# ── Add ──
_gmt_todo_add() {
  local content="$1"
  if [[ -z "$content" ]]; then
    echo "  $L_ERR_NO_ARG"
    return 1
  fi
  local now=""
  now="$(_gmt_now)"
  echo "0|${now}|${content}" >> "$_GMT_TODOS_FILE"
  printf "  ✓ %s: %s\n" "$L_TODO_ADDED" "$content"
}

# ── Toggle done/undone ──
_gmt_todo_toggle() {
  local num="$1"
  if [[ -z "$num" ]] || ! [[ "$num" =~ ^[0-9]+$ ]]; then
    echo "  $L_ERR_INVALID_NUM"
    return 1
  fi

  if [[ ! -f "$_GMT_TODOS_FILE" ]]; then
    echo "  $L_ERR_INVALID_NUM"
    return 1
  fi

  local total=""
  total="$(wc -l < "$_GMT_TODOS_FILE" | tr -d ' ')"
  if (( num < 1 || num > total )); then
    echo "  $L_ERR_INVALID_NUM"
    return 1
  fi

  local line=""
  line="$(sed -n "${num}p" "$_GMT_TODOS_FILE")"
  local task_status="${line%%|*}"

  if [[ "$task_status" == "0" ]]; then
    _gmt_sed_inplace "${num}s/^0|/1|/" "$_GMT_TODOS_FILE"
    printf "  ✓ %s\n" "$L_TODO_DONE_TOGGLE"
  else
    _gmt_sed_inplace "${num}s/^1|/0|/" "$_GMT_TODOS_FILE"
    printf "  ✓ %s\n" "$L_TODO_UNDONE_TOGGLE"
  fi
}

# ── Remove ──
_gmt_todo_remove() {
  local num="$1"
  if [[ -z "$num" ]] || ! [[ "$num" =~ ^[0-9]+$ ]]; then
    echo "  $L_ERR_INVALID_NUM"
    return 1
  fi

  if [[ ! -f "$_GMT_TODOS_FILE" ]]; then
    echo "  $L_ERR_INVALID_NUM"
    return 1
  fi

  local total=""
  total="$(wc -l < "$_GMT_TODOS_FILE" | tr -d ' ')"
  if (( num < 1 || num > total )); then
    echo "  $L_ERR_INVALID_NUM"
    return 1
  fi

  _gmt_sed_inplace "${num}d" "$_GMT_TODOS_FILE"
  printf "  ✓ %s\n" "$L_TODO_REMOVED"
}

# ── Set goal ──
_gmt_todo_goal() {
  local content="$1"
  if [[ -z "$content" ]]; then
    echo "  $L_ERR_NO_ARG"
    return 1
  fi
  local today=""
  today="$(date +%Y-%m-%d)"
  printf '%s|%s' "$today" "$content" > "$_GMT_GOAL_FILE"
  printf "  ✓ %s: %s\n" "$L_TODO_GOAL_SET" "$content"
}

# ── Clear completed ──
_gmt_todo_clear() {
  if [[ ! -f "$_GMT_TODOS_FILE" ]]; then
    return 0
  fi
  local tmp="${_GMT_TODOS_FILE}.tmp"
  grep -v '^1|' "$_GMT_TODOS_FILE" > "$tmp" 2>/dev/null || true
  mv "$tmp" "$_GMT_TODOS_FILE"
  printf "  ✓ %s\n" "$L_TODO_CLEARED"
}
