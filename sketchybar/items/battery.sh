sketchybar --add item battery right                          \
           --set battery icon.font="$NERD_FONT:Regular:18.0" \
                         icon.y_offset=8                     \
                         icon.padding_left=15                \
                         icon.padding_right=-17              \
                         label.font="$NERD_FONT:Mono:12.0"  \
                         label.padding_left=0                \
                         y_offset=-4                         \
                         width=40                            \
                         update_freq=120                     \
                         popup.align=center                  \
                         script="$PLUGIN_DIR/battery.sh"     \
           --subscribe battery system_woke power_source_change \
                              mouse.clicked                  \
                                                             \
           --add item battery.details popup.battery          \
           --set battery.details icon.drawing=off            \
                         label.font="$NERD_FONT:Mono:12.0"  \
                         label="Loading..."
