function New-Password {
    param(
        [int]$Length = 12,
        [switch]$Uppercase,
        [switch]$Lowercase,
        [switch]$Numbers,
        [switch]$SpecialChars
    )

    $chars = ""

    if ($Uppercase -or (!$Uppercase -and !$Lowercase -and !$Numbers -and !$SpecialChars)) {
        $chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    }
    if ($Lowercase -or (!$Uppercase -and !$Lowercase -and !$Numbers -and !$SpecialChars)) {
        $chars += "abcdefghijklmnopqrstuvwxyz"
    }
    if ($Numbers -or (!$Uppercase -and !$Lowercase -and !$Numbers -and !$SpecialChars)) {
        $chars += "0123456789"
    }
    if ($SpecialChars -or (!$Uppercase -and !$Lowercase -and !$Numbers -and !$SpecialChars)) {
        $chars += "!@#$%^&*()_+-=[]{}|;:,.<>?"
    }

    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $password = ""
    $charArray = $chars.ToCharArray()

    for ($i = 0; $i -lt $Length; $i++) {
        $randomByte = New-Object byte[] 1
        $rng.GetBytes($randomByte)
        $index = $randomByte[0] % $charArray.Length
        $password += $charArray[$index]
    }

    return $password
}

function Test-PasswordStrength {
    param(
        [string]$Password
    )

    $score = 0

    if ($Password.Length -ge 12) {
        $score += 2
    }

    if ($Password -match "[A-Z]") {
        $score += 1
    }

    if ($Password -match "[a-z]") {
        $score += 1
    }

    if ($Password -match "[0-9]") {
        $score += 1
    }

    if ($Password -match "[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]") {
        $score += 2
    }

    $charArray = $Password.ToCharArray()
    $hasDuplicate = $false
    for ($i = 0; $i -lt $charArray.Length - 1; $i++) {
        if ($charArray[$i] -eq $charArray[$i + 1]) {
            $hasDuplicate = $true
            break
        }
    }
    if ($hasDuplicate) {
        $score -= 1
    }

    $level = ""
    if ($score -le 2) {
        $level = "Weak"
    } elseif ($score -le 4) {
        $level = "Medium"
    } elseif ($score -le 6) {
        $level = "Strong"
    } else {
        $level = "Very Strong"
    }

    Write-Host "Password: $Password"
    Write-Host "Score: $score"
    Write-Host "Level: $level"

    return $level
}

function New-PasswordList {
    param(
        [string]$UserFile,
        [int]$Length = 12
    )

    $users = Get-Content $UserFile
    $results = @()

    foreach ($user in $users) {
        $pwd = New-Password -Length $Length
        $strength = Test-PasswordStrength -Password $pwd
        $obj = [PSCustomObject]@{
            User = $user
            Password = $pwd
            Strength = $strength
        }
        $results += $obj
    }

    $results | Format-Table -AutoSize
    return $results
}

function Export-Passwords {
    param(
        [string]$Path,
        [array]$Data
    )

    if ($Data -eq $null -or $Data.Count -eq 0) {
        Write-Host "Pas de donnees a exporter"
        return
    }

    $Data | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8
    Write-Host "Export fait dans $Path"
}

function Save-SecurePassword {
    param(
        [string]$User,
        [string]$Password
    )

    $securePwd = ConvertTo-SecureString $Password -AsPlainText -Force
    $encrypted = ConvertFrom-SecureString $securePwd

    $vaultFile = "vault.txt"
    $line = "$User;$encrypted"
    Add-Content -Path $vaultFile -Value $line
    Write-Host "Mot de passe de $User sauvegarde"
}

function Show-Menu {
    Write-Host ""
    Write-Host "=== Gestionnaire de mots de passe ==="
    Write-Host "1 - Generer un mot de passe"
    Write-Host "2 - Tester la force d'un mot de passe"
    Write-Host "3 - Generer une liste de mots de passe"
    Write-Host "4 - Exporter les mots de passe"
    Write-Host "5 - Sauvegarder au coffre-fort"
    Write-Host "6 - Quitter"
    Write-Host ""
}

$lastPasswordList = @()

do {
    Show-Menu
    $choice = Read-Host "Votre choix"

    switch ($choice) {
        "1" {
            $len = Read-Host "Longueur du mot de passe (defaut 12)"
            if ($len -eq "") { $len = 12 }
            $pwd = New-Password -Length ([int]$len)
            Write-Host "Mot de passe genere : $pwd"
        }
        "2" {
            $pwd = Read-Host "Entrez le mot de passe a tester"
            Test-PasswordStrength -Password $pwd
        }
        "3" {
            $file = Read-Host "Chemin du fichier utilisateurs"
            $len = Read-Host "Longueur des mots de passe (defaut 12)"
            if ($len -eq "") { $len = 12 }
            $lastPasswordList = New-PasswordList -UserFile $file -Length ([int]$len)
        }
        "4" {
            $path = Read-Host "Chemin du fichier CSV de sortie"
            Export-Passwords -Path $path -Data $lastPasswordList
        }
        "5" {
            $user = Read-Host "Nom d'utilisateur"
            $pwd = Read-Host "Mot de passe"
            Save-SecurePassword -User $user -Password $pwd
        }
        "6" {
            Write-Host "Au revoir"
        }
        default {
            Write-Host "Choix invalide"
        }
    }

} while ($choice -ne "6")