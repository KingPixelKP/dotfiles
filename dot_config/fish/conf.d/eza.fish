# Replace ls with eza when installed.
if command -q eza
    alias ls='eza -al --color=auto --group-directories-first --icons=always'
    alias la='eza -a --color=auto --group-directories-first --icons=always'
    alias ll='eza -l --color=auto --group-directories-first --icons=always'
    alias lt='eza -aT --color=auto --group-directories-first --icons=always'
    alias 'l.'="eza -a | grep -E '^\\.'"
end