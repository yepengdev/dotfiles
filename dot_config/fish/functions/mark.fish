function mark --description "Save current directory as a bookmark"
    set -l name $argv[1]
    if test -z "$name"
        set name (basename $PWD)
    end
    set -U _bookmark_$name $PWD
    echo "marked $name → $PWD"
end
