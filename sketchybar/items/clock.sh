sketchybar --add item clock right                              \
           --set clock update_freq=1                            \
                       label.font="$NERD_FONT:Mono:14.0"       \
                       width=155                                \
                       background.padding_left=6                 \
                       background.padding_right=6                \
                       script="$PLUGIN_DIR/clock.sh"
