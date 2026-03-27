#!/usr/bin/env sh

source "$HOME/.config/sketchybar/icons.sh"

if ! pgrep -x "Deezer" > /dev/null; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

STATE=$(osascript -e 'tell application "Deezer" to get player state' 2>/dev/null)

case "$STATE" in
  "playing")
    ICON="$MUSIC_PLAY"
    TRACK=$(osascript -e 'tell application "Deezer" to get title of current track' 2>/dev/null)
    ARTIST=$(osascript -e 'tell application "Deezer" to get artist of current track' 2>/dev/null)
    LABEL="$ARTIST – $TRACK"
    ;;
  "paused")
    ICON="$MUSIC_PAUSE"
    TRACK=$(osascript -e 'tell application "Deezer" to get title of current track' 2>/dev/null)
    ARTIST=$(osascript -e 'tell application "Deezer" to get artist of current track' 2>/dev/null)
    LABEL="$ARTIST – $TRACK"
    ;;
  *)
    sketchybar --set "$NAME" drawing=off
    exit 0
    ;;
esac

sketchybar --set "$NAME" drawing=on icon="$ICON" label="$LABEL"
