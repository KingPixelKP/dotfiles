#!/usr/bin/env bash
# Cycle wallpaper mode: carousel -> static image -> black -> carousel.

STATIC_WALLPAPER="$HOME/Pictures/Wallpaper/LeBichonBichonWater.jpeg"
BLACK_WALLPAPER="$HOME/.config/hypr/black.png"
CAROUSEL="$HOME/.config/hypr/scripts/wallpaper-carousel.sh"

# Anchored so only the carousel process itself matches, not shells mentioning it.
PATTERN="^[^ ]*bash $CAROUSEL\$"

set_wallpaper() {
  for MONITOR in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$MONITOR,$1,cover"
  done
}

if pgrep -f "$PATTERN" >/dev/null; then
  pkill -f "$PATTERN"
  set_wallpaper "$STATIC_WALLPAPER"
  notify-send -t 1500 "Wallpaper" "Static image" 2>/dev/null
elif hyprctl hyprpaper listactive | grep -qF "$BLACK_WALLPAPER"; then
  setsid -f "$CAROUSEL" >/dev/null 2>&1
  notify-send -t 1500 "Wallpaper" "Carousel" 2>/dev/null
else
  set_wallpaper "$BLACK_WALLPAPER"
  notify-send -t 1500 "Wallpaper" "Black" 2>/dev/null
fi
