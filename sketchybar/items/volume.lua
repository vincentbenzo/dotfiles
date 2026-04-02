local sbar = require("sketchybar")
local colors = require("colors")
local icons = require("icons")
local config_dir = os.getenv("HOME") .. "/.config/sketchybar"
local script = config_dir .. "/plugins/volume.sh"

local volume = sbar.add("item", "volume", {
  position = "right",
  icon = {
    string        = "VOL",
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

volume:subscribe("volume_change", function(env)
  sbar.exec("SENDER=volume_change INFO=" .. (env.INFO or "0") .. " NAME=volume " .. script)
end)

volume:subscribe("mouse.scrolled", function(env)
  sbar.exec("SENDER=mouse.scrolled SCROLL_DELTA=" .. (env.SCROLL_DELTA or "0") .. " NAME=volume " .. script)
end)

volume:subscribe("mouse.clicked", function(env)
  sbar.exec("SENDER=mouse.clicked NAME=volume " .. script)
end)

sbar.exec("NAME=volume " .. script)
