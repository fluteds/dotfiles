#!/usr/bin/env bash
cores=$(sysctl -n hw.logicalcpu)
cpu=$(ps -A -o %cpu | awk -v c="$cores" '{s+=$1} END {printf "%.0f%%", s/c}')
osascript -e "display notification \"CPU: $cpu\" with title \"System Stats\""
