#!/bin/bash

COLOR="#b4befe"       # Lavender
COLOR_TEXT="#a6adc8"  # subtext0

# Handle Clicks
case $BLOCK_BUTTON in
    3) # Right Click: Send top CPU resource hogs
       notify-send "🖥️ CPU Hogs" "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head -n 8)" 
       ;;
    2) # Middle Click: Send top RAM resource hogs
       notify-send "🧠 RAM Hogs" "$(ps axch -o cmd:15,%mem --sort=-%mem | head -n 8)" 
       ;;
esac

#cpu
cpu_usage=$(mpstat 1 1 | awk '/Average:/ {print int(100 - $NF)"%"}')

#ram
ram_stats=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')

echo -e "<span color='$COLOR'>💻</span> <span color='$COLOR_TEXT'>$cpu_usage</span>  <span color='$COLOR'>🧠</span> <span color='$COLOR_TEXT'>$ram_stats</span>"