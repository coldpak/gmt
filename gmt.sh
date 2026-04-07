#!/usr/bin/env bash
# gmt.sh — Good Morning Terminal entry point
# This file is sourced by .zshrc or .bashrc

GMT_DIR="${GMT_DIR:-${HOME}/.gmt}"
GMT_VERSION="0.1.0"

# ── Load libraries ──
source "${GMT_DIR}/lib/compat.sh"
source "${GMT_DIR}/lib/colors.sh"
source "${GMT_DIR}/lib/layout.sh"
source "${GMT_DIR}/lib/cache.sh"

# ── Load config ──
[[ -f "${GMT_DIR}/config.sh" ]] && source "${GMT_DIR}/config.sh"

# ── Ensure data directories ──
mkdir -p "${GMT_DIR}/data" "${GMT_DIR}/cache"

# ── Language loading ──
_gmt_load_lang() {
  local lang="${GMT_LANG:-auto}"
  if [[ "$lang" == "auto" ]]; then
    lang="${LANG%%_*}"
    lang="${lang:-en}"
  fi
  local lang_file="${GMT_DIR}/lang/${lang}.sh"
  if [[ -f "$lang_file" ]]; then
    source "$lang_file"
  else
    source "${GMT_DIR}/lang/en.sh"
  fi
}

_gmt_load_lang

# ── Resolve display name ──
_gmt_username() {
  echo "${GMT_USERNAME:-$USER}"
}

# ── Source all modules (makes functions available for gmt CLI) ──
for _gmt_mod_file in "${GMT_DIR}"/modules/*.sh; do
  [[ -f "$_gmt_mod_file" ]] && source "$_gmt_mod_file"
done
unset _gmt_mod_file

# ── Home screen render ──
_gmt_render_home() {
  _gmt_reset_term_width
  echo ""

  # IFS split — portable across bash and zsh
  local _gmt_ifs_bak="$IFS"
  IFS=' '
  local -a _gmt_mods
  read -rA _gmt_mods <<< "$GMT_MODULES" 2>/dev/null || read -ra _gmt_mods <<< "$GMT_MODULES"
  IFS="$_gmt_ifs_bak"
  local module
  for module in "${_gmt_mods[@]}"; do
    if type "_gmt_${module}_render" &>/dev/null; then
      "_gmt_${module}_render"
    fi
  done

  echo ""
}

# ── Help ──
_gmt_help() {
  echo ""
  printf "  ${C_BOLD}%s${C_RESET}\n" "$L_HELP_HEADER"
  echo ""
  for cmd in "${L_HELP_COMMANDS[@]}"; do
    printf "  %s\n" "$cmd"
  done
  echo ""
}

# ── Main command ──
gm() {
  local cmd="${1:-home}"
  shift 2>/dev/null
  case "$cmd" in
    home)    _gmt_render_home ;;
    go)      _gmt_project_go "$1" ;;
    add)     _gmt_todo_add "$*" ;;
    done)    _gmt_todo_toggle "$1" ;;
    rm)      _gmt_todo_remove "$1" ;;
    goal)    _gmt_todo_goal "$*" ;;
    list)    _gmt_todos_render ;;
    clear)   _gmt_todo_clear ;;
    setup)
      rm -f "${GMT_DIR}/data/.initialized"
      _gmt_onboarding
      ;;
    config)  ${EDITOR:-vi} "${GMT_DIR}/config.sh" ;;
    help)    _gmt_help ;;
    version) echo "gm v${GMT_VERSION}" ;;
    *)       echo "  $L_ERR_UNKNOWN_CMD" ;;
  esac
}

# ── Directory tracking hook ──
_gmt_track_directory() {
  local dir
  dir=$(pwd)

  # Only track directories with .git
  if [[ -d "${dir}/.git" ]]; then
    local now
    now=$(_gmt_now)
    echo "${now}|${dir}" >> "${GMT_DIR}/data/projects.log"
  fi

  # Activity tracking (one entry per day)
  local today
  today=$(date +%Y-%m-%d)
  local log_file="${GMT_DIR}/data/activity.log"

  if [[ -f "$log_file" ]]; then
    local last_line
    last_line=$(tail -1 "$log_file")
    local last_date="${last_line%%|*}"
    if [[ "$last_date" == "$today" ]]; then
      local count="${last_line#*|}"
      count=$(( count + 1 ))
      _gmt_sed_inplace "$ s/.*/${today}|${count}/" "$log_file"
      return
    fi
  fi
  echo "${today}|1" >> "$log_file"
}

# ── Register hooks ──
if [[ -n "$ZSH_VERSION" ]]; then
  # Avoid duplicate registration
  if [[ ! " ${chpwd_functions[*]} " =~ " _gmt_track_directory " ]]; then
    chpwd_functions+=(_gmt_track_directory)
  fi
elif [[ -n "$BASH_VERSION" ]]; then
  if [[ "$PROMPT_COMMAND" != *"_gmt_track_directory"* ]]; then
    PROMPT_COMMAND="_gmt_track_directory;${PROMPT_COMMAND:+ $PROMPT_COMMAND}"
  fi
fi

# ── Onboarding check & home screen ──
if [[ ! -f "${GMT_DIR}/data/.initialized" ]]; then
  if [[ -t 0 ]]; then
    _gmt_onboarding
  fi
else
  _gmt_render_home
fi
