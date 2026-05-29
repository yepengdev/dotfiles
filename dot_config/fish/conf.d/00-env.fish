set -gx EDITOR /usr/local/bin/emacsclient_editor
set -gx LANG en_US.UTF-8
set -gx TERM xterm-256color
set -gx MANROFFOPT -c
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx EMACS_SOCKET_NAME "/run/user/$UID/emacs/server"
set -gx BASH_EXECUTED_FROM_FISH 1

if not set -q __npm_prefix
    set -U __npm_prefix (npm config get prefix)
end
