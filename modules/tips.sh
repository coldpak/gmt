#!/usr/bin/env bash
# tips.sh — Daily rotating terminal tip for beginners

_gmt_tips_render() {
  local tip_count=${#L_TIPS[@]}
  if (( tip_count == 0 )); then return; fi

  local rand_val=""
  rand_val="$RANDOM"

  local idx
  if [[ -n "$ZSH_VERSION" ]]; then
    idx=$(( (rand_val % tip_count) + 1 ))
  else
    idx=$(( rand_val % tip_count ))
  fi

  printf "\n  💡 ${C_DIM}%s:${C_RESET} %s\n" "$L_TIPS_TITLE" "${L_TIPS[$idx]}"
}
