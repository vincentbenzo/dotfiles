#!/usr/bin/env sh

URL=$(cat /tmp/sketchybar_meeting_url 2>/dev/null)
if [ -n "$URL" ]; then
  open "$URL"
else
  open -a "Notion Calendar"
fi
