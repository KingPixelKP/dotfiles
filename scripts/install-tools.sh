#!/usr/bin/env bash

# Install useful command-line tools on Arch-based or Debian-based systems.
set -Eeuo pipefail

ARCH_PACKAGES=(eza bat fzf ripgrep fd zoxide btop)
DEBIAN_PACKAGES=(eza bat fzf ripgrep fd-find zoxide btop)

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

if [[ ! -r /etc/os-release ]]; then
    fail 'Cannot identify this distribution: /etc/os-release is missing.'
fi

# shellcheck disable=SC1091
source /etc/os-release
DISTRO_ID="${ID,,}"
DISTRO_LIKE="${ID_LIKE,,}"

if (( EUID == 0 )); then
    SUDO=()
elif command -v sudo >/dev/null 2>&1; then
    SUDO=(sudo)
else
    fail 'Run as root or install sudo first.'
fi

case "$DISTRO_ID" in
    arch|cachyos|manjaro|endeavouros)
        printf 'Updating system and installing: %s\n' "${ARCH_PACKAGES[*]}"
        "${SUDO[@]}" pacman -Syu --needed -- "${ARCH_PACKAGES[@]}"
        ;;
    debian|ubuntu|linuxmint|pop)
        printf 'Updating package lists...\n'
        "${SUDO[@]}" apt-get update

        # A few packages (notably eza and zoxide on older releases) may be
        # absent from the enabled repositories. Install available packages
        # and clearly report anything that needs a separate installation.
        available=()
        missing=()
        for package in "${DEBIAN_PACKAGES[@]}"; do
            if apt-cache show "$package" >/dev/null 2>&1; then
                available+=("$package")
            else
                missing+=("$package")
            fi
        done

        ((${#available[@]} > 0)) || fail 'None of the requested packages were found in the enabled APT repositories.'
        printf 'Installing available packages: %s\n' "${available[*]}"
        "${SUDO[@]}" apt-get install -y --no-install-recommends "${available[@]}"

        if ((${#missing[@]} > 0)); then
            printf '\nWarning: these packages were not found in enabled APT repositories: %s\n' "${missing[*]}" >&2
            printf 'You may need a newer release or an additional trusted repository.\n' >&2
        fi

        if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
            printf '\nNote: this system uses `batcat` as the executable name for bat.\n'
        fi
        if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
            printf 'Note: this system uses `fdfind` as the executable name for fd-find.\n'
        fi
        ;;
    *)
        case " $DISTRO_LIKE " in
            *' arch '*)
                printf 'Detected Arch-based distribution: %s\n' "${PRETTY_NAME:-$DISTRO_ID}"
                "${SUDO[@]}" pacman -Syu --needed -- "${ARCH_PACKAGES[@]}"
                ;;
            *' debian '*|*' ubuntu '*)
                printf 'Detected Debian-based distribution: %s\n' "${PRETTY_NAME:-$DISTRO_ID}"
                "${SUDO[@]}" apt-get update
                available=()
                missing=()
                for package in "${DEBIAN_PACKAGES[@]}"; do
                    if apt-cache show "$package" >/dev/null 2>&1; then
                        available+=("$package")
                    else
                        missing+=("$package")
                    fi
                done
                ((${#available[@]} > 0)) || fail 'None of the requested packages were found in the enabled APT repositories.'
                "${SUDO[@]}" apt-get install -y --no-install-recommends "${available[@]}"
                if ((${#missing[@]} > 0)); then
                    printf 'Warning: packages not found in enabled APT repositories: %s\n' "${missing[*]}" >&2
                fi
                ;;
            *)
                fail "Unsupported distribution: ${PRETTY_NAME:-$DISTRO_ID}. Supported families: Arch and Debian/Ubuntu."
                ;;
        esac
        ;;
esac

printf '\nFinished. Check tool availability with: eza --version, bat --version, fzf --version, rg --version\n'
printf 'On Debian/Ubuntu, the executable names may be `batcat` and `fdfind`.\n'
