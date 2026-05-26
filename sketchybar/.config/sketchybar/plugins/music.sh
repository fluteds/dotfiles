#!/bin/bash
source "$HOME/.config/colors.sh"
source "$HOME/.config/icons.sh"

# Try Spotify first via AppleScript (reliable; media_change doesn't always fire for Spotify)
SPOTIFY_STATE=$(osascript -e 'tell application "Spotify" to get player state' 2>/dev/null)

if [ "$SPOTIFY_STATE" = "playing" ]; then
  TRACK=$(osascript -e 'tell application "Spotify" to get name of current track' 2>/dev/null)
  ARTIST=$(osascript -e 'tell application "Spotify" to get artist of current track' 2>/dev/null)
  sketchybar --set $NAME drawing=on icon=$ICON_MUSIC icon.color=$COLOR_YELLOW label="$ARTIST: $TRACK"
  exit 0
fi

# Fall back to media_change $INFO for other players (Apple Music, etc.)
PLAYER_STATE="$(echo "$INFO" | jq -r '.state')"
CURRENT_ARTIST="$(echo "$INFO" | jq -r '.artist')"
CURRENT_SONG="$(echo "$INFO" | jq -r '.title')"

if [ "$PLAYER_STATE" = "playing" ]; then
  sketchybar --set $NAME drawing=on icon=$ICON_MUSIC icon.color=$COLOR_YELLOW label="$CURRENT_ARTIST: $CURRENT_SONG"
else
  sketchybar --set $NAME drawing=off
fi
