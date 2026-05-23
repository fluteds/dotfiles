#!/bin/bash
source "$HOME/.config/colors.sh"

CORES=$(sysctl -n hw.logicalcpu)
CPU=$(ps -A -o %cpu | awk -v c="$CORES" '{s+=$1} END {printf "%.0f", s/c}')

if [ -n "$CPU" ]; then
  if [ "${CPU%.*}" -ge 80 ]; then
    COLOR=$COLOR_RED
  elif [ "${CPU%.*}" -ge 40 ]; then
    COLOR=$COLOR_YELLOW
  else
    COLOR=$COLOR_WHITE_BRIGHT
  fi
  sketchybar --set $NAME label="${CPU}%" icon.color=$COLOR
fi
