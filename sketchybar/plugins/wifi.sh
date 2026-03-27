#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"

WIFI_INFO="$(ipconfig getsummary en0 2>/dev/null)"
SSID="$(echo "$WIFI_INFO" | awk -F ' : ' '/^ *SSID/{print $2}')"
IS_CONNECTED="$(echo "$WIFI_INFO" | grep -c 'BSSID')"

case "$SENDER" in
  "mouse.entered")
    if [ "$IS_CONNECTED" -gt 0 ]; then
      if [ -n "$SSID" ] && [ "$SSID" != "<redacted>" ]; then
        sketchybar --set "$NAME" label="$SSID" label.drawing=on
      else
        sketchybar --set "$NAME" label="Connected" label.drawing=on
      fi
    else
      sketchybar --set "$NAME" label="Disconnected" label.drawing=on
    fi
    ;;
  "mouse.exited")
    sketchybar --set "$NAME" label.drawing=off
    ;;
  *)
    if [ "$IS_CONNECTED" -gt 0 ]; then
      sketchybar --set "$NAME" icon=$WIFI_ICN
    else
      sketchybar --set "$NAME" icon=󰤭 label.drawing=off
    fi
    ;;
esac
