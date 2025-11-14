#source /usr/share/cachyos-fish-config/cachyos-config.fish
source ~/.config/fish/cachyos-config.fish
source ~/.config/fish/functions/yazi.fish

bass source /etc/profile

set -x EMACS_SOCKET_NAME "/run/user/(id -u)/emacs/server"

set -gx PATH "$PATH:$HOME/.local/bin:$HOME/.local/bin/statusbar:"

function fish_command_not_found
    /usr/bin/command-not-found $argv
end

alias e=emacsclient_editor

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    # smth smth
end
