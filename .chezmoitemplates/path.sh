{{ if eq .chezmoi.os "darwin" -}}
# Homebrew (Apple Silicon puis Intel)
{{ template "brew-env.sh" . }}
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

{{ end -}}
# PATH utilisateur (sans doublons)
for d in "$HOME/.local/bin" "$HOME/bin"; do
  if [ -d "$d" ]; then
    case ":$PATH:" in
      *":$d:"*) ;;
      *) PATH="$d:$PATH" ;;
    esac
  fi
done
export PATH

export EDITOR=nvim
export VISUAL=nvim

# fzf : liste les fichiers avec fd (respecte .gitignore) et ouvre dans un panneau inversé
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
