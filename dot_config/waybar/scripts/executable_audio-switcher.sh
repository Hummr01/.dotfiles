#!/bin/bash

# Rofi configuration for a top-right popup
MENU_RUNNER="rofi -dmenu -i -location 3 -xoffset -15 -yoffset 45 -theme-str 'window {width: 350px;}' -p"
ACTION=$1

case "$ACTION" in
output)
  DEVICES=$(pactl list sinks | awk '/Sink #/{id=$2} /Description:/{$1=""; print id " -" $0}')
  PROMPT="Output:"
  ;;
input)
  DEVICES=$(pactl list sources | awk '/Source #/{id=$2} /Description:/{$1=""; print id " -" $0}' | grep -vi 'monitor')
  PROMPT="Input:"
  ;;
*)
  echo "Usage: $0 {output|input}"
  exit 1
  ;;
esac

# Display the menu and store the selection
SELECTED=$(echo "$DEVICES" | sed 's/^ *//' | eval $MENU_RUNNER '"$PROMPT"')

# Exit if the user presses Escape or clicks away
[ -z "$SELECTED" ] && exit 0

# Extract the device ID from the selection (e.g., #45 -> 45)
DEVICE_ID=$(echo "$SELECTED" | awk '{print $1}' | tr -d '#')

# Apply the new default device and move active audio streams to it
if [ "$ACTION" == "output" ]; then
  pactl set-default-sink "$DEVICE_ID"

  # Move currently playing apps to the new output device instantly
  for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$stream" "$DEVICE_ID" 2>/dev/null
  done
else
  pactl set-default-source "$DEVICE_ID"

  # Move currently recording apps to the new input device instantly
  for stream in $(pactl list short source-outputs | awk '{print $1}'); do
    pactl move-source-output "$stream" "$DEVICE_ID" 2>/dev/null
  done
fi
