#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"

SSID="$(ipconfig getsummary en0 2>/dev/null | awk -F ' : ' '/SSID/{print $2}')"

if [ -n "$SSID" ]; then
  sketchybar --set "$NAME" icon=$WIFI_ICN
else
  sketchybar --set "$NAME" icon=󰤭
fi
