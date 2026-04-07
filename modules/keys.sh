#!/usr/bin/env bash
# keys.sh — Terminal keyboard shortcuts cheatsheet

_gmt_keys_show() {
  echo ""
  section_header "⌨️" "$L_KEYS_TITLE"

  local cat_idx=0
  for cat_name in "${L_KEYS_CATEGORIES[@]}"; do
    printf "\n  ${C_BOLD}%s${C_RESET}\n" "$cat_name"
    local -a _items=()
    eval "_items=(\"\${L_KEYS_ITEMS_${cat_idx}[@]}\")"
    local item
    for item in "${_items[@]}"; do
      local shortcut="${item%%|*}"
      local desc="${item#*|}"
      printf "    ${C_CYAN}%-14s${C_RESET} %s\n" "$shortcut" "$desc"
    done
    cat_idx=$(( cat_idx + 1 ))
  done
  echo ""
}
