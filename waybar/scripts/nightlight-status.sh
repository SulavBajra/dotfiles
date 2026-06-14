#!/bin/bash
if pgrep -x wlsunset > /dev/null; then
    echo '{"text": "󰛨", "tooltip": "Night light on", "class": "on"}'
else
    echo '{"text": "󰖔", "tooltip": "Night light off", "class": "off"}'
fi
