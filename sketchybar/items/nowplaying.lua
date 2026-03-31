local sbar = require("sketchybar")
local config_dir = os.getenv("HOME") .. "/.config/sketchybar"
local script = config_dir .. "/plugins/nowplaying.sh"

local nowplaying = sbar.add("item", "nowplaying", {
  position    = "left",
  update_freq = 3,
  drawing     = "off",
  icon        = { drawing = "off" },
  background  = {
    image = {
      string      = config_dir .. "/icons/deezer.png",
      drawing     = "on",
      scale       = 0.8,
      padding_left = 4,
    },
    color = 0x00000000,
  },
  label = {
    padding_left  = 28,
    padding_right = 8,
    max_chars     = 40,
  },
})

nowplaying:subscribe("routine", function()
  sbar.exec("NAME=nowplaying " .. script)
end)

nowplaying:subscribe("mouse.clicked", function()
  sbar.exec("media-control toggle-play-pause")
end)

sbar.exec("NAME=nowplaying " .. script)
