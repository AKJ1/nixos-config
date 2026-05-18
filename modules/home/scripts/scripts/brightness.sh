#!/usr/bin/env bash

set -uo pipefail

STEP="${BRIGHTNESS_STEP:-0.05}"
SVC="rs.wl-gammarelay"
OBJ="/"
IFACE="rs.wl.gammarelay"

err() {
  echo "brightness: $*" >&2
  exit 1
}

get_raw() {
  local out
  out=$(busctl --user get-property "$SVC" "$OBJ" "$IFACE" Brightness 2>/dev/null) ||
    err "daemon not running (try: systemctl --user start wl-gammarelay-rs)"
  echo "$out" | awk 'NR==1 {print $2}'
}

up() {
  local current new
  current=$(get_raw) || return 1
  new=$(echo "$current $STEP" | awk '{v = $1 + $2; if (v > 1) v = 1; print v}')
  busctl --user set-property "$SVC" "$OBJ" "$IFACE" Brightness d "$new" 2>/dev/null ||
    err "failed to set brightness"
}

down() {
  local current new
  current=$(get_raw) || return 1
  new=$(echo "$current $STEP" | awk '{v = $1 - $2; if (v < 0) v = 0; print v}')
  busctl --user set-property "$SVC" "$OBJ" "$IFACE" Brightness d "$new" 2>/dev/null ||
    err "failed to set brightness"
}

get() {
  local raw
  raw=$(get_raw) || return 1
  echo "$raw" | awk '{printf "%.0f%%\n", $1 * 100}'
}

case "${1:-}" in
  up | increase) up ;;
  down | decrease) down ;;
  get | "") get ;;
  *)
    echo "Usage: brightness {up|down|get}"
    exit 1
    ;;
esac
