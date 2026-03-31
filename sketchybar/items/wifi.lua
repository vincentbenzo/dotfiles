local sbar = require("sketchybar")
local icons = require("icons")
local config_dir = os.getenv("HOME") .. "/.config/sketchybar"
local script = config_dir .. "/plugins/wifi.sh"

local wifi = sbar.add("item", "wifi", {
  position    = "right",
  update_freq = 10,
  icon = {
    string        = icons.wifi,
    font          = "JetBrainsMono Nerd Font:Regular:18.0",
    padding_left  = 6,
    padding_right = 2,
  },
  label = { drawing = "off" },
})

wifi:subscribe("routine", function()
  sbar.exec("NAME=wifi " .. script)
end)

wifi:subscribe({"mouse.entered", "mouse.exited"}, function(env)
  sbar.exec("NAME=wifi SENDER=" .. env.SENDER .. " " .. script)
end)

sbar.exec("NAME=wifi " .. script)
