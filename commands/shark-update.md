# SHARK UPDATE — Atualização do Método S.H.A.R.K.

## PROTOCOLO DE ATUALIZAÇÃO

Você deve detectar qual plataforma está instalada e atualizar os arquivos correspondentes.

### **Passo 1: Identificar Agente**
Diga: `[ATLAS]: Iniciando atualização do Método S.H.A.R.K...`

### **Passo 2: Detectar plataformas instaladas**

Execute para verificar quais plataformas estão presentes:

**Windows (PowerShell):**
```powershell
$hasGemini = Test-Path "$env:USERPROFILE\.gemini\GEMINI.md"
$hasClaude = Test-Path "$env:USERPROFILE\.claude\CLAUDE.md"
Write-Host "Antigravity: $hasGemini | Claude Code: $hasClaude"
```

**Mac/Linux (bash):**
```bash
hasGemini=false; hasClaude=false
[ -f "$HOME/.gemini/GEMINI.md" ] && hasGemini=true
[ -f "$HOME/.claude/CLAUDE.md" ] && hasClaude=true
echo "Antigravity: $hasGemini | Claude Code: $hasClaude"
```

---

### **Passo 3: Atualizar Antigravity (se instalado)**

**Windows (PowerShell):**
```powershell
$InstallDir = "$env:USERPROFILE\.gemini"
$RepoUrl = "https://raw.githubusercontent.com/Victorlllima/shark-method/main"

function Download-File {
    param($Url, $Output)
    $maxRetries = 3; $retryCount = 0
    while ($retryCount -lt $maxRetries) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $Output -ErrorAction Stop
            return $true
        } catch {
            $retryCount++
            if ($retryCount -eq $maxRetries) {
                Write-Host "  Falha: $Output" -ForegroundColor Red
                return $false
            }
            Start-Sleep -Seconds 2
        }
    }
}

New-Item -ItemType Directory -Force -Path "$InstallDir\commands" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\agents" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\scripts" | Out-Null

Download-File "$RepoUrl/config/GEMINI.md" "$InstallDir\GEMINI.md"
Download-File "$RepoUrl/version.json" "$InstallDir\version.json"
Download-File "$RepoUrl/commands/shark-commands.md" "$InstallDir\commands\shark-commands.md"
Download-File "$RepoUrl/commands/shark-help.md" "$InstallDir\commands\shark-help.md"
Download-File "$RepoUrl/commands/shark-status.md" "$InstallDir\commands\shark-status.md"
Download-File "$RepoUrl/commands/yolo.md" "$InstallDir\commands\yolo.md"
Download-File "$RepoUrl/agents-antigravity/shiva.md" "$InstallDir\agents\shiva.md"
Download-File "$RepoUrl/agents-antigravity/hades.md" "$InstallDir\agents\hades.md"
Download-File "$RepoUrl/agents-antigravity/ravena.md" "$InstallDir\agents\ravena.md"
Download-File "$RepoUrl/agents-antigravity/kerberos.md" "$InstallDir\agents\kerberos.md"
Download-File "$RepoUrl/agents-antigravity/atlas.md" "$InstallDir\agents\atlas.md"
Download-File "$RepoUrl/scripts/shark-status.js" "$InstallDir\scripts\shark-status.js"
Download-File "$RepoUrl/scripts/package.json" "$InstallDir\scripts\package.json"
Download-File "$RepoUrl/scripts/shark-rename.ps1" "$InstallDir\scripts\shark-rename.ps1"
Download-File "$RepoUrl/scripts/shark-rename.sh" "$InstallDir\scripts\shark-rename.sh"

Write-Host "Antigravity atualizado." -ForegroundColor Green
```

**Mac/Linux (bash):**
```bash
INSTALL_DIR="$HOME/.gemini"
REPO_URL="https://raw.githubusercontent.com/Victorlllima/shark-method/main"

download_file() {
    local url=$1; local output=$2
    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$output"
    else
        wget -q "$url" -O "$output"
    fi
}

mkdir -p "$INSTALL_DIR/commands" "$INSTALL_DIR/agents" "$INSTALL_DIR/scripts"

download_file "$REPO_URL/config/GEMINI.md" "$INSTALL_DIR/GEMINI.md"
download_file "$REPO_URL/version.json" "$INSTALL_DIR/version.json"
download_file "$REPO_URL/commands/shark-commands.md" "$INSTALL_DIR/commands/shark-commands.md"
download_file "$REPO_URL/commands/shark-help.md" "$INSTALL_DIR/commands/shark-help.md"
download_file "$REPO_URL/commands/shark-status.md" "$INSTALL_DIR/commands/shark-status.md"
download_file "$REPO_URL/commands/yolo.md" "$INSTALL_DIR/commands/yolo.md"
download_file "$REPO_URL/agents-antigravity/shiva.md" "$INSTALL_DIR/agents/shiva.md"
download_file "$REPO_URL/agents-antigravity/hades.md" "$INSTALL_DIR/agents/hades.md"
download_file "$REPO_URL/agents-antigravity/ravena.md" "$INSTALL_DIR/agents/ravena.md"
download_file "$REPO_URL/agents-antigravity/kerberos.md" "$INSTALL_DIR/agents/kerberos.md"
download_file "$REPO_URL/agents-antigravity/atlas.md" "$INSTALL_DIR/agents/atlas.md"
download_file "$REPO_URL/scripts/shark-status.js" "$INSTALL_DIR/scripts/shark-status.js"
download_file "$REPO_URL/scripts/package.json" "$INSTALL_DIR/scripts/package.json"
download_file "$REPO_URL/scripts/shark-rename.ps1" "$INSTALL_DIR/scripts/shark-rename.ps1"
download_file "$REPO_URL/scripts/shark-rename.sh" "$INSTALL_DIR/scripts/shark-rename.sh"

echo "Antigravity atualizado."
```

---

### **Passo 4: Atualizar Claude Code (se instalado)**

**Windows (PowerShell):**
```powershell
$InstallDir = "$env:USERPROFILE\.claude"
$RepoUrl = "https://raw.githubusercontent.com/Victorlllima/shark-method/main"

New-Item -ItemType Directory -Force -Path "$InstallDir\agents" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\commands" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\scripts" | Out-Null
New-Item -ItemType Directory -Force -Path "$InstallDir\skills\yolo" | Out-Null

Download-File "$RepoUrl/agents-claude/shiva.md" "$InstallDir\agents\shiva.md"
Download-File "$RepoUrl/agents-claude/hades.md" "$InstallDir\agents\hades.md"
Download-File "$RepoUrl/agents-claude/atlas.md" "$InstallDir\agents\atlas.md"
Download-File "$RepoUrl/agents-claude/ravena.md" "$InstallDir\agents\ravena.md"
Download-File "$RepoUrl/agents-claude/kerberos.md" "$InstallDir\agents\kerberos.md"
Download-File "$RepoUrl/commands/shark-commands.md" "$InstallDir\commands\shark-commands.md"
Download-File "$RepoUrl/commands/shark-help.md" "$InstallDir\commands\shark-help.md"
Download-File "$RepoUrl/commands/shark-status.md" "$InstallDir\commands\shark-status.md"
Download-File "$RepoUrl/commands/shark-version.md" "$InstallDir\commands\shark-version.md"
Download-File "$RepoUrl/commands/shark-doctor.md" "$InstallDir\commands\shark-doctor.md"
Download-File "$RepoUrl/skills/yolo/SKILL.md" "$InstallDir\skills\yolo\SKILL.md"

Write-Host "Claude Code atualizado." -ForegroundColor Green
```

**Mac/Linux (bash):**
```bash
INSTALL_DIR="$HOME/.claude"
REPO_URL="https://raw.githubusercontent.com/Victorlllima/shark-method/main"

mkdir -p "$INSTALL_DIR/agents" "$INSTALL_DIR/commands" "$INSTALL_DIR/scripts" "$INSTALL_DIR/skills/yolo"

download_file "$REPO_URL/agents-claude/shiva.md" "$INSTALL_DIR/agents/shiva.md"
download_file "$REPO_URL/agents-claude/hades.md" "$INSTALL_DIR/agents/hades.md"
download_file "$REPO_URL/agents-claude/atlas.md" "$INSTALL_DIR/agents/atlas.md"
download_file "$REPO_URL/agents-claude/ravena.md" "$INSTALL_DIR/agents/ravena.md"
download_file "$REPO_URL/agents-claude/kerberos.md" "$INSTALL_DIR/agents/kerberos.md"
download_file "$REPO_URL/commands/shark-commands.md" "$INSTALL_DIR/commands/shark-commands.md"
download_file "$REPO_URL/commands/shark-help.md" "$INSTALL_DIR/commands/shark-help.md"
download_file "$REPO_URL/commands/shark-status.md" "$INSTALL_DIR/commands/shark-status.md"
download_file "$REPO_URL/commands/shark-version.md" "$INSTALL_DIR/commands/shark-version.md"
download_file "$REPO_URL/commands/shark-doctor.md" "$INSTALL_DIR/commands/shark-doctor.md"
download_file "$REPO_URL/skills/yolo/SKILL.md" "$INSTALL_DIR/skills/yolo/SKILL.md"

echo "Claude Code atualizado."
```

---

### **Passo 5: Finalização**

Após a conclusão, informe:
`[ATLAS]: Método S.H.A.R.K. atualizado. Plataformas atualizadas: [listar quais]. Novos arquivos incluídos: yolo, shark-doctor, shark-version.`

Se nenhuma plataforma for detectada:
`[ATLAS]: Nenhuma instalação encontrada. Para instalar, acesse: https://github.com/Victorlllima/shark-method`
