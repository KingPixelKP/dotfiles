#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpaper"
INTERVAL=600

while true; do
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) |
    shuf -n 1)

  if [[ -n "$WALLPAPER" ]]; then
    echo "Applying wallpaper: $WALLPAPER"

    MONITORS=$(hyprctl monitors -j | jq -r '.[].name')

    for MONITOR in $MONITORS; do
      hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER,cover"
    done
  fi

  sleep "$INTERVAL"
done
