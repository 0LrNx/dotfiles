# Alias communs à bash et zsh
alias ..='cd ..'
alias ...='cd ../..'
alias v='nvim'
alias vim='nvim'
alias reload='exec "$SHELL" -l'

alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'

alias cm='chezmoi'
alias cma='chezmoi apply'
alias cme='chezmoi edit --apply'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -lah --git --group-directories-first'
else
  alias ll='ls -lah'
fi

command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'
command -v lazydocker >/dev/null 2>&1 && alias ld='lazydocker'
{{ if eq .chezmoi.os "darwin" }}
alias o='open'
alias oo='open .'
alias bup='brew update && brew upgrade && brew cleanup'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
{{ end -}}
