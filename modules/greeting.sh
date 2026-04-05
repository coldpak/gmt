#!/usr/bin/env bash
# greeting.sh — Time-based greeting + date + weather

_gmt_greeting_icon() {
  local hour
  hour=$(date +%-H)
  if (( hour >= 5 && hour < 12 )); then
    echo "☀"
  elif (( hour >= 12 && hour < 18 )); then
    echo "🌤"
  elif (( hour >= 18 && hour < 22 )); then
    echo "🌙"
  else
    echo "🌃"
  fi
}

_gmt_greeting_text() {
  local hour
  hour=$(date +%-H)
  if (( hour >= 5 && hour < 12 )); then
    echo "$L_GREETING_MORNING"
  elif (( hour >= 12 && hour < 18 )); then
    echo "$L_GREETING_AFTERNOON"
  elif (( hour >= 18 && hour < 22 )); then
    echo "$L_GREETING_EVENING"
  else
    echo "$L_GREETING_NIGHT"
  fi
}

# Fetch weather from wttr.in (cached)
_gmt_weather_fetch() {
  local city="${GMT_WEATHER_CITY:-Seoul}"
  local lang="${GMT_LANG:-en}"
  curl -s --max-time 3 "wttr.in/${city}?format=%t+%C&lang=${lang}" 2>/dev/null
}

_gmt_weather_get() {
  if [[ "$GMT_WEATHER_ENABLED" != "true" ]]; then
    return 1
  fi

  local cached
  if cached=$(cache_get "weather.txt" "${GMT_WEATHER_CACHE_TTL:-1800}"); then
    echo "$cached"
    return 0
  fi

  # Cache miss — start background fetch
  cache_refresh_bg "weather.txt" "_gmt_weather_fetch"

  # Show cached data even if expired, or loading message
  if [[ -f "${GMT_CACHE_DIR}/weather.txt" ]]; then
    cat "${GMT_CACHE_DIR}/weather.txt"
  else
    echo "$L_WEATHER_LOADING"
  fi
}

_gmt_greeting_render() {
  local icon
  icon=$(_gmt_greeting_icon)
  local greeting
  greeting=$(_gmt_greeting_text)
  local name
  name=$(_gmt_username)
  local date_str
  date_str=$(_gmt_format_date)

  local line1="${icon} ${greeting}, ${name}!"
  local line2="${date_str}"

  local weather_line=""
  if [[ "$GMT_WEATHER_ENABLED" == "true" ]]; then
    local weather
    weather=$(_gmt_weather_get)
    if [[ -n "$weather" ]]; then
      weather_line="${GMT_WEATHER_CITY} ${weather}"
    fi
  fi

  local content="${line1}\n${line2}"
  if [[ -n "$weather_line" ]]; then
    content="${content}\n${weather_line}"
  fi

  draw_box "$(printf '%b' "$content")"
}
