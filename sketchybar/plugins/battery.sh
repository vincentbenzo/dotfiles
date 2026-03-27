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

# 10-level Nerd Font battery icons (discharge)
if [ -z "$CHARGING" ]; then
  case ${PERCENTAGE} in
    9[0-9]|100) ICON=$(printf '\U000F0079') ;;
    8[0-9])     ICON=$(printf '\U000F0082') ;;
    7[0-9])     ICON=$(printf '\U000F0080') ;;
    6[0-9])     ICON=$(printf '\U000F007F') ;;
    5[0-9])     ICON=$(printf '\U000F007E') ;;
    4[0-9])     ICON=$(printf '\U000F007D') ;;
    3[0-9])     ICON=$(printf '\U000F007C') ;;
    2[0-9])     ICON=$(printf '\U000F007B') ;;
    1[0-9])     ICON=$(printf '\U000F007A') ;;
    *)          ICON=$(printf '\U000F008E') ;;
  esac
else
  # 10-level Nerd Font battery icons (charging)
  case ${PERCENTAGE} in
    9[0-9]|100) ICON=$(printf '\U000F0085') ;;
    8[0-9])     ICON=$(printf '\U000F008A') ;;
    7[0-9])     ICON=$(printf '\U000F089E') ;;
    6[0-9])     ICON=$(printf '\U000F0089') ;;
    5[0-9])     ICON=$(printf '\U000F089D') ;;
    4[0-9])     ICON=$(printf '\U000F0088') ;;
    3[0-9])     ICON=$(printf '\U000F0087') ;;
    2[0-9])     ICON=$(printf '\U000F0086') ;;
    1[0-9])     ICON=$(printf '\U000F089C') ;;
    *)          ICON=$(printf '\U000F089F') ;;
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
