#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

HELPER="$HOME/.config/sketchybar/helpers/brightness.py"

read_brightness() {
  python3 "$HELPER" 2>/dev/null || echo 50
}

set_brightness() {
  python3 "$HELPER" "$1" 2>/dev/null
}

# Determine current brightness
if [ "$SENDER" = "mouse.scrolled" ]; then
  PCT=$(read_brightness)
  PCT=$((PCT + SCROLL_DELTA * 5))
  [ "$PCT" -lt 0 ] && PCT=0
  [ "$PCT" -gt 100 ] && PCT=100
  set_brightness "$PCT"
else
  PCT=$(read_brightness)
fi

# Shift single-digit values right to keep them centered
if [ "$PCT" -lt 10 ] 2>/dev/null; then
  PADDING=4
else
  PADDING=0
fi

sketchybar --set brightness label="${PCT}%" \
                             label.padding_left=$PADDING
