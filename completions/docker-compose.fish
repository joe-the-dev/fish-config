# Fish shell completions for docker compose

set -l compose_commands attach build commit config cp create down events exec export images kill logs ls pause port ps publish pull push restart rm run scale start stats stop top unpause up version volumes wait watch

complete -c docker-compose -f
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a attach   -d 'Attach local standard input, output, and error streams to a service container'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a build    -d 'Build or rebuild services'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a commit   -d 'Create a new image from a service container changes'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a config   -d 'Parse, resolve and render compose file in canonical format'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a cp       -d 'Copy files/folders between a service container and the local filesystem'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a create   -d 'Creates containers for a service'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a down     -d 'Stop and remove containers, networks'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a events   -d 'Receive real time events from containers'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a exec     -d 'Execute a command in a running container'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a export   -d 'Export a service container filesystem as a tar archive'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a images   -d 'List images used by the created containers'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a kill     -d 'Force stop service containers'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a logs     -d 'View output from containers'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a ls       -d 'List running compose projects'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a pause    -d 'Pause services'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a port     -d 'Print the public port for a port binding'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a ps       -d 'List containers'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a publish  -d 'Publish compose application'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a pull     -d 'Pull service images'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a push     -d 'Push service images'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a restart  -d 'Restart service containers'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a rm       -d 'Removes stopped service containers'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a run      -d 'Run a one-off command on a service'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a scale    -d 'Scale services'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a start    -d 'Start services'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a stats    -d 'Display a live stream of container resource usage statistics'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a stop     -d 'Stop services'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a top      -d 'Display the running processes'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a unpause  -d 'Unpause services'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a up       -d 'Create and start containers'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a version  -d 'Show the Docker Compose version information'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a volumes  -d 'List volumes'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a wait     -d 'Block until containers of all (or specified) services stop'
complete -c docker-compose -n "not __fish_seen_subcommand_from $compose_commands" -a watch    -d 'Watch build context for service and rebuild/refresh containers when files are updated'

# Global options
complete -c docker-compose -l all-resources       -d 'Include all resources, even those not used by services'
complete -c docker-compose -l ansi                -d 'Control when to print ANSI control characters (never|always|auto)'
complete -c docker-compose -l compatibility       -d 'Run compose in backward compatibility mode'
complete -c docker-compose -l dry-run             -d 'Execute command in dry run mode'
complete -c docker-compose -l env-file            -d 'Specify an alternate environment file'
complete -c docker-compose -s f -l file           -d 'Compose configuration files'
complete -c docker-compose -l parallel            -d 'Control max parallelism, -1 for unlimited'
complete -c docker-compose -l profile             -d 'Specify a profile to enable'
complete -c docker-compose -l progress            -d 'Set type of progress output (auto, tty, plain, json, quiet)'
complete -c docker-compose -l project-directory   -d 'Specify an alternate working directory'
complete -c docker-compose -s p -l project-name   -d 'Project name'

# up options
complete -c docker-compose -n "__fish_seen_subcommand_from up" -s d -l detach             -d 'Detached mode: Run containers in the background'
complete -c docker-compose -n "__fish_seen_subcommand_from up" -l build                   -d 'Build images before starting containers'
complete -c docker-compose -n "__fish_seen_subcommand_from up" -l no-build                -d 'Do not build an image even if policy is set'
complete -c docker-compose -n "__fish_seen_subcommand_from up" -l force-recreate          -d 'Recreate containers even if their configuration has not changed'
complete -c docker-compose -n "__fish_seen_subcommand_from up" -l no-recreate             -d 'If containers already exist, do not recreate them'
complete -c docker-compose -n "__fish_seen_subcommand_from up" -l remove-orphans          -d 'Remove containers for services not defined in the Compose file'
complete -c docker-compose -n "__fish_seen_subcommand_from up" -s V -l renew-anon-volumes -d 'Recreate anonymous volumes instead of retrieving data from the previous containers'
complete -c docker-compose -n "__fish_seen_subcommand_from up" -l scale                   -d 'Scale SERVICE to NUM instances'
complete -c docker-compose -n "__fish_seen_subcommand_from up" -l timeout                 -d 'Use this timeout in seconds for container shutdown'
complete -c docker-compose -n "__fish_seen_subcommand_from up" -l wait                    -d 'Wait for services to be running/healthy'

# down options
complete -c docker-compose -n "__fish_seen_subcommand_from down" -l remove-orphans    -d 'Remove containers for services not defined in the Compose file'
complete -c docker-compose -n "__fish_seen_subcommand_from down" -l rmi               -d 'Remove images used by services (local|all)'
complete -c docker-compose -n "__fish_seen_subcommand_from down" -s v -l volumes      -d 'Remove named volumes and anonymous volumes attached to containers'
complete -c docker-compose -n "__fish_seen_subcommand_from down" -s t -l timeout      -d 'Specify a shutdown timeout in seconds'

# logs options
complete -c docker-compose -n "__fish_seen_subcommand_from logs" -s f -l follow       -d 'Follow log output'
complete -c docker-compose -n "__fish_seen_subcommand_from logs" -l no-color          -d 'Produce monochrome output'
complete -c docker-compose -n "__fish_seen_subcommand_from logs" -l no-log-prefix     -d 'Do not print prefix in logs'
complete -c docker-compose -n "__fish_seen_subcommand_from logs" -s t -l timestamps   -d 'Show timestamps'
complete -c docker-compose -n "__fish_seen_subcommand_from logs" -l tail              -d 'Number of lines to show from the end of the logs'

# build options
complete -c docker-compose -n "__fish_seen_subcommand_from build" -l no-cache         -d 'Do not use cache when building the image'
complete -c docker-compose -n "__fish_seen_subcommand_from build" -l pull             -d 'Always attempt to pull a newer version of the image'
complete -c docker-compose -n "__fish_seen_subcommand_from build" -s q -l quiet       -d 'Do not print anything to STDOUT'
complete -c docker-compose -n "__fish_seen_subcommand_from build" -l push             -d 'Push service images'

# exec options
complete -c docker-compose -n "__fish_seen_subcommand_from exec" -s d -l detach       -d 'Detached mode: Run command in the background'
complete -c docker-compose -n "__fish_seen_subcommand_from exec" -l privileged        -d 'Give extended privileges to the process'
complete -c docker-compose -n "__fish_seen_subcommand_from exec" -s T -l no-TTY       -d 'Disable pseudo-TTY allocation'
complete -c docker-compose -n "__fish_seen_subcommand_from exec" -s u -l user         -d 'Run the command as this user'
complete -c docker-compose -n "__fish_seen_subcommand_from exec" -s e -l env          -d 'Set environment variables'
complete -c docker-compose -n "__fish_seen_subcommand_from exec" -s w -l workdir      -d 'Path to workdir directory for this command'

# ps options
complete -c docker-compose -n "__fish_seen_subcommand_from ps" -s a -l all            -d 'Show all stopped containers'
complete -c docker-compose -n "__fish_seen_subcommand_from ps" -l format              -d 'Format output (table|json)'
complete -c docker-compose -n "__fish_seen_subcommand_from ps" -s q -l quiet          -d 'Only display IDs'
complete -c docker-compose -n "__fish_seen_subcommand_from ps" -l services            -d 'Display services'
complete -c docker-compose -n "__fish_seen_subcommand_from ps" -l status              -d 'Filter services by status'
