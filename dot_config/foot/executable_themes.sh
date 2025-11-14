#!/usr/bin/env sh

# Tokyo Night Storm (默认)
tokyo_night_storm() {
    footclient --override colors.background=1a1b26 \
               --override colors.foreground=c0caf5 \
               --override colors.regular0=16161e \
               --override colors.regular1=f7768e \
               --override colors.regular2=9ece6a \
               --override colors.regular3=e0af68 \
               --override colors.regular4=7aa2f7 \
               --override colors.regular5=bb9af7 \
               --override colors.regular6=7dcfff \
               --override colors.regular7=a9b1d6
}

# Gruvbox Dark
gruvbox_dark() {
    footclient --override colors.background=282828 \
               --override colors.foreground=ebdbb2 \
               --override colors.regular0=282828 \
               --override colors.regular1=cc241d \
               --override colors.regular2=98971a \
               --override colors.regular3=d79921 \
               --override colors.regular4=458588 \
               --override colors.regular5=b16286 \
               --override colors.regular6=689d6a \
               --override colors.regular7=a89984
}

# Catppuccin Mocha
catppuccin_mocha() {
    footclient --override colors.background=1e1e2e \
               --override colors.foreground=cdd6f4 \
               --override colors.regular0=45475a \
               --override colors.regular1=f38ba8 \
               --override colors.regular2=a6e3a1 \
               --override colors.regular3=f9e2af \
               --override colors.regular4=89b4fa \
               --override colors.regular5=cba6f7 \
               --override colors.regular6=94e2d5 \
               --override colors.regular7=bac2de
}

case "$1" in
    "tokyo") tokyo_night_storm ;;
    "gruvbox") gruvbox_dark ;;
    "catppuccin") catppuccin_mocha ;;
    *) tokyo_night_storm ;;
esac
