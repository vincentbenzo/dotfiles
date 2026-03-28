sketchybar --add item nowplaying left                                   \
           --set nowplaying script="$PLUGIN_DIR/nowplaying.sh"          \
                            update_freq=3                               \
                            drawing=off                                 \
                            icon.drawing=off                             \
                            background.image="$HOME/.config/sketchybar/icons/deezer.png" \
                            background.image.drawing=on                  \
                            background.image.scale=0.8                   \
                            background.image.padding_left=4              \
                            label.padding_left=24                       \
                            label.padding_right=8                       \
                            label.max_chars=40                          \
                            background.corner_radius=5                  \
                            background.height=20                        \
                            background.color=0x66313244                 \
                            click_script="media-control toggle-play-pause"
