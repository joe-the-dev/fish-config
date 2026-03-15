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

function pv --description 'Set global pnpm version with asdf: pv [version]'
    if test (count $argv) -eq 0
        echo "Current pnpm version: "(pnpm -v)
        echo "Available versions:"
        asdf list pnpm
    else
        asdf install pnpm $argv[1]
        asdf set -u pnpm $argv[1]
        asdf reshim pnpm
        echo "Switched to pnpm version: "(pnpm -v)
    end
end

# Per-directory history management
set -g fish_history_dir ~/.local/share/fish/history_dirs

function __update_history_file --on-variable PWD --description 'Switch history file based on directory'
    # Create history directory if it doesn't exist
    test -d $fish_history_dir; or mkdir -p $fish_history_dir

    # Create a hash of the current directory path, replacing invalid characters
    set -l dir_hash (string replace -a / _ (pwd) | string replace -a . _ | string replace -a - _ | string sub -s 2)
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

function fixnpm --description 'Fix node-toolbox SSH issue and run npm install: fixnpm [path] [--profile personal|work] [--clean]'
    # Defaults
    set -l target_dir (pwd)
    set -l profile ""       # auto-detect if not specified
    set -l do_clean 0

    # Parse arguments
    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case --profile
                set i (math $i + 1)
                set profile $argv[$i]
            case --clean
                set do_clean 1
            case '*'
                set target_dir (realpath $argv[$i])
        end
        set i (math $i + 1)
    end

    if not test -f "$target_dir/package.json"
        echo "✗ No package.json found in: $target_dir"
        return 1
    end

    echo "→ Target: $target_dir"

    # Auto-detect profile from current git URL rewrite if not specified
    if test -z "$profile"
        set -l rewrite (git config --global --get "url.git@github-work:holidayextras/.insteadof" 2>/dev/null)
        if test -n "$rewrite"
            set profile work
            echo "→ Profile: work (auto-detected from git URL rewrite)"
        else
            set profile personal
            echo "→ Profile: personal (auto-detected, no work rewrite active)"
        end
    else
        echo "→ Profile: $profile"
    end

    switch $profile
        case work
            # Ensure work git URL rewrite is active
            set -l rewrite (git config --global --get "url.git@github-work:holidayextras/.insteadof" 2>/dev/null)
            if test -z "$rewrite"
                echo "⚠ Work git URL rewrite not active — applying now..."
                git config --global url."git@github-work:holidayextras/".insteadOf "ssh://git@github.com/holidayextras/"
                git config --global url."git@github-work:holidayextras/".insteadOf "git@github.com:holidayextras/"
                echo "✓ Git URL rewrite applied (github.com/holidayextras → github-work)"
            else
                echo "✓ Git URL rewrite already active"
            end

            # Verify SSH access
            set -l ssh_check (ssh -T git@github-work 2>&1 | string match -rg 'Hi (\S+)!')
            if test -z "$ssh_check"
                echo "✗ Work SSH key auth failed — run: ghswitch work"
                return 1
            end
            echo "✓ SSH authenticated as: $ssh_check (work)"

        case personal
            # Remove work rewrite rules so personal key is used
            git config --global --unset "url.git@github-work:holidayextras/.insteadof" 2>/dev/null
            echo "✓ Using personal GitHub credentials"

            # Verify SSH access
            set -l ssh_check (ssh -T git@github-personal 2>&1 | string match -rg 'Hi (\S+)!')
            if test -z "$ssh_check"
                echo "⚠ Personal SSH key auth check failed — continuing anyway"
            else
                echo "✓ SSH authenticated as: $ssh_check (personal)"
            end

        case '*'
            echo "✗ Unknown profile: $profile (use 'personal' or 'work')"
            return 1
    end

    # Clean node_modules and lock file for a fresh install
    if test $do_clean -eq 1
        echo "→ Cleaning node_modules and package-lock.json..."
        rm -rf "$target_dir/node_modules" "$target_dir/package-lock.json"
    end

    # Run npm install
    echo "→ Running npm install..."
    cd $target_dir && npm install
    set -l npm_status $status
    if test $npm_status -eq 0
        echo "✓ npm install completed successfully"
    else
        echo "✗ npm install failed (exit $npm_status)"
        return $npm_status
    end
end

function fixnpm_all --description 'Run fixnpm on all repos with node-toolbox in a directory: fixnpm_all [base_dir] [--profile personal|work] [--clean]'
    set -l base_dir (pwd)
    set -l extra_flags

    # Parse arguments
    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case --profile
                set i (math $i + 1)
                set extra_flags $extra_flags --profile $argv[$i]
            case --clean
                set extra_flags $extra_flags --clean
            case '*'
                set base_dir (realpath $argv[$i])
        end
        set i (math $i + 1)
    end

    echo "→ Scanning repos in: $base_dir"

    set -l fixed 0
    set -l skipped 0
    set -l failed 0

    for pkg in $base_dir/*/package.json
        set -l repo_dir (dirname $pkg)
        set -l repo_name (basename $repo_dir)

        if grep -q "node-toolbox" $pkg 2>/dev/null
            echo ""
            echo "══ $repo_name ══"
            fixnpm $repo_dir $extra_flags
            if test $status -eq 0
                set fixed (math $fixed + 1)
            else
                set failed (math $failed + 1)
            end
        else
            set skipped (math $skipped + 1)
        end
    end

    echo ""
    echo "══════════════════════════════"
    echo "  Done — fixed: $fixed | failed: $failed | skipped (no toolbox): $skipped"
end

# Git profile switcher for a directory of repos
function gitprofile --description 'Switch git user.name/email for all repos in a dir: gitprofile [personal|work] [dir]'
    set -l profiles_name_personal "Joe Vu"
    set -l profiles_email_personal "vuthanhdat.dev@gmail.com"
    set -l profiles_name_work "Dat Ta"
    set -l profiles_email_work "dat.ta@holidayextras.com"

    set -l profile $argv[1]
    set -l target_dir (count $argv) -ge 2 && realpath $argv[2] || pwd

    # Re-evaluate correctly
    if test (count $argv) -ge 2
        set target_dir (realpath $argv[2])
    else
        set target_dir (pwd)
    end

    switch $profile
        case personal
            set name $profiles_name_personal
            set email $profiles_email_personal
        case work
            set name $profiles_name_work
            set email $profiles_email_work
        case '*'
            echo "Usage: gitprofile [personal|work] [dir]"
            echo "  personal → $profiles_name_personal <$profiles_email_personal>"
            echo "  work     → $profiles_name_work <$profiles_email_work>"
            return 1
    end

    set -l count 0
    for repo in $target_dir/*/
        if test -d "$repo/.git"
            git -C "$repo" config --local user.name "$name"
            git -C "$repo" config --local user.email "$email"
            echo "✓ "(basename $repo)" → $name <$email>"
            set count (math $count + 1)
        end
    end

    if test $count -eq 0
        # Maybe target_dir itself is a repo
        if test -d "$target_dir/.git"
            git -C "$target_dir" config --local user.name "$name"
            git -C "$target_dir" config --local user.email "$email"
            echo "✓ "(basename $target_dir)" → $name <$email>"
            set count 1
        else
            echo "⚠ No git repos found in: $target_dir"
            return 1
        end
    end

    echo ""
    echo "✓ Done — $count repo(s) switched to $profile profile"
end

function gcp --description 'Cherry-pick a commit onto a new branch: gcp <commit> <new-branch> <base-branch>'
    if test (count $argv) -lt 3
        echo "Usage: gcp <commit> <new-branch> <base-branch>"
        echo ""
        echo "Example:"
        echo "  gcp 32a1a189 feat/CU-869c8bx1r-s112 develop-s112"
        echo ""
        echo "  → checkout develop-s112"
        echo "  → pull origin develop-s112"
        echo "  → create branch feat/CU-869c8bx1r-s112"
        echo "  → cherry-pick <commit>"
        echo "  → git push -f origin feat/CU-869c8bx1r-s112"
        return 1
    end

    set -l commit $argv[1]
    set -l new_branch $argv[2]
    set -l base_branch $argv[3]

    echo "→ Fetching to base branch: $base_branch"
    git fetch -p; or return 1

    echo "→ Switching to base branch: $base_branch"
    git checkout $base_branch; or return 1

    echo "→ Pulling latest: $base_branch"
    git pull origin $base_branch; or return 1

    echo "→ Creating new branch: $new_branch"
    git cobd $new_branch; or return 1

    echo "→ Cherry-picking: $commit"
    git cherry-pick $commit; or return 1

    echo "→ Force pushing: $new_branch"
    git push -f origin $new_branch; or return 1

    echo ""
    echo "✓ Done — $commit cherry-picked onto $new_branch (based on $base_branch)"
end

# GitHub credential switcher
function ghswitch --description 'Switch between personal and work GitHub credentials: ghswitch [personal|work]'
    set -l personal_key ~/.ssh/id_ed25519
    set -l work_key ~/.ssh/id_ed25519_work

    # Detect current active identity
    function __ghswitch_current
        set -l current (ssh -T git@github.com -i $personal_key 2>&1 | string match -r 'Hi (\S+)!')
        if test -n "$current"
            echo "personal ($current)"
            return
        end
        set -l current (ssh -T git@github.com -i $work_key 2>&1 | string match -r 'Hi (\S+)!')
        if test -n "$current"
            echo "work ($current)"
        end
    end

    if test (count $argv) -eq 0
        # Show current active identity for both
        set -l personal_user (ssh -T git@github-personal 2>&1 | string match -rg 'Hi (\S+)!')
        set -l work_user (ssh -T git@github-work 2>&1 | string match -rg 'Hi (\S+)!')
        echo "Available GitHub credentials:"
        echo "  personal → $personal_user (key: $personal_key)"
        echo "  work     → $work_user (key: $work_key)"

        # Show which insteadOf is currently active
        set -l current_rewrite (git config --global --get url.git@github-work:holidayextras/.insteadof 2>/dev/null)
        if test -n "$current_rewrite"
            echo ""
            echo "Active git URL rewrite: github.com/holidayextras → github-work (dat-ta-hx / work)"
        else
            echo ""
            echo "Active git URL rewrite: none (using default github.com)"
        end
        return
    end

    switch $argv[1]
        case personal
            # Remove work rewrite rules
            git config --global --unset url.git@github-work:holidayextras/.insteadof "ssh://git@github.com/holidayextras/" 2>/dev/null
            git config --global --unset url.git@github-work:holidayextras/.insteadof "git@github.com:holidayextras/" 2>/dev/null
            set -l user (ssh -T git@github-personal 2>&1 | string match -rg 'Hi (\S+)!')
            echo "✓ Switched to personal GitHub: $user"
            echo "  Using key: $personal_key"

        case work
            # Set work rewrite rules
            git config --global url."git@github-work:holidayextras/".insteadOf "ssh://git@github.com/holidayextras/"
            git config --global url."git@github-work:holidayextras/".insteadOf "git@github.com:holidayextras/"
            set -l user (ssh -T git@github-work 2>&1 | string match -rg 'Hi (\S+)!')
            echo "✓ Switched to work GitHub: $user"
            echo "  Using key: $work_key"

        case '*'
            echo "Usage: ghswitch [personal|work]"
            echo "       ghswitch        → show current status"
    end
end

