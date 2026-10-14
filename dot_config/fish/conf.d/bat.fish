# bat / batcat compatibility
if command -q bat
    alias b bat
else if command -q batcat
    alias b batcat
end