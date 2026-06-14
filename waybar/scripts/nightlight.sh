#!/bin/bash
if pgrep -x wlsunset > /dev/null; then
    pkill -x wlsunset
    echo '{"text": "󰖔", "tooltip": "Night light off", "class": "off"}'
else
    setsid wlsunset -T 4500 -t 3000 > /dev/null 2>&1 &
    disown
    echo '{"text": "󰛨", "tooltip": "Night light on", "class": "on"}'
fi
