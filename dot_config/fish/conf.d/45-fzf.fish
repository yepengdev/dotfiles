if status is-interactive
    # ─── fzf 默认快捷键 (Ctrl+T / Ctrl+R / Alt+C) ───
    fzf --fish | source

    # ─── tmux popup：--tmux 比 fzf-tmux 脚本更现代，原生支持 ───
    if set -q TMUX
        function __fzfcmd --description "Use tmux popup inside tmux"
            echo "fzf --tmux center,60% -- "
        end
    end
end
