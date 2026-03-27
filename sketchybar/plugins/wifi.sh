#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"

CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')"

if [ -n "$SSID" ]; then
  sketchybar --set "$NAME" icon=$WIFI_ICN
else
  sketchybar --set "$NAME" icon=󰤭
fi
