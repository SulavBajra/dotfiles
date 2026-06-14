#!/usr/bin/env bash

THRESHOLD=2
BAR_HEIGHT=40
INTERVAL=0.1
HIDDEN=false

screen_height() {
    niri msg --json outputs \
        | jq '[.[] | select(.current_mode) | .current_mode.height] | max'
}

cursor_y() {
    niri msg --json cursor-position 2>/dev/null \
        | jq -e '.y | floor' 2>/dev/null
}

SCREEN_H=$(screen_height)
WAYBAR_PID=$(pgrep -x waybar | head -1)

send_signal() {
    local current_pid
    current_pid=$(pgrep -x waybar | head -1)
    # If waybar restarted, our HIDDEN state is wrong — reset it
    if [[ "$current_pid" != "$WAYBAR_PID" ]]; then
        WAYBAR_PID=$current_pid
        HIDDEN=false   # waybar restarts visible
    fi
    pkill -SIGUSR1 waybar
}

show() { send_signal; HIDDEN=false; }
hide() { send_signal; HIDDEN=true; }

# Start hidden — wait for waybar to be ready first
sleep 1
hide

while sleep "$INTERVAL"; do
    Y=$(cursor_y) || continue
    [[ "$Y" == "null" || -z "$Y" ]] && continue

    DIST=$(( SCREEN_H - Y ))

    if (( DIST <= THRESHOLD )) && [[ $HIDDEN == true ]]; then
        show
    elif (( DIST > BAR_HEIGHT )) && [[ $HIDDEN == false ]]; then
        hide
    fi
done
