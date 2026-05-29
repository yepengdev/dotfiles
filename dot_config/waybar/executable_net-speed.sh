#!/usr/bin/env bash

set -euo pipefail

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-net-speed"
mkdir -p "$CACHE_DIR"

interface=$(ip route show default 2>/dev/null | awk 'NR==1 {print $5}')

if [[ -z "${interface:-}" ]] || [[ ! -d "/sys/class/net/$interface" ]]; then
    echo "{\"text\": \" 断开\", \"class\": \"disconnected\"}"
    exit 0
fi

rx_path="/sys/class/net/$interface/statistics/rx_bytes"
tx_path="/sys/class/net/$interface/statistics/tx_bytes"
cache_file="$CACHE_DIR/$interface"

read -r rx_now < "$rx_path"
read -r tx_now < "$tx_path"
now=$(date +%s.%N)

if [[ -f "$cache_file" ]]; then
    read -r last_rx last_tx last_time < "$cache_file"
    
    # Calculate difference
    dt=$(awk "BEGIN {print $now - $last_time}")
    if (( $(awk "BEGIN {print ($dt > 0)}") )); then
        rx_diff=$(awk "BEGIN {print ($rx_now - $last_rx) / $dt}")
        tx_diff=$(awk "BEGIN {print ($tx_now - $last_tx) / $dt}")
    else
        rx_diff=0
        tx_diff=0
    fi
else
    rx_diff=0
    tx_diff=0
fi

# Save current state
echo "$rx_now $tx_now $now" > "$cache_file"

human() {
    local bytes=$1
    if (( $(awk "BEGIN {print ($bytes >= 1024 * 1024)}") )); then
        printf "%.1fM" "$(awk \"BEGIN {print $bytes/1024/1024}\")"
    elif (( $(awk "BEGIN {print ($bytes >= 1024)}") )); then
        printf "%.0fK" "$(awk \"BEGIN {print $bytes/1024}\")"
    else
        printf "%.0fB" "$bytes"
    fi
}

rx_human=$(human "$rx_diff")
tx_human=$(human "$tx_diff")

echo " ${rx_human}/s  ${tx_human}/s"