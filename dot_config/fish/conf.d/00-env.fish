set -gx EDITOR /usr/local/bin/emacsclient_editor
set -gx LANG en_US.UTF-8
set -gx TERM xterm-256color
set -gx MANROFFOPT -c
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx EMACS_SOCKET_NAME "/run/user/$(id -u)/emacs/server"
if not set -q __npm_prefix
    set -gx __npm_prefix (npm config get prefix)
end

if command -q flatpak && not string match -qr "flatpak" -- "$XDG_DATA_DIRS"
    set -gx XDG_DATA_DIRS "$HOME/.local/share/flatpak/exports/share" \
                           /var/lib/flatpak/exports/share \
                           $XDG_DATA_DIRS
end
