#!/usr/bin/env bash
cpu=$(top -l 1 | grep "CPU usage" | awk '{print $3}')
osascript -e "display notification \"CPU: $cpu\" with title \"System Stats\""
