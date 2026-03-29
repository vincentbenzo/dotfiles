#!/usr/bin/env sh

# Called from popup "Join meeting" link
URL=$(cat /tmp/sketchybar_meeting_url 2>/dev/null)
if [ -n "$URL" ]; then
  open "$URL"
fi
sketchybar --set calendar popup.drawing=off
