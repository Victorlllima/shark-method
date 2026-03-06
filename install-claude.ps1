# ========================================
#  INSTALADOR DO MÉTODO S.H.A.R.K.
# Versão 3.0 - Claude Code Edition
# ========================================

Clear-Host
Write-Host @"
   _____ __  _____    ____  __ __
  / ___// / / /   |  / __ \/ //_/
  \__ \/ /_/ / /| | / /_/ / ,<
 ___/ / __  / ___ |/ _, _/ /| |
/____/_/ /_/_/  |_/_/ |_/_/ |_|

    MÉTODO S.H.A.R.K. v3.0
    Claude Code Edition
"@ -ForegroundColor Cyan

Write-Host ""

$InstallDir = "$env:USERPROFILE\.claude"
$RepoUrl = "https://raw.githubusercontent.com/Victorlllima/shark-method/main"

Write-Host " Criando estrutura..." -ForegroundColor Yellow

New-Item -ItemType Directory -Force -Path "$InstallDir\agents" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\commands" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\scripts" | Out-Null

# Criar estrutura de memória do usuário
$Username = $env:USERNAME
$MemoryDir = "$InstallDir\memory\$Username"
New-Item -ItemType Directory -Force -Path "$MemoryDir\projects" | Out-Null
New-Item -ItemType Directory -Force -Path "$MemoryDir\interactions" | Out-Null

$UserDataPath = "$MemoryDir\user_data.json"
if (-not (Test-Path $UserDataPath)) {
    $UserData = @{
        name = $Username
        bio = ""
        preferences = @{}
        current_version = "3.0"
        last_update_check = (Get-Date -Format "yyyy-MM-dd")
    } | ConvertTo-Json -Depth 3
    $UserData | Out-File $UserDataPath -Encoding UTF8
}

Write-Host " Baixando agentes S.H.A.R.K. (versão Claude Code)..." -ForegroundColor Yellow

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

Download-File "$RepoUrl/agents-claude/shiva.md" "$InstallDir\agents\shiva.md"
Download-File "$RepoUrl/agents-claude/hades.md" "$InstallDir\agents\hades.md"
Download-File "$RepoUrl/agents-claude/atlas.md" "$InstallDir\agents\atlas.md"
Download-File "$RepoUrl/agents-claude/ravena.md" "$InstallDir\agents\ravena.md"
Download-File "$RepoUrl/agents-claude/kerberos.md" "$InstallDir\agents\kerberos.md"

Write-Host " Baixando comandos..." -ForegroundColor Yellow

Download-File "$RepoUrl/commands/shark-commands.md" "$InstallDir\commands\shark-commands.md"
Download-File "$RepoUrl/commands/shark-help.md" "$InstallDir\commands\shark-help.md"
Download-File "$RepoUrl/commands/shark-status.md" "$InstallDir\commands\shark-status.md"
Download-File "$RepoUrl/commands/shark-version.md" "$InstallDir\commands\shark-version.md"
Download-File "$RepoUrl/commands/shark-doctor.md" "$InstallDir\commands\shark-doctor.md"

# Instalar CLAUDE.md apenas se não existir
$ClaudeMdPath = "$InstallDir\CLAUDE.md"
if (-not (Test-Path $ClaudeMdPath)) {
    Write-Host " Instalando configuração global..." -ForegroundColor Yellow
    Download-File "$RepoUrl/config/CLAUDE.md" "$ClaudeMdPath"
    Write-Host " CLAUDE.md instalado." -ForegroundColor Green
} else {
    Write-Host " CLAUDE.md já existe — não sobrescrevendo." -ForegroundColor Yellow
    Write-Host " Para atualizar: baixe manualmente de $RepoUrl/config/CLAUDE.md" -ForegroundColor Yellow
}

Write-Host ""
Write-Host " Instalação concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "    MÉTODO S.H.A.R.K. v3.0 — CLAUDE CODE EDITION INSTALADO!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host " Instalado em: $InstallDir" -ForegroundColor Yellow
Write-Host ""
Write-Host " TESTAR AGORA:" -ForegroundColor Yellow
Write-Host "   1. Abra o Claude Code (VS Code, Cursor, terminal)"
Write-Host "   2. Digite: shiva"
Write-Host "   3. A Shiva vai se apresentar como arquiteta de produto"
Write-Host "   4. Se funcionar, está pronto!"
Write-Host ""
Write-Host " Para atualizar depois: shark update" -ForegroundColor Yellow
Write-Host ""
