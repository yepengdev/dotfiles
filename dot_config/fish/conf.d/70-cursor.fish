if status is-interactive
    set -U fish_cursor line
    echo -ne '\e[6 q'

    function __reset_cursor_beam --on-event fish_postexec
        echo -ne '\e[6 q'
    end

    function __reset_cursor_before_exec --on-event fish_preexec
        echo -ne '\e[6 q'
    end
end
