#!/usr/bin/env bash

input=$(cat)

model=$(jq -r '.model.display_name // "Claude"' <<< "$input")
cost=$(jq -r '.cost.total_cost_usd // 0' <<< "$input")
cost_fmt=$(printf '%.2f' "$cost")

five_h_used=$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<< "$input")
five_h_reset=$(jq -r '.rate_limits.five_hour.resets_at // empty' <<< "$input")
seven_d_used=$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<< "$input")

remaining() {
  local used="$1"
  [[ -z "$used" ]] && { echo "n/a"; return; }
  awk -v u="$used" 'BEGIN{printf "%.0f%% left", 100-u}'
}

reset_in() {
  local ts="$1"
  [[ -z "$ts" ]] && return
  local diff=$(( ts - $(date +%s) ))
  (( diff <= 0 )) && { echo "resetting"; return; }
  printf "resets %dh%dm" $(( diff / 3600 )) $(( (diff % 3600) / 60 ))
}

five_h_reset_str=$(reset_in "$five_h_reset")

printf "%s | \$%s session | 5h: %s (%s) | 7d: %s\n" \
  "$model" "$cost_fmt" "$(remaining "$five_h_used")" "${five_h_reset_str:-n/a}" "$(remaining "$seven_d_used")"
