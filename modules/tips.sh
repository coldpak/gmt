#!/usr/bin/env bash
# tips.sh — Daily rotating terminal tip for beginners

_gmt_tips_render() {
  local tip_count=${#L_TIPS[@]}
  if (( tip_count == 0 )); then return; fi

  local day_of_year=""
  day_of_year="$(date +%-j)"

  local idx
  if [[ -n "$ZSH_VERSION" ]]; then
    idx=$(( (day_of_year % tip_count) + 1 ))
  else
    idx=$(( day_of_year % tip_count ))
  fi

  printf "\n  💡 ${C_DIM}%s:${C_RESET} %s\n" "$L_TIPS_TITLE" "${L_TIPS[$idx]}"
}
