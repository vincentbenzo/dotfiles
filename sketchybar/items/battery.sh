sketchybar --add item battery right                          \
           --set battery icon.font="$FONT:Regular:14.0"      \
                         icon.y_offset=13                    \
                         icon.padding_left=10                \
                         icon.padding_right=-22              \
                         label.font="$NERD_FONT:Mono:12.0"  \
                         label.padding_left=0                \
                         y_offset=-4                         \
                         width=40                            \
                         update_freq=120                     \
                         background.padding_left=12          \
                         background.padding_right=12         \
                         popup.align=right                   \
                         script="$PLUGIN_DIR/battery.sh"     \
           --subscribe battery system_woke power_source_change \
                              mouse.clicked                  \
                                                             \
           --add item battery.details popup.battery          \
           --set battery.details icon.drawing=off            \
                         label.font="$NERD_FONT:Mono:12.0"  \
                         label="Loading..."
