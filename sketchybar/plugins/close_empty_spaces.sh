#!/bin/bash

# Get the currently focused space
active_space=$(yabai -m query --spaces | jq -r 'map(select(."has-focus" == true)) | .[0].index')

# Check if we got a valid active space
if [ "$active_space" == "null" ] || [ -z "$active_space" ]; then
  echo "Error: Could not retrieve active space."
  exit 1
fi

while true; do
  changes_made=false

  # Get updated list of spaces
  spaces=$(yabai -m query --spaces)

  for space in $(echo "$spaces" | jq -r '.[].index'); do
    # Skip active space
    if [ "$space" -eq "$active_space" ]; then
      continue
    fi

    # Check if space has any windows
    windows=$(yabai -m query --windows --space "$space" | jq 'length')

    if [ "$windows" -eq 0 ]; then
      yabai -m space --destroy "$space"
      changes_made=true
      break  # Break to re-query the space list (since indexes changed)
    fi
  done

  # If no more empty spaces were found, break the loop
  if [ "$changes_made" = false ]; then
    break
  fi
done
