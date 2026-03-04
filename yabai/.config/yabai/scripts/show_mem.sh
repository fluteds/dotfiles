#!/usr/bin/env bash
used=$(vm_stat | awk '/Pages active/ {active=$3} /Pages wired down/ {wired=$4} END {printf "%.1f GB", (active+wired)*4096/1073741824}')
osascript -e "display notification \"Memory used: $used\" with title \"System Stats\""
