if status is-interactive
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
end
