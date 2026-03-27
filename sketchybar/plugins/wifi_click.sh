#!/usr/bin/env sh

CURRENT_WIFI="$(ipconfig getsummary en0 2>/dev/null)"
SSID="$(echo "$CURRENT_WIFI" | awk -F ' : ' '/SSID/{print $2}')"
CURR_TX="$(echo "$CURRENT_WIFI" | awk -F ' : ' '/lastTxRate/{print $2}')"

if [ -n "$CURR_TX" ]; then
  sketchybar --set "$NAME" label="${CURR_TX}Mbps"
else
  sketchybar --set "$NAME" label="$SSID"
fi
