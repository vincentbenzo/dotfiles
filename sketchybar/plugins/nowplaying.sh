#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"

INFO=$(media-control get 2>/dev/null)

if [ -z "$INFO" ] || [ "$INFO" = "null" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

PLAYING=$(echo "$INFO" | jq -r '.playing // false')
TITLE=$(echo "$INFO" | jq -r '.title // empty')
ARTIST=$(echo "$INFO" | jq -r '.artist // empty')

if [ -z "$TITLE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ "$PLAYING" = "true" ]; then
  ICON="$MUSIC_PLAY"
else
  ICON="$MUSIC_PAUSE"
fi

LABEL="$ARTIST – $TITLE"

sketchybar --set "$NAME" drawing=on icon="$ICON" label="$LABEL"
