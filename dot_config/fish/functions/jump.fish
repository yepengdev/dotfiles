function jump --description "Jump to a saved bookmark"
    if test (count $argv) -eq 0
        echo "Usage: jump <name>" >&2
        return 1
    end
    set -l varname "_bookmark_$argv[1]"
    if set -q $varname
        eval "builtin cd \$$varname"
    else
        echo "Bookmark '$argv[1]' not found" >&2
        return 1
    end
end
