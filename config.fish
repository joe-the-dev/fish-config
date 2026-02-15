# Performance: Only load in interactive mode
if not status is-interactive
    exit
end

# Environment loading with better error handling
if test -f $HOME/.env
    bass source $HOME/.env
end

# Better terminal and display settings
set fish_greeting
set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx VISUAL nvim

# Enhanced aliases with better organization
# Basic file operations
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias clr realclear

# Git aliases
alias g git
alias gs "git status"
alias ga "git add"
alias gc "git commit"
alias gcm "git commit -m"
alias gp "git push"
alias gl "git log --oneline"

# Kubernetes aliases
alias k kubectl
alias kl kubectl
alias kctl kubectl
alias konf "kubectl config"
alias kfwd "kpfwd"
alias kns "kubectl config set-context --current --namespace"

if type -q eza
    alias ll "eza -l -g --icons --git"
    alias lla "ll -a"
    alias lt "eza --tree --level=2 --icons"
    alias lta "lt -a"
end

# Editor aliases
alias vi nvim
command -qv nvim && alias vim nvim


function realclear --description 'Clear terminal completely'
    clear
    printf '\e[3J'
end


function myip --description 'Get public IP address'
    curl -s ifconfig.me
end

# Load external configuration files with error handling
for config_file in ~/.config/fish/fzf.fish ~/.config/fish/peco.fish
    if test -f $config_file
        source $config_file
    end
end

function ports --description 'Show listening ports'
    sudo lsof -iTCP -sTCP:LISTEN -n -P
end
