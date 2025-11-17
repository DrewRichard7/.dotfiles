#!/usr/bin/env bash

sid="$1"

# Log for debugging:
# (You can remove these two lines once everything works.)
current_ws=$(hyprspace list-workspaces --focused 2>/dev/null | head -n 1)
echo "hyprspace_space.sh: SENDER=$SENDER NAME=$NAME sid=$sid CURRENT_WS=$current_ws" \
    >>/tmp/hyprspace_sketchybar.log

if [ "$SENDER" = "hyprspace_workspace_change" ]; then
    # current_ws is the workspace name/id Hyprspace thinks is focused
    if [ "$sid" = "$current_ws" ]; then
        sketchybar --set "$NAME" background.drawing=on
    else
        sketchybar --set "$NAME" background.drawing=off
    fi
fi
