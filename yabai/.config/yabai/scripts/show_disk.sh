#!/usr/bin/env bash
disk=$(df -h / | awk 'NR==2 {print $3 " used / " $2 " total (" $5 ")"}')
osascript -e "display notification \"Disk: $disk\" with title \"System Stats\""
