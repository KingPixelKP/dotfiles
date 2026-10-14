# Personal Fish configuration shared across Linux distributions.

# Apply Fish-compatible profile settings.
if test -f "$HOME/.fish_profile"
    source "$HOME/.fish_profile"
end

# Common executable directories.
fish_add_path "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/Applications/depot_tools"

# Docker normally defaults to /var/run/docker.sock; set DOCKER_HOST only
# if you need to override that default.

# Format man pages with bat when available.
if command -q bat
    set -gx MANROFFOPT "-c"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# Replace ls with eza when installed.
if command -q eza
    alias ls='eza -al --color=auto --group-directories-first'
    alias la='eza -a --color=auto --group-directories-first'
    alias ll='eza -l --color=auto --group-directories-first'
    alias lt='eza -aT --color=auto --group-directories-first'
    alias 'l.'="eza -a | grep -E '^\\.'"
end

# Interactive command-line shortcuts.
if status is-interactive
    if test "$fish_key_bindings" = fish_vi_key_bindings
        bind -Minsert ! __history_previous_command
        bind -Minsert '$' __history_previous_command_arguments
    else
        bind ! __history_previous_command
        bind '$' __history_previous_command_arguments
    end
end

# Navigation.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Common utilities.
alias tarnow='tar -acf'
alias untar='tar -zxvf'
alias wget='wget -c'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# General system diagnostics.
alias jctl='journalctl -p 3 -xb'
alias tb='nc termbin.com 9999'

set -gx DOCKER_HOST unix:///var/run/docker.sock

source "$HOME/.config/fish/keybinds.fish"