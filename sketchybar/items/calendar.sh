sketchybar --add item calendar right                                \
           --set calendar icon="󰃰"                                  \
                          update_freq=60                             \
                          updates=on                                 \
                          script="$PLUGIN_DIR/calendar.sh"           \
                          icon.padding_left=8                        \
                          icon.padding_right=4                       \
                          label.padding_left=0                       \
                          label.padding_right=8                      \
                          label.font="$NERD_FONT:Mono:14.0"         \
           --subscribe calendar mouse.clicked
