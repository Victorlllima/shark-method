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

    METODO S.H.A.R.K. v4.0
"@ -ForegroundColor Cyan

Write-Host ""

$GeminiDir = "$env:USERPROFILE\.gemini"
$ClaudeDir  = "$env:USERPROFILE\.claude"
$RepoUrl    = "https://raw.githubusercontent.com/Victorlllima/shark-method/main"
$Username   = $env:USERNAME

function Invoke-FileDownload {
    param($Url, $Output)
    $retries = 3
    for ($i = 0; $i -lt $retries; $i++) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $Output -ErrorAction Stop
            return $true
        } catch {
            if ($i -eq $retries - 1) {
                Write-Host "    Falha ao baixar: $Url" -ForegroundColor Red
                return $false
            }
            Start-Sleep -Seconds 2
        }
    }
}

# ── ANTIGRAVITY NATIVO (~/.gemini) ─────────────────────────────────────────
Write-Host " [1/2] Instalando agentes Antigravity (~/.gemini)..." -ForegroundColor Yellow

New-Item -ItemType Directory -Force -Path "$GeminiDir\commands" | Out-Null
New-Item -ItemType Directory -Force -Path "$GeminiDir\agents"   | Out-Null
New-Item -ItemType Directory -Force -Path "$GeminiDir\scripts"  | Out-Null
New-Item -ItemType Directory -Force -Path "$GeminiDir\recipes"  | Out-Null

$GeminiMemory = "$GeminiDir\memory\$Username"
New-Item -ItemType Directory -Force -Path "$GeminiMemory\projects"     | Out-Null
New-Item -ItemType Directory -Force -Path "$GeminiMemory\interactions" | Out-Null

$GeminiUserData = "$GeminiMemory\user_data.json"
if (-not (Test-Path $GeminiUserData)) {
    @{ name = $Username; bio = ""; preferences = @{}; current_version = "4.0" } |
        ConvertTo-Json -Depth 3 | Out-File $GeminiUserData -Encoding UTF8
}

Invoke-FileDownload "$RepoUrl/config/GEMINI.md"                          "$GeminiDir\GEMINI.md"
Invoke-FileDownload "$RepoUrl/version.json"                              "$GeminiDir\version.json"
Invoke-FileDownload "$RepoUrl/commands/shark-commands.md"                "$GeminiDir\commands\shark-commands.md"
Invoke-FileDownload "$RepoUrl/commands/shark-help.md"                    "$GeminiDir\commands\shark-help.md"
Invoke-FileDownload "$RepoUrl/commands/shark-status.md"                  "$GeminiDir\commands\shark-status.md"
Invoke-FileDownload "$RepoUrl/commands/yolo.md"                          "$GeminiDir\commands\yolo.md"
Invoke-FileDownload "$RepoUrl/agents-antigravity/shiva.md"               "$GeminiDir\agents\shiva.md"
Invoke-FileDownload "$RepoUrl/agents-antigravity/hades.md"               "$GeminiDir\agents\hades.md"
Invoke-FileDownload "$RepoUrl/agents-antigravity/ravena.md"              "$GeminiDir\agents\ravena.md"
Invoke-FileDownload "$RepoUrl/agents-antigravity/kerberos.md"            "$GeminiDir\agents\kerberos.md"
Invoke-FileDownload "$RepoUrl/agents-antigravity/atlas.md"               "$GeminiDir\agents\atlas.md"
Invoke-FileDownload "$RepoUrl/scripts/shark-status.js"                   "$GeminiDir\scripts\shark-status.js"
Invoke-FileDownload "$RepoUrl/scripts/package.json"                      "$GeminiDir\scripts\package.json"
Invoke-FileDownload "$RepoUrl/docs/receitas/setup-local-docker.md"       "$GeminiDir\recipes\setup-local-docker.md"
Invoke-FileDownload "$RepoUrl/docs/receitas/setup-mcp-supabase.md"      "$GeminiDir\recipes\setup-mcp-supabase.md"
Invoke-FileDownload "$RepoUrl/docs/receitas/setup-mcp-github.md"        "$GeminiDir\recipes\setup-mcp-github.md"

Write-Host "    Antigravity OK" -ForegroundColor Green

# ── CLAUDE CODE EXTENSION (~/.claude) ──────────────────────────────────────
Write-Host " [2/2] Instalando agentes Claude Code (~/.claude)..." -ForegroundColor Yellow

New-Item -ItemType Directory -Force -Path "$ClaudeDir\agents" | Out-Null

$ClaudeMemory = "$ClaudeDir\memory\$Username"
New-Item -ItemType Directory -Force -Path "$ClaudeMemory\projects"     | Out-Null
New-Item -ItemType Directory -Force -Path "$ClaudeMemory\interactions" | Out-Null

$ClaudeUserData = "$ClaudeMemory\user_data.json"
if (-not (Test-Path $ClaudeUserData)) {
    @{ name = $Username; bio = ""; preferences = @{}; current_version = "4.0" } |
        ConvertTo-Json -Depth 3 | Out-File $ClaudeUserData -Encoding UTF8
}

Invoke-FileDownload "$RepoUrl/config/CLAUDE.md"              "$ClaudeDir\CLAUDE.md"
Invoke-FileDownload "$RepoUrl/agents-claude/shiva.md"        "$ClaudeDir\agents\shiva.md"
Invoke-FileDownload "$RepoUrl/agents-claude/hades.md"        "$ClaudeDir\agents\hades.md"
Invoke-FileDownload "$RepoUrl/agents-claude/ravena.md"       "$ClaudeDir\agents\ravena.md"
Invoke-FileDownload "$RepoUrl/agents-claude/kerberos.md"     "$ClaudeDir\agents\kerberos.md"
Invoke-FileDownload "$RepoUrl/agents-claude/atlas.md"        "$ClaudeDir\agents\atlas.md"

Write-Host "    Claude Code OK" -ForegroundColor Green

# ── CONCLUIDO ───────────────────────────────────────────────────────────────
Write-Host ""
Write-Host " Instalacao concluida!" -ForegroundColor Green
Write-Host ""
Write-Host "   Antigravity nativo : $GeminiDir" -ForegroundColor Cyan
Write-Host "   Claude Code ext.   : $ClaudeDir" -ForegroundColor Cyan
Write-Host ""
Write-Host " TESTAR AGORA:" -ForegroundColor Yellow
Write-Host "   1. Abra o Google Antigravity"
Write-Host "   2. Chame qualquer agente: 'Shiva, o que voce faz?'"
Write-Host "   3. Se ela responder com [SHIVA]: — FUNCIONOU!"
Write-Host ""
