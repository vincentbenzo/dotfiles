#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

if ! pgrep -x "Slack" > /dev/null; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

COUNT=$(lsappinfo info -only StatusLabel Slack | sed -n 's/.*"label"="\(.*\)".*/\1/p')

if [ -z "$COUNT" ]; then
  sketchybar --set "$NAME" drawing=on label=""
else
  sketchybar --set "$NAME" drawing=on label="$COUNT" label.color=$RED
fi
