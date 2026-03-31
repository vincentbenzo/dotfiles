local sbar = require("sketchybar")
local colors = require("colors")

local config_dir = os.getenv("HOME") .. "/.config/sketchybar"

-- State
local cached_event = nil -- { title, start_time, raw_text }
local meeting_url = nil
local query_running = false
local CACHE_FILE = "/tmp/sketchybar_cal_event"
local URL_FILE = "/tmp/sketchybar_meeting_url"

-- Persist cache to disk (survives reloads, matches old shell behavior)
local function save_cache()
  local f = io.open(CACHE_FILE, "w")
  if f then
    if cached_event then
      f:write(cached_event.title .. "||" .. cached_event.start_time .. "||" .. cached_event.raw_text)
    end
    f:close()
  end
  if meeting_url then
    local uf = io.open(URL_FILE, "w")
    if uf then uf:write(meeting_url); uf:close() end
  else
    os.remove(URL_FILE)
  end
end

-- Load cache from disk on startup
local function load_cache()
  local f = io.open(CACHE_FILE, "r")
  if f then
    local line = f:read("*l")
    f:close()
    if line and line ~= "" then
      local title, time_str, raw = line:match("^(.-)%|%|(.-)%|%|(.*)$")
      if title then
        cached_event = {
          title      = title:sub(1, 30),
          start_time = time_str,
          raw_text   = raw,
        }
        return
      end
    end
  end
  cached_event = nil
end

-- Load calendar name from env file
local calendar_name = ""
do
  local f = io.open(config_dir .. "/plugins/calendar.env", "r")
  if f then
    for line in f:lines() do
      local val = line:match('^CALENDAR_NAME="(.-)"')
                  or line:match("^CALENDAR_NAME='(.-)'")
                  or line:match("^CALENDAR_NAME=(%S+)")
      if val then calendar_name = val end
    end
    f:close()
  end
end

-- Create item
local calendar = sbar.add("item", "calendar", {
  position    = "right",
  update_freq = 30,
  updates     = "on",
  icon = {
    string        = "󰃰",
    padding_left  = 8,
    padding_right = 4,
  },
  label = {
    padding_left  = 0,
    padding_right = 8,
    font          = "JetBrainsMono Nerd Font:Mono:14.0",
  },
})

-- Extract meeting URL from text
local function extract_url(text)
  if not text then return nil end
  local patterns = {
    "https?://[^ ]*zoom%.[^ ]*",
    "https?://meet%.google%.com/[^ ]*",
    "https?://teams%.microsoft%.com/[^ ]*",
    "https?://[^ ]*webex[^ ]*",
  }
  for _, pat in ipairs(patterns) do
    local url = text:match(pat)
    if url then return url end
  end
  return nil
end

-- Update bar display from cached state
local function update_display()
  if not cached_event then
    calendar:set({ drawing = false })
    meeting_url = nil
    return
  end

  local title = cached_event.title
  local start_time = cached_event.start_time
  meeting_url = extract_url(cached_event.raw_text)

  -- Calculate time remaining
  local color = colors.white
  local remaining = ""

  if start_time and start_time ~= "" then
    local hour, min = start_time:match("(%d+):(%d+)")
    if hour and min then
      local now = os.time()
      local t = os.date("*t")
      local evt_time = os.time({
        year = t.year, month = t.month, day = t.day,
        hour = tonumber(hour), min = tonumber(min), sec = 0,
      })
      local diff_min = math.floor((evt_time - now) / 60)

      if diff_min <= -5 then
        -- Event started more than 5 min ago, stale
        cached_event = nil
        meeting_url = nil
        calendar:set({ drawing = false })
        return
      elseif diff_min <= 0 then
        remaining = "Now"
        color = colors.red
      elseif diff_min <= 5 then
        remaining = "in " .. diff_min .. "m"
        color = colors.red
      elseif diff_min <= 15 then
        remaining = "in " .. diff_min .. "m"
        color = colors.orange
      elseif diff_min <= 60 then
        remaining = "in " .. diff_min .. "m"
        color = colors.yellow
      else
        local h = math.floor(diff_min / 60)
        local m = diff_min % 60
        remaining = m > 0 and ("in " .. h .. "h" .. m .. "m") or ("in " .. h .. "h")
      end
    else
      remaining = start_time
    end
  end

  local label = remaining ~= "" and (title .. " · " .. remaining) or title
  local icon = meeting_url and "󰍫" or "󰀄"

  calendar:set({
    drawing = true,
    icon  = { string = icon, color = color },
    label = { string = label, color = color },
  })
end

-- Async fetch calendar data via AppleScript
local function fetch_calendar()
  if query_running then return end
  query_running = true

  local safe_name = calendar_name:gsub("'", "'\\''")
  -- Ensure Calendar.app is running (background, no window focus)
  local cmd = "pgrep -q Calendar || open -gja Calendar; "
  cmd = cmd .. "osascript '" .. config_dir .. "/helpers/calendar_query.applescript' '" .. safe_name .. "'"

  sbar.exec(cmd, function(result)
    query_running = false

    if result and result ~= "" then
      result = result:gsub("%s+$", "") -- trim trailing whitespace

      if result == "NONE" then
        cached_event = nil
      else
        -- Parse: title||HH:MM||rawtext
        local title, time_str, raw = result:match("^(.-)%|%|(.-)%|%|(.*)$")
        if title then
          cached_event = {
            title      = title:sub(1, 30),
            start_time = time_str,
            raw_text   = raw,
          }
        else
          cached_event = nil
        end
      end
    end

    save_cache()
    update_display()
  end)
end

-- Periodic update (fires every update_freq seconds)
calendar:subscribe("routine", function(env)
  fetch_calendar()
  update_display() -- show cached data immediately while async query runs
end)

-- Click handler
calendar:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    sbar.exec("open -a 'Notion Calendar'")
    return
  end
  if meeting_url then
    sbar.exec("open '" .. meeting_url:gsub("'", "'\\''") .. "'")
  else
    sbar.exec("open -a 'Notion Calendar'")
  end
end)

-- Load persisted cache and display immediately, then fetch fresh data
load_cache()
update_display()
fetch_calendar()
