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
