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

Write-Host " Baixando skills..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$InstallDir\skills\yolo" | Out-Null
Download-File "$RepoUrl/skills/yolo/SKILL.md" "$InstallDir\skills\yolo\SKILL.md"

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

# ========================================
#  CONFIGURAÇÃO DO ANTIGRAVITY IDE
# ========================================

$AntigravityCmd = Get-Command antigravity -ErrorAction SilentlyContinue

if ($AntigravityCmd) {
    Write-Host " Antigravity detectado — configurando extensões..." -ForegroundColor Yellow

    # Verificar se Claude Code está instalado
    $ccInstalled = & antigravity --list-extensions 2>$null | Select-String "anthropic.claude"
    if (-not $ccInstalled) {
        Write-Host "   Instalando extensão Claude Code..." -ForegroundColor Yellow
        & antigravity --install-extension anthropic.claude-code 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   Claude Code instalado." -ForegroundColor Green
        } else {
            Write-Host "   Falha ao instalar Claude Code. Instale manualmente no Antigravity." -ForegroundColor Red
        }
    } else {
        Write-Host "   Claude Code já instalado." -ForegroundColor Green
    }

    # Instalar auto-run-command
    $arcInstalled = & antigravity --list-extensions 2>$null | Select-String "synedra.auto-run-command"
    if (-not $arcInstalled) {
        Write-Host "   Instalando extensão auto-run-command..." -ForegroundColor Yellow
        & antigravity --install-extension synedra.auto-run-command 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   auto-run-command instalado." -ForegroundColor Green
        } else {
            Write-Host "   Falha ao instalar auto-run-command. Instale manualmente no Antigravity." -ForegroundColor Red
        }
    } else {
        Write-Host "   auto-run-command já instalado." -ForegroundColor Green
    }

    # Configurar settings.json do Antigravity
    $AgSettingsPath = "$env:APPDATA\Antigravity\User\settings.json"
    if (Test-Path $AgSettingsPath) {
        $settings = Get-Content $AgSettingsPath -Raw | ConvertFrom-Json
    } else {
        New-Item -ItemType Directory -Force -Path "$env:APPDATA\Antigravity\User" | Out-Null
        $settings = [PSCustomObject]@{}
    }

    # Adicionar regra de auto-open do Claude Code se não existir
    if (-not ($settings.PSObject.Properties.Name -contains "auto-run-command.rules")) {
        $settings | Add-Member -NotePropertyName "auto-run-command.rules" -NotePropertyValue @(
            [PSCustomObject]@{
                condition = "always"
                command   = "claude-vscode.editor.open"
            }
        )
        $settings | ConvertTo-Json -Depth 10 | Out-File $AgSettingsPath -Encoding UTF8
        Write-Host "   Auto-open do Claude Code configurado." -ForegroundColor Green
    } else {
        Write-Host "   Configuração de auto-open já existe." -ForegroundColor Green
    }

} else {
    Write-Host " Antigravity não encontrado no PATH — pulando configuração da IDE." -ForegroundColor Yellow
    Write-Host "   Instale o Antigravity e rode o instalador novamente, ou configure manualmente." -ForegroundColor Yellow
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
Write-Host "   1. Abra o Antigravity IDE"
Write-Host "   2. O Claude Code abrirá automaticamente"
Write-Host "   3. Digite: shiva"
Write-Host "   4. A Shiva vai se apresentar como arquiteta de produto"
Write-Host ""
Write-Host " Para atualizar depois: shark update" -ForegroundColor Yellow
Write-Host ""
