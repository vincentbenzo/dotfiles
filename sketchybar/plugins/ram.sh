#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

TOTAL_RAM=$(sysctl -n hw.memsize)
TOTAL_RAM_MB=$((TOTAL_RAM / 1024 / 1024))

PAGE_SIZE=$(sysctl -n hw.pagesize)
VM_STAT=$(vm_stat)
ACTIVE=$(echo "$VM_STAT" | awk '/Pages active/ {gsub(/\./,"",$3); print $3}')
WIRED=$(echo "$VM_STAT" | awk '/Pages wired/ {gsub(/\./,"",$4); print $4}')
COMPRESSED=$(echo "$VM_STAT" | awk '/Pages occupied by compressor/ {gsub(/\./,"",$5); print $5}')

USED_MB=$(( (ACTIVE + WIRED + COMPRESSED) * PAGE_SIZE / 1024 / 1024 ))
RAM_PERCENT=$(( USED_MB * 100 / TOTAL_RAM_MB ))

COLOR=$WHITE
case "$RAM_PERCENT" in
  [1-2][0-9]) COLOR=$YELLOW ;;
  [3-6][0-9]) COLOR=$ORANGE ;;
  [7-9][0-9]|100) COLOR=$RED ;;
esac

sketchybar --set ram.percent label="$RAM_PERCENT%" \
                             label.color=$COLOR
