#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

if ! command -v icalBuddy &>/dev/null; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Get next non-all-day event (title + time + url/notes/location for meeting link)
EVENT_INFO=$(icalBuddy -n -li 1 -nc -ea -nrd -b "" -df "" -tf "%H:%M" \
  -iep "title,datetime,notes,url,location" eventsToday+1 2>/dev/null)

if [ -z "$EVENT_INFO" ]; then
  sketchybar --set "$NAME" drawing=off
  rm -f /tmp/sketchybar_meeting_url
  exit 0
fi

# Parse title (first non-empty, non-indented line)
TITLE=$(echo "$EVENT_INFO" | head -1 | sed 's/^[[:space:]]*//' | cut -c1-30)

# Parse start time (first HH:MM occurrence)
START_TIME=$(echo "$EVENT_INFO" | grep -oE '[0-9]{2}:[0-9]{2}' | head -1)

# Extract meeting URL (Zoom, Google Meet, Teams, Webex)
MEET_URL=$(echo "$EVENT_INFO" | grep -oE 'https?://[^ )]*zoom\.[^ )]*|https?://meet\.google\.com/[^ )]*|https?://teams\.microsoft\.com/[^ )]*|https?://[^ )]*webex[^ )]*' | head -1)

# Save meeting URL for click handler
if [ -n "$MEET_URL" ]; then
  echo "$MEET_URL" > /tmp/sketchybar_meeting_url
else
  rm -f /tmp/sketchybar_meeting_url
fi

# Calculate time remaining
COLOR=$WHITE
ICON="󰃰"
if [ -n "$START_TIME" ]; then
  NOW_EPOCH=$(date +%s)
  EVT_HOUR=$(echo "$START_TIME" | cut -d: -f1 | sed 's/^0//')
  EVT_MIN=$(echo "$START_TIME" | cut -d: -f2 | sed 's/^0//')
  # Build today's event timestamp
  EVT_EPOCH=$(date -j -f "%H:%M" "$START_TIME" +%s 2>/dev/null)

  if [ -n "$EVT_EPOCH" ]; then
    DIFF_SEC=$((EVT_EPOCH - NOW_EPOCH))
    DIFF_MIN=$((DIFF_SEC / 60))

    if [ "$DIFF_MIN" -le 0 ]; then
      REMAINING="Now"
      COLOR=$RED
      ICON="󰃰"
    elif [ "$DIFF_MIN" -le 5 ]; then
      REMAINING="in ${DIFF_MIN}m"
      COLOR=$RED
    elif [ "$DIFF_MIN" -le 15 ]; then
      REMAINING="in ${DIFF_MIN}m"
      COLOR=$ORANGE
    elif [ "$DIFF_MIN" -le 60 ]; then
      REMAINING="in ${DIFF_MIN}m"
      COLOR=$YELLOW
    else
      HOURS=$((DIFF_MIN / 60))
      MINS=$((DIFF_MIN % 60))
      if [ "$MINS" -gt 0 ]; then
        REMAINING="in ${HOURS}h${MINS}m"
      else
        REMAINING="in ${HOURS}h"
      fi
    fi
  else
    REMAINING="$START_TIME"
  fi
else
  REMAINING=""
fi

# Build label
if [ -n "$REMAINING" ]; then
  LABEL="$TITLE · $REMAINING"
else
  LABEL="$TITLE"
fi

# Show video icon if there's a meeting link
if [ -n "$MEET_URL" ]; then
  ICON="󰍫"
fi

sketchybar --set "$NAME" drawing=on icon="$ICON" label="$LABEL" label.color=$COLOR icon.color=$COLOR
