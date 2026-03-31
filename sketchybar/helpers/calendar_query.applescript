use framework "Foundation"
use scripting additions

on run argv
    set calFilter to ""
    if (count of argv) > 0 then set calFilter to item 1 of argv

    set now to current date

    -- Start and end of today
    set startOfDay to now
    set time of startOfDay to 0
    set endOfDay to startOfDay + (1 * days)

    tell application "Calendar"
        -- Get all of today's non-allday events, then filter for future ones in code
        set todayEvents to {}
        repeat with cal in calendars
            try
                if calFilter is "" or (name of cal) is calFilter then
                    set evts to (every event of cal whose start date >= startOfDay and start date < endOfDay and allday event is false)
                    set todayEvents to todayEvents & evts
                end if
            end try
        end repeat

        -- Filter to only future events (start date >= now)
        set futureEvents to {}
        repeat with evt in todayEvents
            if start date of evt >= now then
                set end of futureEvents to evt
            end if
        end repeat

        if (count of futureEvents) = 0 then return "NONE"

        -- Find the soonest future event
        set nextEvt to item 1 of futureEvents
        repeat with evt in futureEvents
            if start date of evt < start date of nextEvt then
                set nextEvt to evt
            end if
        end repeat

        set evtTitle to summary of nextEvt
        set evtStart to start date of nextEvt
        set evtHour to text -2 thru -1 of ("0" & (hours of evtStart as text))
        set evtMin to text -2 thru -1 of ("0" & (minutes of evtStart as text))
        set evtTime to evtHour & ":" & evtMin

        -- Collect all text fields, then extract a meeting URL
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

        -- Extract meeting URL from rawText using NSRegularExpression
        set meetURL to ""
        set nsText to current application's NSString's stringWithString:rawText
        set urlPattern to "https?://[^ \\n]*(zoom\\.[^ \\n]*|meet\\.google\\.com/[^ \\n]*|teams\\.microsoft\\.com/[^ \\n]*|webex[^ \\n]*)"
        set regex to current application's NSRegularExpression's regularExpressionWithPattern:urlPattern options:0 |error|:(missing value)
        set match to regex's firstMatchInString:nsText options:0 range:{0, nsText's |length|()}
        if match is not missing value then
            set matchRange to match's range()
            set meetURL to (nsText's substringWithRange:matchRange) as text
        end if

        return evtTitle & "||" & evtTime & "||" & meetURL
    end tell
end run
