source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
set -gx DOCKER_HOST unix:///var/run/docker.sock

[ -s "/home/kpgm/.jabba/jabba.fish" ]; and source "/home/kpgm/.jabba/jabba.fish"

if status is-interactive
    keychain --eval --quiet id_ed25519 | source
end
