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
               --override colors.cursor="11111b f5e0dc" \
               --override colors.regular0=45475a \
               --override colors.regular1=f38ba8 \
               --override colors.regular2=a6e3a1 \
               --override colors.regular3=f9e2af \
               --override colors.regular4=89b4fa \
               --override colors.regular5=f5c2e7 \
               --override colors.regular6=94e2d5 \
               --override colors.regular7=bac2de \
               --override colors.bright0=585b70 \
               --override colors.bright1=f38ba8 \
               --override colors.bright2=a6e3a1 \
               --override colors.bright3=f9e2af \
               --override colors.bright4=89b4fa \
               --override colors.bright5=f5c2e7 \
               --override colors.bright6=94e2d5 \
               --override colors.bright7=a6adc8 \
               --override colors.selection-background=414356 \
               --override colors.selection-foreground=cdd6f4 \
               --override colors.urls=89b4fa
}

# Everforest Dark
everforest_dark() {
    footclient --override colors.background=2b3339 \
               --override colors.foreground=d3c6aa \
               --override colors.cursor=d3c6aa \
               --override colors.regular0=475258 \
               --override colors.regular1=e67e80 \
               --override colors.regular2=a7c080 \
               --override colors.regular3=dbbc7f \
               --override colors.regular4=7fbbb3 \
               --override colors.regular5=d699b6 \
               --override colors.regular6=83c092 \
               --override colors.regular7=d3c6aa \
               --override colors.bright0=5a6a73 \
               --override colors.bright1=e67e80 \
               --override colors.bright2=a7c080 \
               --override colors.bright3=dbbc7f \
               --override colors.bright4=7fbbb3 \
               --override colors.bright5=d699b6 \
               --override colors.bright6=83c092 \
               --override colors.bright7=e6e0cc \
               --override colors.selection-background=3d484f \
               --override colors.selection-foreground=d3c6aa \
               --override colors.urls=7fbbb3
}

# Rose Pine
rose_pine() {
    footclient --override colors.background=191724 \
               --override colors.foreground=e0def4 \
               --override colors.regular0=26233a \
               --override colors.regular1=eb6f92 \
               --override colors.regular2=31748f \
               --override colors.regular3=f6c177 \
               --override colors.regular4=9ccfd8 \
               --override colors.regular5=c4a7e7 \
               --override colors.regular6=ebbcba \
               --override colors.regular7=e0def4 \
               --override colors.bright0=6e6a86 \
               --override colors.bright1=eb6f92 \
               --override colors.bright2=31748f \
               --override colors.bright3=f6c177 \
               --override colors.bright4=9ccfd8 \
               --override colors.bright5=c4a7e7 \
               --override colors.bright6=ebbcba \
               --override colors.bright7=e0def4 \
               --override colors.selection-background=403d52 \
               --override colors.selection-foreground=e0def4 \
               --override colors.urls=9ccfd8
}

# Kanagawa
kanagawa() {
    footclient --override colors.background=1f1f28 \
               --override colors.foreground=dcd7ba \
               --override colors.cursor="2a2a37 c8c093" \
               --override colors.regular0=1f1f28 \
               --override colors.regular1=c34043 \
               --override colors.regular2=76946a \
               --override colors.regular3=c0a36e \
               --override colors.regular4=7e9cd8 \
               --override colors.regular5=957fb8 \
               --override colors.regular6=6a9589 \
               --override colors.regular7=c8c093 \
               --override colors.bright0=2a2a37 \
               --override colors.bright1=e46876 \
               --override colors.bright2=98bb6c \
               --override colors.bright3=dca561 \
               --override colors.bright4=7fb4ca \
               --override colors.bright5=938aa9 \
               --override colors.bright6=7ac1b8 \
               --override colors.bright7=dcd7ba \
               --override colors.selection-background=363646 \
               --override colors.selection-foreground=dcd7ba \
               --override colors.urls=7fb4ca
}

# Ayu Dark
ayu_dark() {
    footclient --override colors.background=0a0e14 \
               --override colors.foreground=b3b1ad \
               --override colors.cursor="0a0e14 fbb254" \
               --override colors.regular0=0a0e14 \
               --override colors.regular1=f07178 \
               --override colors.regular2=aad8b0 \
               --override colors.regular3=fbb254 \
               --override colors.regular4=53bdfa \
               --override colors.regular5=d2a6ff \
               --override colors.regular6=95e6cb \
               --override colors.regular7=c7c7c7 \
               --override colors.bright0=101521 \
               --override colors.bright1=f07178 \
               --override colors.bright2=aad8b0 \
               --override colors.bright3=fbb254 \
               --override colors.bright4=53bdfa \
               --override colors.bright5=d2a6ff \
               --override colors.bright6=95e6cb \
               --override colors.bright7=e6e1cf \
               --override colors.selection-background=253340 \
               --override colors.selection-foreground=b3b1ad \
               --override colors.urls=53bdfa
}

case "$1" in
    "tokyo") tokyo_night_storm ;;
    "gruvbox") gruvbox_dark ;;
    "catppuccin") catppuccin_mocha ;;
    "everforest") everforest_dark ;;
    "rosepine") rose_pine ;;
    "kanagawa") kanagawa ;;
    "ayu") ayu_dark ;;
    *) tokyo_night_storm ;;
esac
