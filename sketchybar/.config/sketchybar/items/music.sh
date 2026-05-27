#!/usr/bin/env bash
PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

music=(
  "${bracket_defaults[@]}"
  script="$PLUGIN_DIR/music.sh"
  popup.align=center
  padding_left=4
  label.padding_right=10
  label.padding_left=10
  label.color=$COLOR_YELLOW
  padding_right=4
  drawing=off
  label="Loading…"
  background.corner_radius=16
  background.color=$COLOR_BL2
  label.max_chars=50
  label.scroll_duration=600
  click_script="sketchybar --set music drawing=off"
  update_freq=5
  updates=on
  --subscribe music media_change
)

sketchybar \
  --add item music center \
  --set music "${music[@]}"
