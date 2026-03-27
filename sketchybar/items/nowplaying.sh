sketchybar --add item nowplaying right                                  \
           --set nowplaying script="$PLUGIN_DIR/nowplaying.sh"          \
                            update_freq=3                               \
                            icon.color=$MAGENTA                         \
                            label.max_chars=40                          \
                            scroll_texts=on                             \
                            click_script="media-control toggle-play-pause"
