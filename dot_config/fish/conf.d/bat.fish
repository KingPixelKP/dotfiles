# bat / batcat compatibility
if command -q bat
    alias b bat
else if command -q batcat
    alias b batcat
end

# Format man pages with bat when available.
if command -q bat || command -q batcat
    set -gx MANROFFOPT "-c"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end