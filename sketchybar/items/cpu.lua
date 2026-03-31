local sbar = require("sketchybar")
local config_dir = os.getenv("HOME") .. "/.config/sketchybar"
local script = config_dir .. "/plugins/cpu.sh"

local cpu = sbar.add("item", "cpu.percent", {
  position    = "right",
  update_freq = 2,
  icon = {
    string        = "CPU",
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
  background = { padding_left = 6, padding_right = 9 },
})

cpu:subscribe("routine", function()
  sbar.exec("NAME=cpu.percent " .. script)
end)

sbar.exec("NAME=cpu.percent " .. script)
