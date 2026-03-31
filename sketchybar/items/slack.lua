local sbar = require("sketchybar")
local config_dir = os.getenv("HOME") .. "/.config/sketchybar"
local script = config_dir .. "/plugins/slack.sh"

local slack = sbar.add("item", "slack", {
  position     = "right",
  update_freq  = 10,
  icon = {
    string        = "󰒱",
    font          = "JetBrainsMono Nerd Font:Regular:18.0",
    padding_left  = 6,
    padding_right = 0,
  },
  label = {
    padding_left  = 0,
    padding_right = 6,
    y_offset      = 5,
    font          = "JetBrainsMono Nerd Font:Mono:13.0",
  },
})

slack:subscribe("routine", function()
  sbar.exec("NAME=slack " .. script)
end)

slack:subscribe("mouse.clicked", function()
  sbar.exec("open -a Slack")
end)

sbar.exec("NAME=slack " .. script)
