#!/usr/bin/env bash
bat=$(pmset -g batt | grep -o '[0-9]*%' | head -1)
osascript -e "display notification \"Battery: $bat\" with title \"System Stats\""
