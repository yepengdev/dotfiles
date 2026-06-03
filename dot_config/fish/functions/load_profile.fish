function load_profile --description "按需载入 /etc/profile（仅一次），不依赖 bass+Python"
    if set -q __profile_loaded
        return
    end
    set -g __profile_loaded 1

    bash -c '
        source /etc/profile 2>/dev/null
        for var in PATH MANPATH INFODIR ROOTPATH CONFIG_PROTECT CONFIG_PROTECT_MASK; do
            eval "val=\$$var"
            [ -n "$val" ] && echo "$var=$val"
        done
    ' | while read -l line
        set -l parts (string split -m 1 = -- $line)
        if set -q parts[2]
            set -gx $parts[1] (string split : -- $parts[2])
        end
    end
end
