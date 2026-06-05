function marks --description "List all bookmarks"
    set -l found 0
    for var in (set -n | string match '_bookmark_*')
        set -l name (string replace '_bookmark_' '' -- $var)
        set -l target $$var
        echo "$name  →  $target"
        set found 1
    end
    if test $found -eq 0
        echo "No bookmarks set."
    end
end
