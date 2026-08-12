source /etc/bash_completion

alias composer701="php7.0 /usr/local/bin/composer1"
alias composer702="php7.0 /usr/local/bin/composer2"
alias composer711="php7.1 /usr/local/bin/composer1"
alias composer712="php7.1 /usr/local/bin/composer2"
alias composer721="php7.2 /usr/local/bin/composer1"
alias composer722="php7.2 /usr/local/bin/composer2"
alias composer731="php7.3 /usr/local/bin/composer1"
alias composer732="php7.3 /usr/local/bin/composer2"
alias composer741="php7.4 /usr/local/bin/composer1"
alias composer742="php7.4 /usr/local/bin/composer2"
alias composer801="php8.0 /usr/local/bin/composer1"
alias composer802="php8.0 /usr/local/bin/composer2"
alias composer811="php8.1 /usr/local/bin/composer1"
alias composer812="php8.1 /usr/local/bin/composer2"
alias composer822="php8.2 /usr/local/bin/composer2"
alias composer832="php8.3 /usr/local/bin/composer2"
alias composer842="php8.4 /usr/local/bin/composer2"
alias composer852="php8.5 /usr/local/bin/composer2"

# console
alias console56="php5.6 bin/console"
alias console70="php7.0 bin/console"
alias console71="php7.1 bin/console"
alias console72="php7.2 bin/console"
alias console73="php7.3 bin/console"
alias console74="php7.4 bin/console"
alias console80="php8.0 bin/console"
alias console81="php8.1 bin/console"
alias console82="php8.2 bin/console"
alias console83="php8.3 bin/console"
alias console84="php8.4 bin/console"
alias console85="php8.5 bin/console"

# fixes
alias ssh-fix="eval \"$(ssh-agent -s)\" && ssh-add"

# git
alias gclear="git reset --hard HEAD"
alias ghconf="git config user.name amalija-ramljak && git config user.email amalija.ramljak@gmail.com"
alias gst='git status'
alias gl='git log'
alias gls='git log --pretty="%C(Yellow)%<(12)%h %C(Green)%>(16)%cr%C(reset) %C(Cyan)%>(20)%an %x09 %C(reset)%s"'
alias glsgrepi='gls | grep -i'
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gps='git push'
alias gpsf='git push --force-with-lease'
alias gpsn='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gr='git rebase'
alias gbd='git branch -D'
alias gc='git checkout'
alias gchn='git checkout -b'
alias gcout='bash -eo pipefail -c "v="$(set -eo pipefail; git branch --list | awk "{print \$NF}" | fzf --preview="git log --stat --color --abbrev-commit -5 {}" --height 70% --preview-window=right:75%)"; [ ! -z "\$v" ] && git checkout "\$v""'
alias grpo='git remote prune origin'
alias gcp='git cherry-pick'
alias git-show="git update-index --no-skip-worktree"
alias git-hide="git update-index --skip-worktree"

alias git-cred="git config --global credential.helper store"

# socket
port-socket() {
    nohup socat UNIX-LISTEN:$(pwd -P)/node.sock,fork,reuseaddr,unlink-early,mode=777 TCP:127.0.0.1:$1 &
    echo $! > socket.lock
}

remove-socket() {
    kill -9 $(cat socket.lock) && rm socket.lock
}

# nvm
# Auto-switch node version on directory change, based on the nearest .nvmrc.
# This file is sourced from ~/.bashrc before nvm itself loads, so the body is
# guarded and only does work at prompt time, once nvm is available.
autoload_nvmrc() {
    command -v nvm >/dev/null 2>&1 || return 0

    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version
        nvmrc_node_version="$(nvm version "$(cat "$nvmrc_path")")"

        if [ "$nvmrc_node_version" = "N/A" ]; then
            nvm install
        elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
            nvm use --silent
        fi
    elif [ -n "$(PWD="$OLDPWD" nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default --silent
    fi
}

PROMPT_COMMAND="autoload_nvmrc${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
