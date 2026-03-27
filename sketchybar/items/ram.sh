sketchybar --add item        ram.percent right               \
           --set ram.percent icon="RAM"                      \
                             icon.font="$NERD_FONT:Mono:8.0" \
                             icon.color=$GREY               \
                             icon.y_offset=10               \
                             icon.padding_left=13           \
                             icon.padding_right=-18         \
                             label.font="$NERD_FONT:Mono:12.0" \
                             label.padding_left=0           \
                             y_offset=-4                    \
                             width=40                       \
                             update_freq=2                  \
                             script="$PLUGIN_DIR/ram.sh"
