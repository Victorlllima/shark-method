# ========================================
#  SHARK RENAME - Personalizar seu Nome
#  Método S.H.A.R.K. v3.0
# ========================================

Clear-Host
Write-Host @"

   _____ __  _____    ____  __ __
  / ___// / / /   |  / __ \/ //_/
  \__ \/ /_/ / /| | / /_/ / ,<
 ___/ / __  / ___ |/ _, _/ /| |
/____/_/ /_/_/  |_/_/ |_/_/ |_|

    SHARK RENAME - Personalizar Nome

"@ -ForegroundColor Cyan

# ── Detectar qual AI está instalada ──────────────────────────────
$GeminiDir = "$env:USERPROFILE\.gemini"
$ClaudeDir  = "$env:USERPROFILE\.claude"

$HasGemini = Test-Path "$GeminiDir\GEMINI.md"
$HasClaude  = Test-Path "$ClaudeDir\CLAUDE.md"

if (-not $HasGemini -and -not $HasClaude) {
    Write-Host " Método S.H.A.R.K. não encontrado." -ForegroundColor Red
    Write-Host " Execute o instalador primeiro." -ForegroundColor Yellow
    exit 1
}

# ── Perguntar o nome desejado ─────────────────────────────────────
Write-Host ""
Write-Host " Ola! A Shiva vai te chamar pelo nome que VOCE escolher." -ForegroundColor Green
Write-Host ""
$NomeDesejado = Read-Host " Qual nome voce quer usar com os agentes?"
$NomeDesejado = $NomeDesejado.Trim()

if ([string]::IsNullOrEmpty($NomeDesejado)) {
    Write-Host " Nenhum nome digitado. Operacao cancelada." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host " Confirmacao: os agentes vao te chamar de '$NomeDesejado'" -ForegroundColor Cyan
$Confirm = Read-Host " Confirmar? (s/n)"

if ($Confirm -notmatch '^[sS]') {
    Write-Host " Operacao cancelada." -ForegroundColor Yellow
    exit 0
}

# ── Atualizar user_data.json (Gemini) ────────────────────────────
if ($HasGemini) {
    $MemoryDir = "$GeminiDir\memory"

    # Busca o user_data.json em qualquer subpasta de memory
    $UserDataFiles = Get-ChildItem -Path $MemoryDir -Filter "user_data.json" -Recurse -ErrorAction SilentlyContinue

    if ($UserDataFiles.Count -eq 0) {
        # Criar se não existir
        $UserFolder = "$MemoryDir\$env:USERNAME"
        New-Item -ItemType Directory -Force -Path $UserFolder | Out-Null
        $UserDataPath = "$UserFolder\user_data.json"
        $NewData = @{
            name               = $NomeDesejado
            bio                = ""
            preferences        = @{}
            current_version    = "3.0"
            last_update_check  = (Get-Date -Format "yyyy-MM-dd")
        } | ConvertTo-Json -Depth 3
        $NewData | Out-File $UserDataPath -Encoding UTF8
        Write-Host " [Gemini] Perfil criado com nome '$NomeDesejado'" -ForegroundColor Green
    } else {
        foreach ($File in $UserDataFiles) {
            $Data = Get-Content $File.FullName -Raw | ConvertFrom-Json
            $NomeAntigo = $Data.name
            $Data.name = $NomeDesejado
            $Data | ConvertTo-Json -Depth 3 | Set-Content $File.FullName -Encoding UTF8
            Write-Host " [Gemini] '$NomeAntigo' substituido por '$NomeDesejado' em $($File.FullName)" -ForegroundColor Green
        }
    }
}

# ── Atualizar user_data.json (Claude) ────────────────────────────
if ($HasClaude) {
    $ClaudeMemoryDir = "$ClaudeDir\memory"
    New-Item -ItemType Directory -Force -Path $ClaudeMemoryDir | Out-Null

    $ClaudeUserDataFiles = Get-ChildItem -Path $ClaudeMemoryDir -Filter "user_data.json" -Recurse -ErrorAction SilentlyContinue

    if ($ClaudeUserDataFiles.Count -eq 0) {
        $UserDataPath = "$ClaudeMemoryDir\user_data.json"
        $NewData = @{
            name               = $NomeDesejado
            bio                = ""
            preferences        = @{}
            current_version    = "3.0"
            last_update_check  = (Get-Date -Format "yyyy-MM-dd")
        } | ConvertTo-Json -Depth 3
        $NewData | Out-File $UserDataPath -Encoding UTF8
        Write-Host " [Claude] Perfil criado com nome '$NomeDesejado'" -ForegroundColor Green
    } else {
        foreach ($File in $ClaudeUserDataFiles) {
            $Data = Get-Content $File.FullName -Raw | ConvertFrom-Json
            $NomeAntigo = $Data.name
            $Data.name = $NomeDesejado
            $Data | ConvertTo-Json -Depth 3 | Set-Content $File.FullName -Encoding UTF8
            Write-Host " [Claude] '$NomeAntigo' substituido por '$NomeDesejado' em $($File.FullName)" -ForegroundColor Green
        }
    }
}

# ── Resultado ────────────────────────────────────────────────────
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PRONTO! Nome atualizado com sucesso!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Os agentes vao te chamar de: $NomeDesejado" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Reinicie o Gemini/Claude Code para aplicar." -ForegroundColor White
Write-Host ""
