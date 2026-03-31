local sbar = require("sketchybar")

sbar.begin_config()

sbar.bar({
  height        = 30,
  blur_radius   = 100,
  position      = "top",
  padding_left  = 10,
  padding_right = 10,
  color         = 0xff000000,
  shadow        = "on",
})

local colors = require("colors")

sbar.default({
  updates = "when_shown",
  drawing = "on",
  icon = {
    font          = "JetBrainsMono Nerd Font:Regular:14.0",
    color         = colors.white,
    padding_left  = 4,
    padding_right = 4,
  },
  label = {
    font          = "JetBrainsMono Nerd Font:Mono:14.0",
    color         = colors.white,
    padding_left  = 4,
    padding_right = 4,
  },
})

require("items")

sbar.end_config()

sbar.event_loop()
