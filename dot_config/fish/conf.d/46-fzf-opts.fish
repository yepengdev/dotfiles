if status is-interactive
    # ─── bat 主题 ───
    set -gx BAT_THEME "Catppuccin Mocha"

    # ─── 搜索源 ───
    set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"

    # ─── 预览窗口 ───
    set -gx FZF_CTRL_T_OPTS "\
        --preview 'bat --color=always -n --line-range :500 {}' \
        --preview-window 'right:60%:border-left' \
        --bind 'ctrl-/:change-preview-window(down|hidden|)'"

    set -gx FZF_ALT_C_OPTS "\
        --preview 'eza --color=always --icons --tree --level=2 {}' \
        --preview-window 'right:60%:border-left'"

    set -gx FZF_CTRL_R_OPTS "\
        --preview 'echo {}' \
        --preview-window 'down:3:hidden:wrap' \
        --bind 'ctrl-/:toggle-preview'"

    # ─── Catppuccin Mocha 配色 ───
    set -gx FZF_DEFAULT_OPTS "\
        --layout=reverse \
        --border sharp \
        --info inline-right \
        --prompt '❯ ' \
        --pointer '▸ ' \
        --marker '▌' \
        --scrollbar '▐' \
        --color='bg:#1e1e2e,bg+:#313244' \
        --color='fg:#cdd6f4,fg+:#cdd6f4' \
        --color='hl:#f38ba8,hl+:#f38ba8' \
        --color='gutter:#1e1e2e' \
        --color='query:#cdd6f4' \
        --color='info:#cba6f7' \
        --color='border:#89b4fa' \
        --color='prompt:#a6e3a1' \
        --color='pointer:#a6e3a1' \
        --color='marker:#89b4fa' \
        --color='spinner:#a6e3a1' \
        --color='header:#6c7086'"

    # tmux 内用 popup（自带高度），tmux 外用 --height
    if not set -q TMUX
        set -gx FZF_DEFAULT_OPTS "--height 60% $FZF_DEFAULT_OPTS"
    end
end
