#!/usr/bin/env bash
# safe.sh — Safety net: confirmation prompts for dangerous commands

# ── Warning display ──
_gmt_safe_warn() {
  local cmd="$1"
  local detail="$2"
  echo ""
  printf "  ${C_RED}⚠  %s${C_RESET}\n" "$L_SAFE_WARNING"
  printf "  ${C_BOLD}%s${C_RESET}\n" "$cmd"
  [[ -n "$detail" ]] && printf "  ${C_DIM}%s${C_RESET}\n" "$detail"
}

# ── Confirmation prompt ──
_gmt_safe_confirm() {
  printf "  ${C_YELLOW}%s (y/N): ${C_RESET}" "$L_SAFE_CONFIRM"
  local answer
  read -r answer
  [[ "$answer" == "y" || "$answer" == "Y" ]]
}

# ── Count affected files ──
_gmt_safe_count_files() {
  local count=0
  local arg
  for arg in "$@"; do
    [[ "$arg" == -* ]] && continue
    if [[ -d "$arg" ]]; then
      local dir_count
      dir_count=$(command find "$arg" -type f 2>/dev/null | command wc -l | tr -d ' ')
      count=$(( count + dir_count ))
    elif [[ -e "$arg" ]]; then
      count=$(( count + 1 ))
    fi
  done
  echo "$count"
}

# ── rm wrapper ──
_gmt_safe_rm_wrapper() {
  # Non-interactive: pass through
  if [[ ! -t 0 ]]; then
    command rm "$@"
    return $?
  fi

  local has_recursive=false
  local arg
  for arg in "$@"; do
    case "$arg" in
      -*r*|--recursive) has_recursive=true ;;
    esac
  done

  if [[ "$has_recursive" == "true" ]]; then
    local file_count
    file_count=$(_gmt_safe_count_files "$@")
    local detail
    detail=$(printf "$L_SAFE_FILES_AFFECTED" "$file_count")
    _gmt_safe_warn "rm $*" "$detail"
    if _gmt_safe_confirm; then
      command rm "$@"
    else
      printf "  ${C_DIM}%s${C_RESET}\n\n" "$L_SAFE_CANCELLED"
      return 1
    fi
  else
    command rm "$@"
  fi
}

# ── chmod wrapper ──
_gmt_safe_chmod_wrapper() {
  if [[ ! -t 0 ]]; then
    command chmod "$@"
    return $?
  fi

  local is_dangerous=false
  local arg
  for arg in "$@"; do
    case "$arg" in
      777|666|-R|--recursive) is_dangerous=true ;;
    esac
  done

  if [[ "$is_dangerous" == "true" ]]; then
    _gmt_safe_warn "chmod $*"
    if _gmt_safe_confirm; then
      command chmod "$@"
    else
      printf "  ${C_DIM}%s${C_RESET}\n\n" "$L_SAFE_CANCELLED"
      return 1
    fi
  else
    command chmod "$@"
  fi
}

# ── git wrapper ──
_gmt_safe_git_wrapper() {
  if [[ ! -t 0 ]]; then
    command git "$@"
    return $?
  fi

  local is_dangerous=false
  local all_args="$*"

  case "$all_args" in
    *"push"*"-f"*|*"push"*"--force"*)
      is_dangerous=true ;;
    *"reset"*"--hard"*)
      is_dangerous=true ;;
    *"clean"*"-f"*)
      is_dangerous=true ;;
  esac

  if [[ "$is_dangerous" == "true" ]]; then
    _gmt_safe_warn "git $*"
    if _gmt_safe_confirm; then
      command git "$@"
    else
      printf "  ${C_DIM}%s${C_RESET}\n\n" "$L_SAFE_CANCELLED"
      return 1
    fi
  else
    command git "$@"
  fi
}

# ── Initialize wrappers ──
_gmt_safe_init() {
  if [[ "${GMT_SAFE_ENABLED}" != "true" ]]; then
    return
  fi

  rm() { _gmt_safe_rm_wrapper "$@"; }
  chmod() { _gmt_safe_chmod_wrapper "$@"; }
  git() { _gmt_safe_git_wrapper "$@"; }
}

# Auto-initialize when sourced
_gmt_safe_init
