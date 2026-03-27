#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"

if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  sketchybar --set appearance icon="$SUN_ICN"
else
  sketchybar --set appearance icon="$MOON_ICN"
fi
