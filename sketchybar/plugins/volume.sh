#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

# Determine current volume
if [ "$SENDER" = "volume_change" ]; then
  VOL="$INFO"
elif [ "$SENDER" = "mouse.scrolled" ]; then
  VOL=$(osascript -e 'output volume of (get volume settings)')
  VOL=$((VOL + SCROLL_DELTA * 5))
  [ "$VOL" -lt 0 ] && VOL=0
  [ "$VOL" -gt 100 ] && VOL=100
  osascript -e "set volume output volume $VOL"
elif [ "$SENDER" = "mouse.clicked" ]; then
  VOL=$(osascript -e 'output volume of (get volume settings)')
  if [ "$VOL" -gt 0 ]; then
    VOL=0
  else
    VOL=50
  fi
  osascript -e "set volume output volume $VOL"
else
  VOL=$(osascript -e 'output volume of (get volume settings)')
fi

# Shift single-digit values right to keep them centered
if [ "$VOL" -lt 10 ] 2>/dev/null; then
  PADDING=4
else
  PADDING=0
fi

COLOR=$WHITE
if [ "$VOL" -eq 0 ] 2>/dev/null; then
  COLOR=$GREY
fi

sketchybar --set volume label="${VOL}%" \
                         label.color=$COLOR \
                         label.padding_left=$PADDING
