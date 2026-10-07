#!/bin/bash

COLOR_NET="#b4befe"   # Lavender
COLOR_TEXT="#a6adc8"  # subtext0

interface=$(ip route | awk '/default/ {print $5; exit}')

if [ -n "$interface" ]; then
    read -r rx1 tx1 <<< "$(awk -v iface="$interface" '$1 ~ iface {print $2, $10}' /proc/net/dev)"
    
    sleep 1
    
    read -r rx2 tx2 <<< "$(awk -v iface="$interface" '$1 ~ iface {print $2, $10}' /proc/net/dev)"
    
    rx_bytes=$((rx2 - rx1))
    tx_bytes=$((tx2 - tx1))
    
    # Format
    if [ "$rx_bytes" -gt 1048576 ]; then
        rx_speed=$(awk -v bytes="$rx_bytes" 'BEGIN {printf "%.1f MB/s", bytes/1048576}')
    else
        rx_speed=$(awk -v bytes="$rx_bytes" 'BEGIN {printf "%d KB/s", bytes/1024}')
    fi
    
    # Format
    if [ "$tx_bytes" -gt 1048576 ]; then
        tx_speed=$(awk -v bytes="$tx_bytes" 'BEGIN {printf "%.1f MB/s", bytes/1048576}')
    else
        tx_speed=$(awk -v bytes="$tx_bytes" 'BEGIN {printf "%d KB/s", bytes/1024}')
    fi
    
    net_stats="⬇ $rx_speed ⬆ $tx_speed"
else
    net_stats="Offline"
fi

echo -e "<span color='$COLOR_NET'>🌐</span> <span color='$COLOR_TEXT'>$net_stats</span>"
