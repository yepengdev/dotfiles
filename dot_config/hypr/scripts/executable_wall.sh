#!/usr/bin/env bash

# 创建数组
wallpapers=(~/Pictures/wallpapers/*)

# 打乱数组顺序
shuffled_wallpapers=($(printf '%s\n' "${wallpapers[@]}" | shuf))

while :; do
    for file in "${shuffled_wallpapers[@]}"; do
        if [[ -f "$file" ]]; then  # 确保是文件而不是目录
            swww img "$file" --transition-type grow --transition-step 255 --transition-fps 60 --transition-pos top-right
            sleep 30m
        fi
    done
done
