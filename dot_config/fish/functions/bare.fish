function bare --description "打开新终端窗口，跳过 tmux 自动进入"
    for term in $TERMINAL foot kitty alacritty gnome-terminal xterm
        if command -q $term
            env NOTMUX=1 $term &
            break
        end
    end
end
