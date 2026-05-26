#!/bin/bash

WIDTH=100

source "$HOME/.config/icons.sh"
source "$HOME/.config/colors.sh"

update_icon() {
  case $1 in
  [6-9][0-9] | 100) ICON=$VOLUME_100 ;;
  [3-5][0-9])       ICON=$VOLUME_66 ;;
  [1-2][0-9])       ICON=$VOLUME_33 ;;
  [1-9])            ICON=$VOLUME_10 ;;
  0)                ICON=$VOLUME_0 ;;
  *)                ICON=$VOLUME_100 ;;
  esac
  sketchybar --set volume_icon icon=$ICON
}

case "$SENDER" in
"volume_change")
  update_icon $INFO
  sketchybar --set $NAME slider.percentage=$INFO \
    --animate tanh 30 --set $NAME slider.width=$WIDTH
  sleep 2
  FINAL=$(sketchybar --query $NAME | jq -r ".slider.percentage")
  if ((FINAL == INFO)); then
    sketchybar --animate tanh 30 --set $NAME slider.width=0
  fi
  ;;
"mouse.clicked")
  osascript -e "set volume output volume $INFO"
  ;;
"mouse.entered")
  CURRENT=$(osascript -e "output volume of (get volume settings)")
  update_icon $CURRENT
  sketchybar --set $NAME slider.percentage=$CURRENT \
    --animate tanh 30 --set $NAME slider.width=$WIDTH
  ;;
"mouse.exited" | "mouse.exited.global")
  sketchybar --animate tanh 30 --set $NAME slider.width=0
  ;;
esac
