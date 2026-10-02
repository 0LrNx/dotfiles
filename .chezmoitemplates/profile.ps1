# Profil PowerShell — géré par chezmoi (même fichier pour Windows PowerShell 5, pwsh 7, macOS et Linux)
# Réglages propres à la machine : profile.local.ps1 à côté de ce fichier (non versionné)

$env:EDITOR = 'nvim'

# --- Confort de saisie (PSReadLine) -------------------------------------------
try {
    Set-PSReadLineOption -PredictionSource History -ErrorAction Stop
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
} catch { }

# --- Alias et fonctions -------------------------------------------------------
Set-Alias -Name v -Value nvim
Set-Alias -Name vim -Value nvim
Set-Alias -Name g -Value git

function .. { Set-Location .. }
function ... { Set-Location ../.. }
function gs { git status -sb @args }
function gd { git diff @args }
function gl { git log --oneline --graph --decorate -20 @args }
function cma { chezmoi apply @args }
function cme { chezmoi edit --apply @args }

if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ll { eza -lah --git --group-directories-first @args }
} else {
    function ll { Get-ChildItem -Force @args }
}

# --- Outils (chargés seulement s'ils sont installés) ---------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
}
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

$localProfile = Join-Path (Split-Path -Parent $PROFILE) 'profile.local.ps1'
if (Test-Path $localProfile) { . $localProfile }
