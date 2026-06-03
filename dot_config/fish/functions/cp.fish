function cp
    if test (count $argv) -eq 2; and test -d "$argv[1]"
        set -l from (string trim-right --chars=/ "$argv[1]")
        command cp -i $from $argv[2]
    else
        command cp -i $argv
    end
end
