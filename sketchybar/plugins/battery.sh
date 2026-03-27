#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

# Right-click: open Battery preferences
if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    open "x-apple.systempreferences:com.apple.preference.battery"
    exit 0
  fi

  # Left-click: toggle popup with time remaining
  TIME_REMAINING=$(pmset -g batt | grep -Eo '\d+:\d+' | head -1)
  CHARGING=$(pmset -g batt | grep 'AC Power')

  if [ -z "$TIME_REMAINING" ] || [ "$TIME_REMAINING" = "0:00" ]; then
    DETAIL="Calculating..."
  elif [ -n "$CHARGING" ]; then
    DETAIL="Charging — $TIME_REMAINING remaining"
  else
    DETAIL="$TIME_REMAINING remaining"
  fi

  sketchybar --set battery.details label="$DETAIL" \
             --set battery popup.drawing=toggle
  exit 0
fi

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Leading zero for single digits
if [ "$PERCENTAGE" -lt 10 ]; then
  LABEL="0${PERCENTAGE}%"
else
  LABEL="${PERCENTAGE}%"
fi

# 10-level Nerd Font battery icons (raw UTF-8 bytes for /bin/sh compatibility)
if [ -z "$CHARGING" ]; then
  case ${PERCENTAGE} in
    9[0-9]|100) ICON=$(printf '\xf3\xb0\x81\xb9') ;; # U+F0079 battery
    8[0-9])     ICON=$(printf '\xf3\xb0\x82\x82') ;; # U+F0082 battery-90
    7[0-9])     ICON=$(printf '\xf3\xb0\x82\x80') ;; # U+F0080 battery-70
    6[0-9])     ICON=$(printf '\xf3\xb0\x81\xbf') ;; # U+F007F battery-60
    5[0-9])     ICON=$(printf '\xf3\xb0\x81\xbe') ;; # U+F007E battery-50
    4[0-9])     ICON=$(printf '\xf3\xb0\x81\xbd') ;; # U+F007D battery-40
    3[0-9])     ICON=$(printf '\xf3\xb0\x81\xbc') ;; # U+F007C battery-30
    2[0-9])     ICON=$(printf '\xf3\xb0\x81\xbb') ;; # U+F007B battery-20
    1[0-9])     ICON=$(printf '\xf3\xb0\x81\xba') ;; # U+F007A battery-10
    *)          ICON=$(printf '\xf3\xb0\x82\x8e') ;; # U+F008E battery-outline
  esac
else
  # Charging variants with bolt overlay
  case ${PERCENTAGE} in
    9[0-9]|100) ICON=$(printf '\xf3\xb0\x82\x85') ;; # U+F0085 battery-charging-100
    8[0-9])     ICON=$(printf '\xf3\xb0\x82\x8a') ;; # U+F008A battery-charging-80
    7[0-9])     ICON=$(printf '\xf3\xb0\xa2\x9e') ;; # U+F089E battery-charging-70
    6[0-9])     ICON=$(printf '\xf3\xb0\x82\x89') ;; # U+F0089 battery-charging-60
    5[0-9])     ICON=$(printf '\xf3\xb0\xa2\x9d') ;; # U+F089D battery-charging-50
    4[0-9])     ICON=$(printf '\xf3\xb0\x82\x88') ;; # U+F0088 battery-charging-40
    3[0-9])     ICON=$(printf '\xf3\xb0\x82\x87') ;; # U+F0087 battery-charging-30
    2[0-9])     ICON=$(printf '\xf3\xb0\x82\x86') ;; # U+F0086 battery-charging-20
    1[0-9])     ICON=$(printf '\xf3\xb0\xa2\x9c') ;; # U+F089C battery-charging-10
    *)          ICON=$(printf '\xf3\xb0\xa2\x9f') ;; # U+F089F battery-charging-outline
  esac
fi

# Color coding: green when charging or >60%, white 40-60%, orange 20-40%, red <20%
if [ -n "$CHARGING" ]; then
  COLOR=$GREEN
elif [ "$PERCENTAGE" -gt 60 ]; then
  COLOR=$GREEN
elif [ "$PERCENTAGE" -gt 40 ]; then
  COLOR=$WHITE
elif [ "$PERCENTAGE" -gt 20 ]; then
  COLOR=$ORANGE
else
  COLOR=$RED
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR \
                         label="$LABEL" label.color=$COLOR
