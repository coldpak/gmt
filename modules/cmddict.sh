#!/usr/bin/env bash
# cmddict.sh — Command dictionary for terminal beginners

_gmt_cmddict_categories() {
  echo ""
  section_header "📖" "$L_CMD_TITLE"

  local i=0
  local cat_name
  for cat_name in "${L_CMD_CATEGORIES[@]}"; do
    i=$(( i + 1 ))
    printf "    ${C_CYAN}%d)${C_RESET} %s\n" "$i" "$cat_name"
  done
  echo ""
  printf "  ${C_DIM}%s${C_RESET}\n" "$L_CMD_HINT"
  echo ""
}

_gmt_cmddict_show_category() {
  local n="$1"
  local total=${#L_CMD_CATEGORIES[@]}

  if (( n < 1 || n > total )); then
    echo "  $L_ERR_INVALID_NUM"
    return 1
  fi

  local idx=$(( n - 1 ))

  # Get category name (handle zsh 1-indexed)
  local cat_name
  if [[ -n "$ZSH_VERSION" ]]; then
    cat_name="${L_CMD_CATEGORIES[$((idx + 1))]}"
  else
    cat_name="${L_CMD_CATEGORIES[$idx]}"
  fi

  echo ""
  section_header "📖" "$cat_name"

  local -a _items=()
  eval "_items=(\"\${L_CMD_ITEMS_${idx}[@]}\")"
  local item cmd desc
  for item in "${_items[@]}"; do
    cmd="${item%%|*}"
    desc="${item#*|}"
    printf "    ${C_GREEN}%-24s${C_RESET} %s\n" "$cmd" "$desc"
  done
  echo ""
}

_gmt_cmddict_search() {
  local keyword="$1"
  if [[ -z "$keyword" ]]; then
    echo "  $L_ERR_NO_ARG"
    return 1
  fi

  local lower_keyword=""
  lower_keyword=$(printf '%s' "$keyword" | tr '[:upper:]' '[:lower:]')

  echo ""
  section_header "🔍" "$L_CMD_SEARCH_TITLE"

  local found=0
  local cat_idx=0
  local lower_item="" item cmd desc cat_name
  for cat_name in "${L_CMD_CATEGORIES[@]}"; do
    local -a _items=()
    eval "_items=(\"\${L_CMD_ITEMS_${cat_idx}[@]}\")"
    for item in "${_items[@]}"; do
      lower_item=$(printf '%s' "$item" | tr '[:upper:]' '[:lower:]')
      if [[ "$lower_item" == *"$lower_keyword"* ]]; then
        cmd="${item%%|*}"
        desc="${item#*|}"
        printf "    ${C_GREEN}%-24s${C_RESET} %s\n" "$cmd" "$desc"
        found=$(( found + 1 ))
      fi
    done
    cat_idx=$(( cat_idx + 1 ))
  done

  if (( found == 0 )); then
    printf "  ${C_DIM}%s '%s'${C_RESET}\n" "$L_CMD_NO_RESULTS" "$keyword"
  fi
  echo ""
}

_gmt_cmddict_dispatch() {
  local arg="$1"
  if [[ -z "$arg" ]]; then
    _gmt_cmddict_categories
  elif [[ "$arg" =~ ^[0-9]+$ ]]; then
    _gmt_cmddict_show_category "$arg"
  else
    _gmt_cmddict_search "$arg"
  fi
}
