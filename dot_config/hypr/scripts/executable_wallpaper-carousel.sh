#!/usr/bin/env bash

# Path to your wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Time interval between transitions (in seconds)
INTERVAL=600

# Get active monitors
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')

while true; do
  # Find a random image from the folder
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)

  if [ -n "$WALLPAPER" ]; then
    # 1. Preload the new wallpaper into memory
    hyprctl hyprpaper preload "$WALLPAPER"

    # 2. Apply it to all active monitors
    for MONITOR in $MONITORS; do
      hyprctl hyprpaper wallpaper "$MONITOR","$WALLPAPER"
    done

    # 3. Prevent RAM bloat by unloading previously cached images
    hyprctl hyprpaper unload all
  fi

  sleep $INTERVAL
done
