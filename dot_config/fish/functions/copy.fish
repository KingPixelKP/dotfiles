function copy
    if test (count $argv) -eq 2; and test -d "$argv[1]"
        set -l from (string trim -r -c / -- "$argv[1]")
        command cp -r -- "$from" "$argv[2]"
    else
        command cp $argv
    end
end
