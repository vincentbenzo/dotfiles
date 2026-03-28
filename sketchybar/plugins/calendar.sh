#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

# Use AppleScript to get next upcoming non-all-day event from Calendar.app
EVENT_INFO=$(osascript <<'APPLESCRIPT'
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

    if (count of allEvents) = 0 then return ""

    -- Find the soonest event
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

    -- Try to find meeting URL in url, notes, or location
    set meetURL to ""
    try
        set u to url of nextEvt
        if u is not missing value then set meetURL to u
    end try
    if meetURL is "" then
        try
            set n to description of nextEvt
            if n is not missing value then set meetURL to n
        end try
    end if
    if meetURL is "" then
        try
            set loc to location of nextEvt
            if loc is not missing value then set meetURL to loc
        end try
    end if

    return evtTitle & "||" & evtTime & "||" & meetURL
end tell
APPLESCRIPT
)

if [ -z "$EVENT_INFO" ]; then
  sketchybar --set "$NAME" drawing=off
  rm -f /tmp/sketchybar_meeting_url
  exit 0
fi

# Parse fields (separated by ||)
TITLE=$(echo "$EVENT_INFO" | cut -d'|' -f1 | cut -c1-30)
START_TIME=$(echo "$EVENT_INFO" | cut -d'|' -f3)
RAW_URL=$(echo "$EVENT_INFO" | cut -d'|' -f5-)

# Extract meeting URL (Zoom, Google Meet, Teams, Webex)
MEET_URL=$(echo "$RAW_URL" | grep -oE 'https?://[^ )]*zoom\.[^ )]*|https?://meet\.google\.com/[^ )]*|https?://teams\.microsoft\.com/[^ )]*|https?://[^ )]*webex[^ )]*' | head -1)

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
