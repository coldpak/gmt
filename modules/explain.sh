#!/usr/bin/env bash
# explain.sh — Command explainer: break down commands and flags

_gmt_explain_lookup_flag() {
  local cmd="$1"
  local flag="$2"

  local entry
  for entry in "${L_EXPLAIN_DATA[@]}"; do
    local e_cmd="${entry%%|*}"
    local rest="${entry#*|}"
    local e_flag="${rest%%|*}"
    local e_desc="${rest#*|}"
    if [[ "$e_cmd" == "$cmd" && "$e_flag" == "$flag" ]]; then
      printf "    ${C_YELLOW}%-10s${C_RESET} %s\n" "$flag" "$e_desc"
      return 0
    fi
  done
  printf "    ${C_DIM}%-10s${C_RESET} %s\n" "$flag" "$L_EXPLAIN_UNKNOWN_FLAG"
  return 1
}

_gmt_explain_command() {
  local input="$*"
  if [[ -z "$input" ]]; then
    echo "  $L_ERR_NO_ARG"
    return 1
  fi

  # Remove surrounding quotes
  input="${input%\"}"
  input="${input#\"}"
  input="${input%\'}"
  input="${input#\'}"

  # Extract command and arguments
  local cmd="${input%% *}"
  local args=""
  if [[ "$input" == *" "* ]]; then
    args="${input#* }"
  fi

  # Look up base command description
  local base_desc=""
  local entry
  for entry in "${L_EXPLAIN_DATA[@]}"; do
    local e_cmd="${entry%%|*}"
    local rest="${entry#*|}"
    local e_flag="${rest%%|*}"
    local e_desc="${rest#*|}"
    if [[ "$e_cmd" == "$cmd" && "$e_flag" == "-" ]]; then
      base_desc="$e_desc"
      break
    fi
  done

  echo ""
  section_header "🔍" "$L_EXPLAIN_TITLE"

  if [[ -n "$base_desc" ]]; then
    printf "  ${C_BOLD}%s${C_RESET} — %s\n" "$cmd" "$base_desc"
  else
    printf "  ${C_BOLD}%s${C_RESET} — ${C_DIM}%s${C_RESET}\n" "$cmd" "$L_EXPLAIN_UNKNOWN_CMD"
  fi

  # Parse and explain each argument/flag
  if [[ -n "$args" ]]; then
    echo ""
    local word
    for word in $args; do
      # Handle combined short flags like -la -> -l, -a
      if [[ "$word" == -?* && "$word" != --* && ${#word} -gt 2 ]]; then
        local i
        for (( i=1; i<${#word}; i++ )); do
          local single_flag="-${word:$i:1}"
          _gmt_explain_lookup_flag "$cmd" "$single_flag"
        done
      else
        _gmt_explain_lookup_flag "$cmd" "$word"
      fi
    done
  fi
  echo ""
}
