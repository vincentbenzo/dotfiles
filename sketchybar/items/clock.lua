local sbar = require("sketchybar")
local config_dir = os.getenv("HOME") .. "/.config/sketchybar"
local script = config_dir .. "/plugins/clock.sh"

local clock = sbar.add("item", "clock", {
  position    = "right",
  update_freq = 1,
  label       = { font = "JetBrainsMono Nerd Font:Regular:14.0" },
  width       = 155,
  background  = { padding_left = 6, padding_right = 8 },
})

clock:subscribe("routine", function()
  sbar.exec("NAME=clock " .. script)
end)

sbar.exec("NAME=clock " .. script)
