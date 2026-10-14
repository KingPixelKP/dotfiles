# CachyOS-only Fish configuration.
# This file is safe to deploy to other Linux machines.

if not test -f /etc/cachyos-release
    return
end

# Welcome message.
if command -q fastfetch
    function fish_greeting
        fastfetch
    end
end

# CachyOS "done" command-completion notifications.
if test -f /usr/share/cachyos-fish-config/conf.d/done.fish
    source /usr/share/cachyos-fish-config/conf.d/done.fish
    set -U __done_min_cmd_duration 10000
    set -U __done_notification_urgency_level low
end

# Arch/CachyOS package management.
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias grubup='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias hw='hwinfo --short'
alias big="expac -H M '%m\\t%n' | sort -h | nl"
alias gitpkg='pacman -Q | grep -i "\\-git" | wc -l'
alias update='sudo cachyos-rate-mirrors && sudo pacman -Syu'
alias mirror='sudo cachyos-rate-mirrors'
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\\t%n %v' | sort | tail -200 | nl"

# Intentionally do not override apt/apt-get on Debian/Ubuntu.

# SSH 
if status is-interactive
    keychain --eval --quiet id_ed25519 | source
end