sketchybar --add item wifi right                      \
           --set wifi icon=$WIFI_ICN                   \
                      icon.font="JetBrainsMono Nerd Font:Regular:18.0" \
                      icon.padding_left=6              \
                      icon.padding_right=2             \
                      label.drawing=off                \
                      script="$PLUGIN_DIR/wifi.sh"     \
                      update_freq=10                   \
           --subscribe wifi mouse.entered mouse.exited
