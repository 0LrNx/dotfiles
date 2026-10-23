# Complète le settings.json de Windows Terminal sans rien écraser : une valeur déjà présente
# (police, profil par défaut…) est conservée. chezmoi envoie le fichier actuel sur stdin.
$raw = ($input | Out-String)
$raw = ($raw -split "`n" | Where-Object { $_ -notmatch '^\s*//' }) -join "`n"
$s = if ($raw.Trim()) { $raw | ConvertFrom-Json } else { [pscustomobject]@{} }

function Set-IfAbsent($obj, $name, $value) {
    if (-not $obj.PSObject.Properties[$name]) { $obj | Add-Member -NotePropertyName $name -NotePropertyValue $value }
}

# PowerShell 7 : GUID stable défini par Windows Terminal
Set-IfAbsent $s 'defaultProfile' '{574e775e-4f2a-5b96-ac1e-a2962a402336}'
Set-IfAbsent $s 'theme' 'system'
Set-IfAbsent $s 'copyOnSelect' $true

Set-IfAbsent $s 'profiles' ([pscustomobject]@{})
Set-IfAbsent $s.profiles 'defaults' ([pscustomobject]@{})
Set-IfAbsent $s.profiles.defaults 'font' ([pscustomobject]@{ face = 'JetBrainsMono Nerd Font'; size = 12 })

$s | ConvertTo-Json -Depth 20
