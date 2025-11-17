#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"

sid="$1"

# Get current focused workspace
current_ws=$(hyprspace list-workspaces --focused 2>/dev/null | head -n 1)

# Collect workspaces that have windows
# hyprspace list-windows output: "<workspace> ..."; we take the first field
nonempty_ws=$(hyprspace list-windows 2>/dev/null | awk '{print $1}' | sort -u)

is_nonempty=false
for ws in $nonempty_ws; do
    if [ "$ws" = "$sid" ]; then
        is_nonempty=true
        break
    fi
done

# Icon rules:
# - Active workspace: special icon (󱓻 – matches your Waybar config)
# - Inactive: show the workspace number
icon="$sid"
if [ "$sid" = "$current_ws" ]; then
    icon="󱓻"
fi

# Color rules:
# - Workspaces with windows: full white
# - Empty workspaces: dimmer white (alpha)
inactive_color=0x88ffffff # ~53% alpha
active_color=$WHITE

icon_color=$inactive_color
if [ "$is_nonempty" = true ]; then
    icon_color=$active_color
fi

# Background rules:
# - Active workspace: pill with dynamic ITEM_BG_COLOR
# - Inactive: no background
if [ "$sid" = "$current_ws" ]; then
    sketchybar --set "$NAME" \
        icon="$icon" \
        icon.color=$icon_color \
        background.drawing=on \
        background.color=$ITEM_BG_COLOR
else
    sketchybar --set "$NAME" \
        icon="$icon" \
        icon.color=$icon_color \
        background.drawing=off
fi
