function unmark --description "Remove a bookmark"
    if test (count $argv) -eq 0
        echo "Usage: unmark <name>" >&2
        return 1
    end
    set -l varname "_bookmark_$argv[1]"
    if set -q $varname
        set -e $varname
        echo "removed bookmark '$argv[1]'"
    else
        echo "Bookmark '$argv[1]' not found" >&2
        return 1
    end
end
