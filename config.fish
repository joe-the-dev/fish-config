# Performance: Only load in interactive mode
if not status is-interactive
    exit
end

# Setup asdf
if test -d ~/.asdf
    set -gx ASDF_DIR ~/.asdf
    fish_add_path -gP ~/.asdf/shims
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
alias kctl kubectl
alias konf "kubectl config"

# --- Contexts & Namespaces ---
alias kctx "kubectl config get-contexts"
alias kuse "kubectl config use-context"
alias kns "kubectl config set-context --current --namespace"
alias kwhere "kubectl config view --minify | grep namespace"

# --- Get resources ---
alias kg "kubectl get"
alias kgp "kubectl get pods"
alias kgpa "kubectl get pods -A"
alias kgd "kubectl get deployments"
alias kgda "kubectl get deployments -A"
alias kgs "kubectl get services"
alias kgsa "kubectl get services -A"
alias kgn "kubectl get nodes"
alias kgi "kubectl get ingress"
alias kgia "kubectl get ingress -A"
alias kgcm "kubectl get configmap"
alias kgsec "kubectl get secret"
alias kgpv "kubectl get pv"
alias kgpvc "kubectl get pvc"

# --- Describe ---
alias kdp "kubectl describe pod"
alias kdd "kubectl describe deployment"
alias kds "kubectl describe service"
alias kdn "kubectl describe node"

# --- Logs ---
alias kl "kubectl logs"
alias klf "kubectl logs -f"
alias klp "kubectl logs -f --previous"

# --- Apply / Delete ---
alias kaf "kubectl apply -f"
alias kdf "kubectl delete -f"
alias kdel "kubectl delete"

# --- Exec ---
alias kex "kubectl exec -it"

# --- Port forward ---
alias kfwd "kubectl port-forward"

# --- Rollout ---
alias krr "kubectl rollout restart deployment"
alias krs "kubectl rollout status deployment"
alias krh "kubectl rollout history deployment"

# --- Scale ---
alias ksc "kubectl scale deployment"

# --- K8s helper functions ---
function ksh --description 'Open a shell in a pod: ksh <pod> [container]'
    if test (count $argv) -ge 2
        kubectl exec -it $argv[1] -c $argv[2] -- sh
    else
        kubectl exec -it $argv[1] -- sh
    end
end

function kbash --description 'Open bash in a pod: kbash <pod> [container]'
    if test (count $argv) -ge 2
        kubectl exec -it $argv[1] -c $argv[2] -- bash
    else
        kubectl exec -it $argv[1] -- bash
    end
end

function kgpl --description 'Get pods with a label: kgpl <label=value>'
    kubectl get pods -l $argv[1]
end

function kwatch --description 'Watch pods in current namespace'
    watch kubectl get pods $argv
end

function ktop --description 'Top pods or nodes: ktop [pods|nodes]'
    if test "$argv[1]" = nodes
        kubectl top nodes
    else
        kubectl top pods $argv[2..]
    end
end

function knuke --description 'Force delete a stuck pod: knuke <pod>'
    kubectl delete pod $argv[1] --grace-period=0 --force
end

function kctx_pick --description 'Interactively switch kubectl context'
    set -l ctx (kubectl config get-contexts -o name | fzf --prompt="Select context: ")
    if test -n "$ctx"
        kubectl config use-context $ctx
        echo "Switched to context: $ctx"
    end
end

function kns_pick --description 'Interactively switch namespace'
    set -l ns (kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf --prompt="Select namespace: ")
    if test -n "$ns"
        kubectl config set-context --current --namespace=$ns
        echo "Switched to namespace: $ns"
    end
end

function kpick --description 'Interactively pick a pod and exec into it'
    set -l pod (kubectl get pods --no-headers -o custom-columns=":metadata.name" | fzf --prompt="Select pod: ")
    if test -n "$pod"
        kubectl exec -it $pod -- sh
    end
end

function klpick --description 'Interactively pick a pod and tail its logs'
    set -l pod (kubectl get pods --no-headers -o custom-columns=":metadata.name" | fzf --prompt="Select pod: ")
    if test -n "$pod"
        kubectl logs -f $pod
    end
end

function ksec --description 'Decode and show all values of a secret: ksec <secret>'
    kubectl get secret $argv[1] -o json | \
        python3 -c "import sys,json,base64; s=json.load(sys.stdin)['data']; [print(k+': '+base64.b64decode(v).decode()) for k,v in s.items()]"
end

function kcp --description 'Copy file from pod: kcp <pod>:<path> <local-path>'
    kubectl cp $argv[1] $argv[2]
end

function krestart --description 'Rolling restart all deployments in namespace'
    kubectl rollout restart deployment
end

function kevents --description 'Show events sorted by time'
    kubectl get events --sort-by=.lastTimestamp $argv
end

function kimg --description 'Show container images for all pods'
    kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .spec.containers[*]}{.image}{"\n"}{end}{end}'
end

function kresources --description 'Show resource requests/limits for all pods'
    kubectl get pods -o custom-columns="NAME:.metadata.name,CPU-REQ:.spec.containers[*].resources.requests.cpu,CPU-LIM:.spec.containers[*].resources.limits.cpu,MEM-REQ:.spec.containers[*].resources.requests.memory,MEM-LIM:.spec.containers[*].resources.limits.memory"
end

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

function nv --description 'Set global Node.js version with asdf'
    if test (count $argv) -eq 0
        echo "Current Node.js version: "(node -v)
        echo "Available versions:"
        asdf list nodejs
    else
        # Use asdf set with -u flag to set in user home .tool-versions
        asdf set -u nodejs $argv[1]
        # Reload the version by reshimming
        asdf reshim nodejs
        echo "Switched to Node.js version: "(node -v)
    end
end

# Per-directory history management
set -g fish_history_dir ~/.local/share/fish/history_dirs

function __update_history_file --on-variable PWD --description 'Switch history file based on directory'
    # Create history directory if it doesn't exist
    test -d $fish_history_dir; or mkdir -p $fish_history_dir

    # Create a hash of the current directory path, replacing invalid characters
    set -l dir_hash (string replace -a / _ (pwd) | string replace -a . _ | string sub -s 2)
    set -l history_name "dir$dir_hash"

    # Switch to this directory's history
    if test "$fish_history" != "$history_name"
        set -gx fish_history $history_name
        history save
    end
end

function history_global --description 'Switch back to global history'
    set -gx fish_history fish
    history save
    echo "Switched to global history"
end

function history_local --description 'Switch to per-directory history mode'
    __update_history_file
    echo "Switched to per-directory history for: "(pwd)
end

alias fhg history_global
alias fhl history_local

# Initialize per-directory history
__update_history_file

# Load external configuration files with error handling
for config_file in ~/.config/fish/fzf.fish ~/.config/fish/peco.fish
    if test -f $config_file
        source $config_file
    end
end

function ports --description 'Show listening ports'
    sudo lsof -iTCP -sTCP:LISTEN -n -P
end
