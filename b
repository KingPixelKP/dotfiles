diff --git a/dot_config/fish/conf.d/bat.fish b/dot_config/fish/conf.d/bat.fish
index 6f71e0c..a937443 100644
--- a/dot_config/fish/conf.d/bat.fish
+++ b/dot_config/fish/conf.d/bat.fish
@@ -3,4 +3,10 @@ if command -q bat
     alias b bat
 else if command -q batcat
     alias b batcat
+end
+
+# Format man pages with bat when available.
+if command -q bat || command -q batcat
+    set -gx MANROFFOPT "-c"
+    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
 end
\ No newline at end of file
diff --git a/dot_config/fish/conf.d/eza.fish b/dot_config/fish/conf.d/eza.fish
index 49f479c..5e7bef3 100644
--- a/dot_config/fish/conf.d/eza.fish
+++ b/dot_config/fish/conf.d/eza.fish
@@ -1,8 +1,8 @@
 # Replace ls with eza when installed.
 if command -q eza
-    alias ls='eza -al --color=auto --group-directories-first'
-    alias la='eza -a --color=auto --group-directories-first'
-    alias ll='eza -l --color=auto --group-directories-first'
-    alias lt='eza -aT --color=auto --group-directories-first'
+    alias ls='eza -al --color=auto --group-directories-first --icons=always'
+    alias la='eza -a --color=auto --group-directories-first --icons=always'
+    alias ll='eza -l --color=auto --group-directories-first --icons=always'
+    alias lt='eza -aT --color=auto --group-directories-first --icons=always'
     alias 'l.'="eza -a | grep -E '^\\.'"
 end
\ No newline at end of file
diff --git a/dot_config/fish/conf.d/keybinds.fish b/dot_config/fish/conf.d/keybinds.fish
deleted file mode 100644
index 35be57c..0000000
--- a/dot_config/fish/conf.d/keybinds.fish
+++ /dev/null
@@ -1,2 +0,0 @@
-# Ctrl+Backspace deletes the previous word.
-bind \x7F backward-kill-word
\ No newline at end of file
diff --git a/dot_config/fish/config.fish b/dot_config/fish/config.fish
index 70a1c13..53016a5 100644
--- a/dot_config/fish/config.fish
+++ b/dot_config/fish/config.fish
@@ -11,12 +11,6 @@ fish_add_path "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/Applications/depot_to
 # Docker normally defaults to /var/run/docker.sock; set DOCKER_HOST only
 # if you need to override that default.
 
-# Format man pages with bat when available.
-if command -q bat
-    set -gx MANROFFOPT "-c"
-    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
-end
-
 # Interactive command-line shortcuts.
 if status is-interactive
     if test "$fish_key_bindings" = fish_vi_key_bindings
@@ -26,6 +20,11 @@ if status is-interactive
         bind ! __history_previous_command
         bind '$' __history_previous_command_arguments
     end
+    
+    if command -q starship
+        starship init fish | source
+    end
+
 end
 
 # Navigation.
diff --git a/scripts/install-tools.sh b/scripts/install-tools.sh
old mode 100644
new mode 100755
index c9851b0..92a03db
--- a/scripts/install-tools.sh
+++ b/scripts/install-tools.sh
@@ -3,14 +3,38 @@
 # Install useful command-line tools on Arch-based or Debian-based systems.
 set -Eeuo pipefail
 
-ARCH_PACKAGES=(eza bat fzf ripgrep fd zoxide btop)
+ARCH_PACKAGES=(eza bat fzf ripgrep fd zoxide btop starship ttf-jetbrains-mono-nerd)
 DEBIAN_PACKAGES=(eza bat fzf ripgrep fd-find zoxide btop)
+DEBIAN_URLS=(
+    "https://starship.rs/install.sh"
+)
 
 fail() {
     printf 'Error: %s\n' "$*" >&2
     exit 1
 }
 
+install_jetbrains_mono_nerd_font() {
+    local fontdir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
+    local archive="/tmp/JetBrainsMono.tar.xz"
+
+    mkdir -p "$fontdir" || return 1
+
+    echo "Downloading JetBrainsMono Nerd Font..."
+    curl -fL \
+        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
+        -o "$archive" || return 1
+
+    tar -xf "$archive" -C "$fontdir" || return 1
+
+    if command -v fc-cache >/dev/null 2>&1; then
+        fc-cache -f "$fontdir"
+    fi
+
+    rm -f "$archive"
+    echo "JetBrainsMono Nerd Font installed."
+}
+
 if [[ ! -r /etc/os-release ]]; then
     fail 'Cannot identify this distribution: /etc/os-release is missing.'
 fi
@@ -49,6 +73,14 @@ case "$DISTRO_ID" in
                 missing+=("$package")
             fi
         done
+        for url in "${DEBIAN_URLS[@]}"; do
+            printf 'Installing from URL: %s\n' "$url"
+            curl -fsSL "$url" | "${SUDO[@]}" sh
+        done
+
+        #Install jetbrains mono nerd font
+        install_jetbrains_mono_nerd_font
+
 
         ((${#available[@]} > 0)) || fail 'None of the requested packages were found in the enabled APT repositories.'
         printf 'Installing available packages: %s\n' "${available[*]}"
