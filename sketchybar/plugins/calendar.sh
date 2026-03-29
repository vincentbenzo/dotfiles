#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

LOCK="/tmp/sketchybar_cal.lock"
CACHE="/tmp/sketchybar_cal_event"

# Handle clicks
if [ "$SENDER" = "mouse.clicked" ]; then
  if [ "$BUTTON" = "right" ]; then
    open -a "Notion Calendar"
    exit 0
  fi
  URL=$(cat /tmp/sketchybar_meeting_url 2>/dev/null)
  if [ -n "$URL" ]; then
    open "$URL"
  else
    open -a "Notion Calendar"
  fi
  exit 0
fi

# Kill stale lock (older than 2 minutes)
find "$LOCK" -mmin +2 -delete 2>/dev/null

# Launch background AppleScript query if not already running
if [ ! -f "$LOCK" ]; then
  touch "$LOCK"
  (
    RESULT=$(osascript <<'APPLESCRIPT'
use framework "Foundation"
use scripting additions

set now to current date
set tomorrow to now + (1 * days)

tell application "Calendar"
    set allEvents to {}
    repeat with cal in calendars
        try
            set evts to (every event of cal whose start date >= now and start date < tomorrow and allday event is false)
            set allEvents to allEvents & evts
        end try
    end repeat

    if (count of allEvents) = 0 then return "NONE"

    set nextEvt to item 1 of allEvents
    repeat with evt in allEvents
        if start date of evt < start date of nextEvt then
            set nextEvt to evt
        end if
    end repeat

    set evtTitle to summary of nextEvt
    set evtStart to start date of nextEvt
    set evtHour to text -2 thru -1 of ("0" & (hours of evtStart as text))
    set evtMin to text -2 thru -1 of ("0" & (minutes of evtStart as text))
    set evtTime to evtHour & ":" & evtMin

    set rawText to ""
    try
        set u to url of nextEvt
        if u is not missing value then set rawText to rawText & " " & u
    end try
    try
        set n to description of nextEvt
        if n is not missing value then set rawText to rawText & " " & n
    end try
    try
        set loc to location of nextEvt
        if loc is not missing value then set rawText to rawText & " " & loc
    end try

    return evtTitle & "||" & evtTime & "||" & rawText
end tell
APPLESCRIPT
    )

    # Only update cache if AppleScript returned something
    if [ -n "$RESULT" ]; then
      if [ "$RESULT" = "NONE" ]; then
        echo "" > "$CACHE"
      else
        echo "$RESULT" > "$CACHE"
      fi
    fi
    rm -f "$LOCK"
  ) &
fi

# Display from cache
FULL_CACHE=""
if [ -f "$CACHE" ]; then
  FULL_CACHE=$(cat "$CACHE")
fi

FIRST_LINE=$(echo "$FULL_CACHE" | head -1)

if [ -z "$FIRST_LINE" ]; then
  sketchybar --set "$NAME" drawing=off
  rm -f /tmp/sketchybar_meeting_url
  exit 0
fi

# Parse title and time from first line
TITLE=$(echo "$FIRST_LINE" | cut -d'|' -f1 | cut -c1-30)
START_TIME=$(echo "$FIRST_LINE" | cut -d'|' -f3)

# Extract meeting URL from full cache (URL may be on later lines)
MEET_URL=$(echo "$FULL_CACHE" | grep -oE 'https?://[^ )"]*zoom\.[^ )"]*|https?://meet\.google\.com/[^ )"]*|https?://teams\.microsoft\.com/[^ )"]*|https?://[^ )"]*webex[^ )"]*' | head -1)

if [ -n "$MEET_URL" ]; then
  echo "$MEET_URL" > /tmp/sketchybar_meeting_url
else
  rm -f /tmp/sketchybar_meeting_url
fi

# Calculate time remaining
COLOR=$WHITE
if [ -n "$START_TIME" ]; then
  NOW_EPOCH=$(date +%s)
  EVT_EPOCH=$(date -j -f "%H:%M" "$START_TIME" +%s 2>/dev/null)

  if [ -n "$EVT_EPOCH" ]; then
    DIFF_SEC=$((EVT_EPOCH - NOW_EPOCH))
    DIFF_MIN=$((DIFF_SEC / 60))

    if [ "$DIFF_MIN" -le 0 ]; then
      REMAINING="Now"
      COLOR=$RED
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

if [ -n "$REMAINING" ]; then
  LABEL="$TITLE · $REMAINING"
else
  LABEL="$TITLE"
fi

if [ -n "$MEET_URL" ]; then
  ICON="󰍫"
else
  ICON="󰀄"
fi

sketchybar --set "$NAME" drawing=on icon="$ICON" label="$LABEL" label.color=$COLOR icon.color=$COLOR
