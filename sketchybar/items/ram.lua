local sbar = require("sketchybar")
local config_dir = os.getenv("HOME") .. "/.config/sketchybar"
local script = config_dir .. "/plugins/ram.sh"

local ram = sbar.add("item", "ram.percent", {
  position    = "right",
  update_freq = 2,
  icon = {
    string        = "RAM",
    font          = "JetBrainsMono Nerd Font:Mono:8.0",
    color         = 0xffffffff,
    y_offset      = 10,
    padding_left  = 13,
    padding_right = -18,
  },
  label = {
    font         = "JetBrainsMono Nerd Font:Mono:12.0",
    padding_left = 0,
  },
  y_offset   = -4,
  width      = 40,
  background = { padding_left = 4, padding_right = 1 },
})

ram:subscribe("routine", function()
  sbar.exec("NAME=ram.percent " .. script)
end)

sbar.exec("NAME=ram.percent " .. script)
