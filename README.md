# dotfiles

Un seul dépôt pour configurer **macOS, Linux (dont WSL) et Windows**, géré par [chezmoi](https://www.chezmoi.io) : un binaire open source local, sans compte ni service.

| OS | Statut |
| --- | --- |
| macOS | Cible principale, en cours de validation |
| Linux / WSL | Écrit, pas encore validé |
| Windows | Écrit, pas encore validé |

## Ce que ça gère

| Domaine | Fichiers déployés |
| --- | --- |
| Shell | `~/.zshrc`, `~/.bashrc`, `~/.bash_profile`, profils PowerShell, `~/.config/starship.toml` |
| Git | `~/.gitconfig` (delta, credential helper adapté à l'OS), ignore global, identité pro sous `~/work/` |
| SSH / GPG | `~/.ssh/config` (sans clé), `~/.gnupg/gpg.conf` et `gpg-agent.conf` (pinentry selon l'OS) |
| Éditeurs | VS Code (`settings.json` au bon endroit sur chaque OS), Neovim (`init.lua`, sans plugin) |
| Paquets | `.chezmoidata/packages.yaml` → Homebrew (macOS), apt/dnf/pacman (Linux), winget (Windows), extensions VS Code |

## Installation sur macOS

Prérequis : [Homebrew](https://brew.sh). Le script d'installation des paquets ne l'installe pas à ta place.

```sh
brew install chezmoi
chezmoi init --apply --ssh <utilisateur>      # dépôt privé via ta clé SSH GitHub
# ou : chezmoi init --apply https://github.com/<utilisateur>/dotfiles.git
```

`chezmoi init` cherche le dépôt `<utilisateur>/dotfiles` sur GitHub. Il pose quatre questions (nom, email, email pro optionnel, clé GPG optionnelle), installe les paquets via `brew bundle` puis déploie les fichiers. Les réponses restent sur la machine, dans `~/.config/chezmoi/chezmoi.toml`.

Avant le premier `apply`, tu peux voir ce qui va changer :

```sh
chezmoi init --ssh <utilisateur>
chezmoi diff
chezmoi apply
```

Le dépôt étant privé, GitHub doit pouvoir t'authentifier : clé SSH ajoutée à ton compte, ou `gh auth login` suivi de `gh auth setup-git`.

## Ce qui est spécifique à macOS

Au premier `chezmoi apply`, dans cet ordre :

1. **Paquets** (`brew bundle`) : outils CLI, Ghostty, Raycast, Rectangle, Stats, AppCleaner, VS Code, police Nerd Font, Colima et le CLI Docker. La liste est dans `.chezmoidata/packages.yaml`.
2. **Fichiers** : zsh, git, ssh, gpg, starship, Ghostty, mise, VS Code, Neovim.
3. **Touch ID pour sudo** : écrit `/etc/pam.d/sudo_local` (macOS 14+). Il te demandera ton mot de passe une fois. Pour annuler, retire la ligne `pam_tid.so` de ce fichier.
4. **Réglages système** (`defaults write`) : clavier, trackpad, Finder, Dock, captures d'écran dans `~/Screenshots`. Le script est commenté, retire ce que tu ne veux pas ; il se relance quand tu le modifies. Un réglage s'annule avec `defaults delete <domaine> <clé>`.
5. **Docker** : lie les plugins `docker compose` et `docker buildx` pour le CLI Homebrew.
6. **mise** : installe Node (LTS), Python 3.13, uv et pnpm déclarés dans `~/.config/mise/config.toml`.

**Docker sans Docker Desktop** : `colima start`, puis `docker ps`. Colima fait tourner la VM ; `ld` ouvre lazydocker. Si tu préfères OrbStack, remplace `colima` par le cask `orbstack` dans `packages.yaml`.

**Ghostty** : thème clair/sombre qui suit le système, Option gauche = Alt (l'Option droite reste libre pour les caractères AZERTY), et un terminal déroulant sur `Ctrl+Alt+Espace` (il demande l'autorisation Accessibilité dans Réglages Système).

**Alias macOS** : `o` / `oo` (open), `bup` (mise à jour Homebrew), `lg` (lazygit), `ld` (lazydocker), `flushdns`.

## Installation sur Linux / WSL / Windows (expérimental)

```sh
# Linux / WSL : installe chezmoi par ton gestionnaire de paquets (ou https://www.chezmoi.io/install/)
chezmoi init --apply --ssh <utilisateur>
```

```powershell
# Windows
winget install twpayne.chezmoi
chezmoi init --apply --ssh <utilisateur>
```

## Utilisation au quotidien

```sh
chezmoi edit ~/.zshrc      # modifier un fichier géré (alias : cme)
chezmoi diff               # voir ce qui changerait
chezmoi apply              # appliquer (alias : cma)
chezmoi add ~/.tmux.conf   # gérer un nouveau fichier
chezmoi cd                 # aller dans le dépôt, puis git add/commit/push
chezmoi update             # sur une autre machine : git pull + apply
```

Si tu modifies directement un fichier déployé, `chezmoi re-add <fichier>` le réimporte dans le dépôt.

## Structure

```
.chezmoi.toml.tmpl        questions posées à l'init, détection de WSL
.chezmoidata/             données : liste des paquets par OS
.chezmoiignore            quels fichiers ignorer selon l'OS
.chezmoitemplates/        morceaux partagés (alias, PATH, profil PowerShell, settings VS Code, init.lua)
.chezmoiscripts/          installation des paquets et extensions
.github/workflows/        vérification en simulation sur macOS, Linux et Windows
dot_*, private_dot_*      fichiers déployés dans ~ (private_ = droits restreints)
Library/                  cibles spécifiques à macOS
Documents/, AppData/      cibles spécifiques à Windows
```

Pour ajouter un paquet, édite `.chezmoidata/packages.yaml`. Pour une différence entre OS dans un fichier, utilise `{{ if eq .chezmoi.os "darwin" }}…{{ end }}` (valeurs : `darwin`, `linux`, `windows`) ou `.isWSL`.

## Réglages propres à une machine

Rien de privé n'est versionné. Utilise les fichiers locaux, chargés s'ils existent : `~/.zshrc.local`, `~/.bashrc.local`, `profile.local.ps1` (à côté du profil PowerShell), et `~/.ssh/config.d/*` pour les hôtes SSH.

Pour de vrais secrets, chezmoi sait chiffrer des fichiers avec [age](https://www.chezmoi.io/user-guide/encryption/age/) ou lire un gestionnaire de mots de passe (1Password, Bitwarden…).

## Points d'attention

- **Écrasement** : `chezmoi apply` remplace `settings.json` de VS Code. Les réglages changés dans l'interface sont perdus sauf si tu les rapatries avec `chezmoi re-add`.
- **Polices** : JetBrainsMono Nerd Font est installée pour les icônes de starship ; sélectionne-la dans ton terminal.
- **GPG sur macOS** : après un premier déploiement de `gpg-agent.conf`, relance l'agent avec `gpgconf --kill gpg-agent`.
- **Touch ID dans tmux** : `sudo` par empreinte ne fonctionne pas dans tmux sans le paquet `pam-reattach` (non installé ici, à ajouter si tu en as besoin).
- **Non vérifié sur un vrai Mac** : les scripts macOS et la config Ghostty (noms de thèmes, raccourci global) ont été relus mais pas exécutés. Si un message d'erreur apparaît, c'est probablement là.
- **Linux** : starship, s'il n'est pas dans les dépôts de la distribution, est installé via son script officiel dans `~/.local/bin`.
- **WSL** : Git réutilise le Credential Manager de Windows ; le presse-papiers de Neovim demande `win32yank` (sinon retire la ligne `clipboard` dans `.chezmoitemplates/nvim-init.lua`).
- **Windows** : si ton dossier Documents est redirigé par OneDrive, le profil PowerShell est lu ailleurs que dans `~/Documents`. Vérifie avec `$PROFILE`.

## Licence

MIT, voir [LICENSE](LICENSE).
