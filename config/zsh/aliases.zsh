# Git aliases that I'm used to
alias gap='git add -p'
alias gb='git branch'
alias gc='git commit -v'
alias gca='git commit -a -v'
alias gcl='git clean -f -d'
alias gco='git checkout'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdh='git diff HEAD'
alias gl='git pull'
alias glg='git log --graph --oneline --decorate --color --all'
alias glod='git log --oneline --decorate'
alias glp='git log -p'
alias gnap='git add -N --ignore-removal . && gap && gref'
alias gp='git push'
alias gplease='git push --force-with-lease'
alias gpr='git pull --rebase'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grim='git rebase -i main'
alias gst='git status'

# Fun stuff for mix
alias mget='mix deps.get'
alias phs='mix phx.server'

# Aliasing kubectl this way has the added benefit of causing the docker prompt to display the configured context prior to opening k9s
alias k="kubectl"

# Exa - https://the.exa.website/
# alias l="exa --group --header --classify --icons --group-directories-first"
# alias ls="exa --group --all --header --classify --icons --group-directories-first"
# alias ll="exa --long --header --git --all --group --icons --group-directories-first"

# Common operations when not inside of a poetry shell
alias pr="poetry run"
alias pri="poetry run ipython"
alias ppy="poetry  run python"

# Tmux stuff
alias tatt="tmux attach"
alias news="tmux new -s"

# random stuff

# Add a new branch fresh off of main
# Alternatively, a fresh branch off of some other branch
function fresh-branch() {
  echo "Creating a new branch for $1"
  if [ -z "$2" ]; then
    git checkout main && gpr && git checkout -b $1
  else
    git checkout $2 && gpr && git checkout -b $1
  fi
}
