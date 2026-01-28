#!/bin/sh

source "$HOME/.config/icons.sh"

HOST_NAME=$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2}')
STATE=$(networksetup -getairportpower en0)

if [[ $STATE == "Wi-Fi Power (en0): On" ]]; then
  ICON=$ICON_WIFI
  if [[ $HOST_NAME == "" ]]; then
    LABEL="---"
  else
    LABEL=$HOST_NAME
  fi
else
  ICON=$ICON_WIFI_OFF
  LABEL="off"
fi

sketchybar --set $NAME \
  icon=$ICON \
  label="$LABEL" \