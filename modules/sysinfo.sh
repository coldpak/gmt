#!/usr/bin/env bash
# sysinfo.sh — System tool versions + git status

_GMT_VERSIONS_CACHE="${GMT_DIR}/cache/versions.txt"
_GMT_VERSIONS_CACHE_TTL=86400  # 1 day

# ── Collect tool versions (cached daily, background on miss) ──
_gmt_versions_collect() {
  local cached_date=""
  if [[ -f "$_GMT_VERSIONS_CACHE" ]]; then
    cached_date=$(head -1 "$_GMT_VERSIONS_CACHE")
  fi

  local today
  today=$(date +%Y-%m-%d)

  if [[ "$cached_date" == "$today" ]]; then
    return 0  # Cache is fresh
  fi

  # Background version collection (non-blocking)
  (
    local git_ver="" node_ver="" python_ver="" npm_ver=""
    git_ver=$(git --version 2>/dev/null | sed 's/git version //')
    node_ver=$(node -v 2>/dev/null | sed 's/^v//')
    python_ver=$(python3 -V 2>/dev/null | sed 's/Python //')
    npm_ver=$(npm -v 2>/dev/null)

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

# ── Read a version from cache ──
_gmt_version_get() {
  local tool="$1"
  if [[ -f "$_GMT_VERSIONS_CACHE" ]]; then
    grep "^${tool}|" "$_GMT_VERSIONS_CACHE" | cut -d'|' -f2
  fi
}

# ── Git status for current directory ──
_gmt_git_status() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    return 1
  fi

  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local status_icon
  if git diff --quiet HEAD 2>/dev/null && git diff --cached --quiet HEAD 2>/dev/null; then
    status_icon="${C_GREEN}✓ ${L_SYS_CLEAN}${C_RESET}"
  else
    status_icon="${C_YELLOW}✗ ${L_SYS_DIRTY}${C_RESET}"
  fi

  printf "%s: %s  %b" "$L_SYS_BRANCH" "$branch" "$status_icon"
}

# ── Render ──
_gmt_sysinfo_render() {
  _gmt_versions_collect

  local git_ver node_ver python_ver npm_ver
  git_ver=$(_gmt_version_get "git")
  node_ver=$(_gmt_version_get "node")
  python_ver=$(_gmt_version_get "python")
  npm_ver=$(_gmt_version_get "npm")

  section_header "⚙" "$L_SYS_TITLE"

  # Line 1: tool versions
  local line1=""
  [[ -n "$git_ver" ]]    && line1+="git ${C_DIM}${git_ver}${C_RESET}    "
  [[ -n "$node_ver" ]]   && line1+="node ${C_DIM}${node_ver}${C_RESET}    "
  [[ -n "$python_ver" ]] && line1+="python ${C_DIM}${python_ver}${C_RESET}"
  if [[ -n "$line1" ]]; then
    printf "  %b\n" "$line1"
  fi

  # Line 2: git branch + status + npm
  local line2=""
  local git_info
  git_info=$(_gmt_git_status 2>/dev/null)
  if [[ -n "$git_info" ]]; then
    line2+="$git_info"
  fi
  [[ -n "$npm_ver" ]] && line2+="    npm ${C_DIM}${npm_ver}${C_RESET}"
  if [[ -n "$line2" ]]; then
    printf "  %b\n" "$line2"
  fi
}
