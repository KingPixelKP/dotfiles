# Dotfiles

Personal configuration managed with [chezmoi](https://www.chezmoi.io/).

## Supported systems

- **CachyOS / Arch Linux**
- **Ubuntu Server**

## Installing Fish

### Debian

```sh
sudo apt update
sudo apt install fish
```

### Arch

```sh
sudo pacman -S fish
```

## Setting Fish as the default shell

First, check where Fish is installed:

```sh
command -v fish
```

Add its path to `/etc/shells` if it is not already listed. The following example assumes Fish is installed at `/usr/bin/fish`:

```sh
grep -qxF /usr/bin/fish /etc/shells || echo /usr/bin/fish | sudo tee -a /etc/shells
```

Set Fish as your default login shell:

```sh
chsh -s /usr/bin/fish
```

Log out and reconnect for the change to take effect.

Verify the configured login shell:

```sh
echo "$SHELL"
```

## Installing chezmoi

Install chezmoi using its official installer:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)"
```

Ensure the installation directory is in your `PATH`, then verify:

```sh
chezmoi --version
```

## Applying the configuration

Initialize this repository:

```sh
chezmoi init https://github.com/KingPixelKP/dotfiles/
```

Preview the changes before applying them:

```sh
chezmoi diff
```

Apply the configuration:

```sh
chezmoi apply
```
