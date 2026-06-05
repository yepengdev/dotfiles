if status is-interactive
    function cd --description "Change directory and list contents"
        builtin cd $argv
        and command -q eza
        and eza --color=always --group-directories-first --icons 2>/dev/null
    end
end
