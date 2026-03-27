sketchybar --add item        ram.label right                 \
           --set ram.label   label="RAM"                     \
                             label.font="$NERD_FONT:Mono:8.0" \
                             label.color=$GREY               \
                             label.align=center              \
                             icon.drawing=off                \
                             width=40                        \
                             padding_left=-40                \
                             y_offset=6                      \
                                                             \
           --add item        ram.percent right               \
           --set ram.percent icon.drawing=off                \
                             label.font="$NERD_FONT:Mono:12.0" \
                             label.align=center              \
                             y_offset=-4                     \
                             width=40                        \
                             update_freq=2                   \
                             script="$PLUGIN_DIR/ram.sh"
