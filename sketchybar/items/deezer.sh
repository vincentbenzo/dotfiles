sketchybar --add item deezer right                              \
           --set deezer script="$PLUGIN_DIR/deezer.sh"          \
                         update_freq=3                          \
                         icon.color=$MAGENTA                    \
                         label.max_chars=40                     \
                         scroll_texts=on                        \
                         click_script="osascript -e 'tell application \"Deezer\" to playpause'"
