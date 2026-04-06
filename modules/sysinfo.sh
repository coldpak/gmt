#!/usr/bin/env bash
# sysinfo.sh — System tool versions + git status (compact)

_GMT_VERSIONS_CACHE="${GMT_DIR}/cache/versions.txt"

# ── Collect tool versions (cached daily, background) ──
_gmt_versions_collect() {
  local cached_date=""
  if [[ -f "$_GMT_VERSIONS_CACHE" ]]; then
    cached_date="$(head -1 "$_GMT_VERSIONS_CACHE")"
  fi

  local today=""
  today="$(date +%Y-%m-%d)"

  if [[ "$cached_date" == "$today" ]]; then
    return 0
  fi

  (
    local git_ver="" node_ver="" python_ver="" npm_ver=""
    git_ver="$(git --version 2>/dev/null | sed 's/git version //')"
    node_ver="$(node -v 2>/dev/null | sed 's/^v//')"
    python_ver="$(python3 -V 2>/dev/null | sed 's/Python //')"
    npm_ver="$(npm -v 2>/dev/null)"

    cat > "$_GMT_VERSIONS_CACHE" << VMEOF
${today}
git|${git_ver}
node|${node_ver}
python|${python_ver}
npm|${npm_ver}
VMEOF
  ) &
  disown 2>/dev/null
}

_gmt_version_get() {
  local tool="$1"
  if [[ -f "$_GMT_VERSIONS_CACHE" ]]; then
    grep "^${tool}|" "$_GMT_VERSIONS_CACHE" | cut -d'|' -f2
  fi
}

_gmt_git_status() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    return 1
  fi

  local branch=""
  branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"

  if git diff --quiet HEAD 2>/dev/null && git diff --cached --quiet HEAD 2>/dev/null; then
    printf "${C_GREEN}%s${C_RESET} %s" "$branch" "✓"
  else
    printf "${C_YELLOW}%s${C_RESET} %s" "$branch" "✗"
  fi
}

# ── Render as a compact one-liner ──
_gmt_sysinfo_render() {
  _gmt_versions_collect

  local git_ver="" node_ver="" python_ver=""
  git_ver="$(_gmt_version_get "git")"
  node_ver="$(_gmt_version_get "node")"
  python_ver="$(_gmt_version_get "python")"

  local parts=""
  [[ -n "$git_ver" ]]    && parts+="git ${C_DIM}${git_ver}${C_RESET}  "
  [[ -n "$node_ver" ]]   && parts+="node ${C_DIM}${node_ver}${C_RESET}  "
  [[ -n "$python_ver" ]] && parts+="python ${C_DIM}${python_ver}${C_RESET}"

  local git_info=""
  git_info="$(_gmt_git_status 2>/dev/null)"

  printf "  ${C_DIM}%b${C_RESET}" "$parts"
  if [[ -n "$git_info" ]]; then
    printf "  ${C_DIM}│${C_RESET}  %b" "$git_info"
  fi
  printf "\n"
}
