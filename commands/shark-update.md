# 📥 SHARK UPDATE - Sincronização de Conhecimento

## PROTOCOLO DE ATUALIZAÇÃO

Você deve atualizar os arquivos do Método S.H.A.R.K. instalados na máquina do usuário para a versão mais recente do repositório oficial.

### **Passo 1: Identificar Agente**
Diga: `[ATLAS]: Iniciando atualização do ecossistema S.H.A.R.K...`

### **Passo 2: Execução Técnica**
Use o `run_command` para executar o seguinte script PowerShell (Windows):

```powershell
$InstallDir = "$env:USERPROFILE\.gemini"
$RepoUrl = "https://raw.githubusercontent.com/Victorlllima/shark-method/main"

Write-Host "📡 Conectando ao repositório central..." -ForegroundColor Cyan

# Lista de arquivos para atualizar
$Files = @(
    "config/GEMINI.md|GEMINI.md",
    "version.json|version.json",
    "commands/shark-commands.md|commands/shark-commands.md",
    "commands/shark-help.md|commands/shark-help.md",
    "commands/shark-status.md|commands/shark-status.md",
    "agents/shiva.md|agents/shiva.md",
    "agents/hades.md|agents/hades.md",
    "agents/ravena.md|agents/ravena.md",
    "agents/kerberos.md|agents/kerberos.md",
    "agents/atlas.md|agents/atlas.md",
    "scripts/shark-status.js|scripts/shark-status.js",
    "scripts/package.json|scripts/package.json",
    "docs/receitas/setup-local-docker.md|recipes/setup-local-docker.md",
    "docs/receitas/setup-mcp-supabase.md|recipes/setup-mcp-supabase.md",
    "docs/receitas/setup-mcp-github.md|recipes/setup-mcp-github.md"
)

foreach ($item in $Files) {
    $parts = $item.Split("|")
    $src = $parts[0]
    $dest = $parts[1]
    
    $Url = "$RepoUrl/$src"
    $Out = "$InstallDir/$dest"
    
    try {
        Invoke-WebRequest -Uri $Url -OutFile $Out -ErrorAction Stop
        Write-Host "✅ Atualizado: $dest" -ForegroundColor Green
    } catch {
        Write-Host "❌ Erro ao atualizar: $dest" -ForegroundColor Red
    }
}

# Sincronizar campo current_version
$VersionFile = "$InstallDir\version.json"
if (Test-Path $VersionFile) {
    $NewVersion = (Get-Content $VersionFile | ConvertFrom-Json).version
    $UserDataFile = "$InstallDir\memory\Red\user_data.json" # Red é o usuário atual no contexto do Victor
    if (Test-Path $UserDataFile) {
        $UserData = Get-Content $UserDataFile | ConvertFrom-Json
        $UserData.current_version = $NewVersion
        $UserData.last_update_check = (Get-Date -Format "yyyy-MM-dd")
        $UserData | ConvertTo-Json | Set-Content $UserDataFile
        Write-Host "✅ Versão atualizada para $NewVersion no perfil do usuário." -ForegroundColor Green
    }
}

Write-Host "`n🦈 MÉTODO S.H.A.R.K. ATUALIZADO COM SUCESSO!" -ForegroundColor Cyan
```

### **Passo 3: Finalização**
Após a conclusão, informe ao usuário:
`[ATLAS]: Sistema atualizado. As novas Regras de Ouro e agentes já estão operacionais.`
