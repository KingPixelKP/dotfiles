# Replace ls with eza when installed.
if command -q eza
    alias ls='eza -al --color=auto --group-directories-first'
    alias la='eza -a --color=auto --group-directories-first'
    alias ll='eza -l --color=auto --group-directories-first'
    alias lt='eza -aT --color=auto --group-directories-first'
    alias 'l.'="eza -a | grep -E '^\\.'"
end