#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -eo pcpu,user)
CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")

CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"

# Shift single-digit values right to keep them centered
if [ "$CPU_PERCENT" -lt 10 ] 2>/dev/null; then
  PADDING=4
else
  PADDING=0
fi

COLOR=$WHITE
case "$CPU_PERCENT" in
  [1-2][0-9]) COLOR=$YELLOW ;;
  [3-6][0-9]) COLOR=$ORANGE ;;
  [7-9][0-9]|100) COLOR=$RED ;;
esac

sketchybar --set cpu.percent label="${CPU_PERCENT}%" \
                             label.color=$COLOR \
                             label.padding_left=$PADDING
