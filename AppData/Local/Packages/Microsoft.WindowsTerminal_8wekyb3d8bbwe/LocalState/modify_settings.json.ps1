# Fusionne nos réglages dans le settings.json de Windows Terminal sans écraser le reste
# (profils générés, réglages faits dans l'interface). chezmoi envoie le fichier actuel sur stdin.
$raw = ($input | Out-String)
$raw = ($raw -split "`n" | Where-Object { $_ -notmatch '^\s*//' }) -join "`n"
$s = if ($raw.Trim()) { $raw | ConvertFrom-Json } else { [pscustomobject]@{} }

function Set-Prop($obj, $name, $value) {
    if ($obj.PSObject.Properties[$name]) { $obj.$name = $value }
    else { $obj | Add-Member -NotePropertyName $name -NotePropertyValue $value }
}

# PowerShell 7 : GUID stable défini par Windows Terminal
Set-Prop $s 'defaultProfile' '{574e775e-4f2a-5b96-ac1e-a2962a402336}'
Set-Prop $s 'theme' 'system'
Set-Prop $s 'copyOnSelect' $true

if (-not $s.PSObject.Properties['profiles']) { Set-Prop $s 'profiles' ([pscustomobject]@{}) }
if (-not $s.profiles.PSObject.Properties['defaults']) { Set-Prop $s.profiles 'defaults' ([pscustomobject]@{}) }
Set-Prop $s.profiles.defaults 'font' ([pscustomobject]@{ face = 'JetBrainsMono Nerd Font'; size = 12 })

$s | ConvertTo-Json -Depth 20
