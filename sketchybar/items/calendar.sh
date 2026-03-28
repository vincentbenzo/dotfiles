sketchybar --add item calendar right                                \
           --set calendar icon="󰃰"                                  \
                          update_freq=30                             \
                          script="$PLUGIN_DIR/calendar.sh"           \
                          icon.padding_left=8                        \
                          icon.padding_right=4                       \
                          label.padding_left=0                       \
                          label.padding_right=8                      \
                          label.font="$NERD_FONT:Mono:14.0"         \
                          click_script="$PLUGIN_DIR/calendar_click.sh"
