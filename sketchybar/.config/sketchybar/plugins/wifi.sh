#!/bin/sh

source "$HOME/.config/icons.sh"

STATE=$(networksetup -getairportpower en0)

if [[ $STATE == "Wi-Fi Power (en0): On" ]]; then
  ICON=$ICON_WIFI
  LABEL="Connected"
else
  ICON=$ICON_WIFI_OFF
  LABEL="Off"
fi

sketchybar --set $NAME icon=$ICON label="$LABEL"
