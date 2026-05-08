# Cree les 4 utilisateurs de test via l'API admin GoTrue (local Supabase)
# Usage : .\scripts\create_test_users.ps1
# Prerequis : supabase start doit etre lance

$baseUrl = "http://127.0.0.1:54321"

# Recupere la cle secrete depuis supabase status (evite de la hardcoder)
$statusOutput = & supabase status 2>&1 | Out-String
if ($statusOutput -match 'Secret\s+\|\s+(sb_secret_\S+)') {
    $serviceKey = $Matches[1]
} else {
    Write-Host "ERREUR : impossible de lire la cle secret depuis 'supabase status'." -ForegroundColor Red
    Write-Host "Verifie que 'supabase start' est lance depuis le dossier backend/." -ForegroundColor Yellow
    exit 1
}

$authHeaders = @{
    "Authorization" = "Bearer $serviceKey"
    "apikey"        = $serviceKey
    "Content-Type"  = "application/json"
}
$restHeaders = @{
    "Authorization" = "Bearer $serviceKey"
    "apikey"        = $serviceKey
    "Content-Type"  = "application/json"
    "Prefer"        = "return=minimal"
}

$users = @(
    @{ email = "admin@pastef.fr";   password = "Pastef2026!"; nom = "Ndiaye"; prenom = "Aminata"; role = "bureau_executif";          unite_id = "00000000-0000-0000-0000-000000000001" },
    @{ email = "coordo@pastef.fr";  password = "Pastef2026!"; nom = "Diallo"; prenom = "Moussa";  role = "coordinateur";             unite_id = "00000000-0000-0000-0000-000000000001" },
    @{ email = "paris@pastef.fr";   password = "Pastef2026!"; nom = "Sow";    prenom = "Fatou";   role = "responsable_sous_section"; unite_id = "00000000-0000-0000-0001-000000000075" },
    @{ email = "cellule@pastef.fr"; password = "Pastef2026!"; nom = "Ba";     prenom = "Rokhaya"; role = "coordinateur_cellule";     unite_id = "00000000-0000-0000-0004-000000007501" }
)

foreach ($u in $users) {
    Write-Host ""
    Write-Host "Creation : $($u.email)" -ForegroundColor Yellow

    $body = @{ email = $u.email; password = $u.password; email_confirm = $true } | ConvertTo-Json

    try {
        $created = Invoke-RestMethod `
            -Uri     "$baseUrl/auth/v1/admin/users" `
            -Method  POST `
            -Headers $authHeaders `
            -Body    $body

        $uid = $created.id
        Write-Host "  Auth OK -> $uid" -ForegroundColor Green

        $profile = @{ nom = $u.nom; prenom = $u.prenom; role = $u.role; unite_id = $u.unite_id } | ConvertTo-Json

        Invoke-RestMethod `
            -Uri     "$baseUrl/rest/v1/profiles?id=eq.$uid" `
            -Method  PATCH `
            -Headers $restHeaders `
            -Body    $profile | Out-Null

        Write-Host "  Profil OK -> $($u.nom) $($u.prenom) ($($u.role))" -ForegroundColor Cyan
    }
    catch {
        $msg = $_.ErrorDetails.Message
        if ($msg -match "already been registered") {
            Write-Host "  Deja existant - ignore" -ForegroundColor DarkYellow
        } else {
            Write-Host "  ERREUR : $msg" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "Termine. Connecte-toi avec : coordo@pastef.fr / Pastef2026!" -ForegroundColor White