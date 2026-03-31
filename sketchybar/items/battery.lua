local sbar = require("sketchybar")
local config_dir = os.getenv("HOME") .. "/.config/sketchybar"
local script = config_dir .. "/plugins/battery.sh"

local battery = sbar.add("item", "battery", {
  position    = "right",
  update_freq = 120,
  icon = {
    font          = "SF Pro:Regular:14.0",
    y_offset      = 13,
    padding_left  = 10,
    padding_right = -22,
  },
  label = {
    font         = "JetBrainsMono Nerd Font:Mono:12.0",
    padding_left = 0,
  },
  y_offset   = -4,
  width      = 40,
  background = { padding_left = 12, padding_right = 12 },
  popup      = { align = "right" },
})

sbar.add("item", "battery.details", {
  position = "popup.battery",
  icon     = { drawing = "off" },
  label    = {
    font   = "JetBrainsMono Nerd Font:Mono:12.0",
    string = "Loading...",
  },
})

local function run_battery(env)
  local cmd = "NAME=battery SENDER=" .. (env.SENDER or "routine")
  if env.BUTTON then cmd = cmd .. " BUTTON=" .. env.BUTTON end
  cmd = cmd .. " " .. script
  sbar.exec(cmd)
end

battery:subscribe("routine", run_battery)
battery:subscribe({"system_woke", "power_source_change"}, run_battery)
battery:subscribe("mouse.clicked", run_battery)

-- Initial update
run_battery({ SENDER = "routine" })
