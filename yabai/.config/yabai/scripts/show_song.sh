#!/usr/bin/env bash
song=$(osascript -e 'tell application "Spotify" to if player state is playing then return artist of current track & " – " & name of current track' 2>/dev/null)
if [ -z "$song" ]; then
  song="Nothing playing"
fi
osascript -e "display notification \"$song\" with title \"Now Playing\""
