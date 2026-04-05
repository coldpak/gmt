#!/usr/bin/env bash
# cache.sh — TTL-based file cache with background refresh

GMT_CACHE_DIR="${GMT_DIR}/cache"

# Read from cache if not expired
# Usage: cache_get <key> [ttl_seconds]
# Returns 0 + prints content if cache hit, 1 if miss/expired
cache_get() {
  local key="$1"
  local ttl="${2:-3600}"
  local file="${GMT_CACHE_DIR}/${key}"

  if [[ -f "$file" ]]; then
    local mtime
    mtime=$(_gmt_stat_mtime "$file")
    local now
    now=$(_gmt_now)
    local age=$(( now - mtime ))
    if (( age < ttl )); then
      cat "$file"
      return 0
    fi
  fi
  return 1
}

# Write value to cache
# Usage: cache_set <key> <value>
cache_set() {
  local key="$1"
  local value="$2"
  mkdir -p "$GMT_CACHE_DIR"
  printf '%s' "$value" > "${GMT_CACHE_DIR}/${key}"
}

# Refresh cache in background (non-blocking)
# Usage: cache_refresh_bg <key> <command_string>
cache_refresh_bg() {
  local key="$1"
  local cmd="$2"
  (
    result=$(eval "$cmd" 2>/dev/null)
    if [[ -n "$result" ]]; then
      printf '%s' "$result" > "${GMT_CACHE_DIR}/${key}"
    fi
  ) &
  disown 2>/dev/null
}
