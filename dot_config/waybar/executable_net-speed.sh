#!/usr/bin/env sh

interface=$(ip route | grep default | awk '{print $5}')
rx_old=$(cat /sys/class/net/$interface/statistics/rx_bytes)
tx_old=$(cat /sys/class/net/$interface/statistics/tx_bytes)
sleep 1
rx_new=$(cat /sys/class/net/$interface/statistics/rx_bytes)
tx_new=$(cat /sys/class/net/$interface/statistics/tx_bytes)

rx_bytes=$((rx_new - rx_old))
tx_bytes=$((tx_new - tx_old))

rx_speed=$(echo "scale=1; $rx_bytes/1024" | bc)
tx_speed=$(echo "scale=1; $tx_bytes/1024" | bc)

echo " ${rx_speed}K  ${tx_speed}K"
