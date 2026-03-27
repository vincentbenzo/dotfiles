#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"

case "$SENDER" in
  "mouse.entered")
    SSID="$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/Current Wi-Fi Network: //')"
    if [ -n "$SSID" ] && [ "$SSID" != "You are not associated with an AirPort network." ]; then
      sketchybar --set "$NAME" label="$SSID" label.drawing=on
    else
      sketchybar --set "$NAME" label="Disconnected" label.drawing=on
    fi
    ;;
  "mouse.exited")
    sketchybar --set "$NAME" label.drawing=off
    ;;
  *)
    SSID="$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/Current Wi-Fi Network: //')"
    if [ -n "$SSID" ] && [ "$SSID" != "You are not associated with an AirPort network." ]; then
      sketchybar --set "$NAME" icon=$WIFI_ICN
    else
      sketchybar --set "$NAME" icon=󰤭 label.drawing=off
    fi
    ;;
esac
