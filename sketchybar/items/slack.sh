sketchybar --add item slack right                           \
           --set slack icon="󰒱"                             \
                       update_freq=10                        \
                       script="$PLUGIN_DIR/slack.sh"         \
                       icon.padding_left=8                   \
                       icon.padding_right=0                  \
                       label.padding_left=0                  \
                       label.padding_right=8                 \
                       label.y_offset=5                      \
                       label.font="JetBrainsMono Nerd Font:Mono:10.0" \
                       click_script="open -a Slack"
