#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"

case "$SENDER" in
  "mouse.entered")
    SSID="$(ipconfig getsummary en0 2>/dev/null | awk -F ' : ' '/SSID/{print $2}')"
    if [ -n "$SSID" ]; then
      sketchybar --set "$NAME" label="$SSID" label.drawing=on
    else
      sketchybar --set "$NAME" label="Disconnected" label.drawing=on
    fi
    ;;
  "mouse.exited")
    sketchybar --set "$NAME" label.drawing=off
    ;;
  *)
    SSID="$(ipconfig getsummary en0 2>/dev/null | awk -F ' : ' '/SSID/{print $2}')"
    if [ -n "$SSID" ]; then
      sketchybar --set "$NAME" icon=$WIFI_ICN
    else
      sketchybar --set "$NAME" icon=􀙈 label.drawing=off
    fi
    ;;
esac
