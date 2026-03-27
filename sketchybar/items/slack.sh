sketchybar --add item slack right                           \
           --set slack icon=""                              \
                       update_freq=10                        \
                       script="$PLUGIN_DIR/slack.sh"         \
                       icon.padding_left=8                   \
                       label.padding_right=8                 \
                       click_script="open -a Slack"
