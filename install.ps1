# ========================================
#  INSTALADOR DO MÉTODO S.H.A.R.K.
# Versão 2.0 - Instalação Global
# ========================================

Clear-Host
Write-Host @"
   _____ __  _____    ____  __ __
  / ___// / / /   |  / __ \/ //_/
  \__ \/ /_/ / /| | / /_/ / ,<   
 ___/ / __  / ___ |/ _, _/ /| |  
/____/_/ /_/_/  |_/_/ |_/_/ |_|  
                                  
    MÉTODO S.H.A.R.K. v2.0
"@ -ForegroundColor Cyan

Write-Host ""

$InstallDir = "$env:USERPROFILE\.gemini"
$RepoUrl = "https://raw.githubusercontent.com/Victorlllima/shark-method/main"

Write-Host " Criando estrutura..." -ForegroundColor Yellow

New-Item -ItemType Directory -Force -Path "$InstallDir\commands" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\agents" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\scripts" | Out-Null

Write-Host " Baixando arquivos..." -ForegroundColor Yellow

function Download-File {
    param($Url, $Output)
    $maxRetries = 3
    $retryCount = 0
    
    while ($retryCount -lt $maxRetries) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $Output -ErrorAction Stop
            return $true
        }
        catch {
            $retryCount++
            if ($retryCount -eq $maxRetries) {
                Write-Host "    Falha ao baixar: $Url" -ForegroundColor Red
                return $false
            }
            Start-Sleep -Seconds 2
        }
    }
}

Download-File "$RepoUrl/config/GEMINI.md" "$InstallDir\GEMINI.md"
Download-File "$RepoUrl/commands/shark-commands.md" "$InstallDir\commands\shark-commands.md"
Download-File "$RepoUrl/commands/shark-help.md" "$InstallDir\commands\shark-help.md"
Download-File "$RepoUrl/commands/shark-status.md" "$InstallDir\commands\shark-status.md"
Download-File "$RepoUrl/agents/shiva.md" "$InstallDir\agents\shiva.md"
Download-File "$RepoUrl/agents/hades.md" "$InstallDir\agents\hades.md"
Download-File "$RepoUrl/agents/ravena.md" "$InstallDir\agents\ravena.md"
Download-File "$RepoUrl/agents/kerberos.md" "$InstallDir\agents\kerberos.md"
Download-File "$RepoUrl/agents/atlas.md" "$InstallDir\agents\atlas.md"
Download-File "$RepoUrl/scripts/shark-status.js" "$InstallDir\scripts\shark-status.js"
Download-File "$RepoUrl/scripts/package.json" "$InstallDir\scripts\package.json"

Write-Host ""
Write-Host " Instalação concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "" -ForegroundColor Cyan
Write-Host "    MÉTODO S.H.A.R.K. INSTALADO!" -ForegroundColor Green
Write-Host "" -ForegroundColor Cyan
Write-Host ""
Write-Host " Instalado em: $InstallDir" -ForegroundColor Yellow
Write-Host ""
Write-Host " TESTAR AGORA:" -ForegroundColor Yellow
Write-Host "   1. Abra o Google Antigravity"
Write-Host "   2. Digite: shark ajuda"
Write-Host "   3. Se aparecer a ajuda, FUNCIONOU! "
Write-Host ""
