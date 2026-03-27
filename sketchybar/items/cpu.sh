sketchybar --add item        cpu.label right                 \
           --set cpu.label   label="CPU"                     \
                             label.font="$NERD_FONT:Mono:8.0" \
                             label.color=$GREY               \
                             icon.drawing=off                \
                             width=0                         \
                             y_offset=6                      \
                                                             \
           --add item        cpu.percent right               \
           --set cpu.percent icon.drawing=off                \
                             label.font="$NERD_FONT:Mono:12.0" \
                             y_offset=-4                     \
                             width=40                        \
                             update_freq=2                   \
                             script="$PLUGIN_DIR/cpu.sh"
