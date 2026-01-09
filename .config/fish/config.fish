set -g fish_greeting

# aliases
alias lg="lazygit log"
alias k="kubectl"

# git aliases
alias gd="git diff --output-indicator-new=' ' --output-indicator-old=' '"

alias ga="git add"
alias gap="git add --patch"
alias gc="git commit"

alias gs="git switch"
alias gr="git restore"

alias gp="git push"
alias gu="git pull"

alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias gb="git branch"

alias gi="git init"
alias gcl="git clone"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
