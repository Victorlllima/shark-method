# Receita — Setup do Vault (Cofre de Credenciais)

> Black-box para o Atlas executar. O Hades referencia esta receita; não cola o código inline.

O vault guarda tokens (GitHub, Supabase, Stripe…) criptografados pelo próprio SO, para os agentes consultarem sem o usuário colar credencial toda vez.

## 🗂️ Vault LOCAL vs GLOBAL (decisão obrigatória)

Sempre que uma credencial nova aparece, o Atlas pergunta **onde guardar**:

- **LOCAL** (`~/.shark/vaults/<slug-do-projeto>/`) — chave específica deste projeto (ex.: a service_role do Supabase deste cliente, o token de deploy desta app). Outros projetos não enxergam.
- **GLOBAL** (`~/.shark/vaults/global/`) — chave reutilizável por qualquer projeto (ex.: API key da Anthropic/OpenAI, token do Telegram pessoal, chave da ElevenLabs).

**Ordem de busca ao LER uma chave:** vault do projeto → vault global (fallback automático). Assim uma chave global serve a todos sem duplicar; uma chave local sobrepõe a global se existir com o mesmo nome.

**Como o Atlas decide o slug do projeto:** lê o arquivo `.vault-context` na raiz do projeto (uma linha com o nome do vault). Se não existir, cria com o nome da pasta do projeto.

```
~/.shark/vaults/
├── global/                 ← tokens compartilhados (anthropic, telegram, ...)
├── <projeto-a>/            ← secrets só do projeto A
└── <projeto-b>/            ← secrets só do projeto B
```

## Windows — DPAPI (Data Protection API)

O DPAPI criptografa usando a conta do usuário Windows. Só o próprio usuário, na mesma máquina, descriptografa.

```powershell
# $Scope = "global"  → vault compartilhado
# $Scope = "<slug>"  → vault do projeto (lido do .vault-context)
param([string]$Scope = "global")
$vaultDir = "$env:USERPROFILE\.shark\vaults\$Scope"
New-Item -ItemType Directory -Force -Path $vaultDir | Out-Null

function Save-SharkCredential {
    param([string]$Key, [string]$Value)
    $enc = [System.Security.Cryptography.ProtectedData]::Protect(
        [System.Text.Encoding]::UTF8.GetBytes($Value), $null,
        [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    Set-Content -Path "$vaultDir\$Key.vault" -Value ([Convert]::ToBase64String($enc))
    Write-Host "✅ '$Key' salva (DPAPI)."
}

function Get-SharkCredential {
    param([string]$Key)
    $b64 = Get-Content -Path "$vaultDir\$Key.vault"
    $dec = [System.Security.Cryptography.ProtectedData]::Unprotect(
        [Convert]::FromBase64String($b64), $null,
        [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    [System.Text.Encoding]::UTF8.GetString($dec)
}
```

## macOS — Keychain

```bash
VAULT_SERVICE="shark-[SLUG_DO_PROJETO]"
save_shark_credential() { security add-generic-password -s "$VAULT_SERVICE" -a "$1" -w "$2" -U 2>/dev/null; echo "✅ '$1' salva (Keychain)."; }
get_shark_credential()  { security find-generic-password -s "$VAULT_SERVICE" -a "$1" -w 2>/dev/null; }
```

## Linux — Secret Service (libsecret)

```bash
# Requer: sudo apt install libsecret-tools
VAULT_COLLECTION="shark-[SLUG_DO_PROJETO]"
save_shark_credential() { secret-tool store --label="Shark/$VAULT_COLLECTION/$1" project "$VAULT_COLLECTION" key "$1" <<< "$2"; echo "✅ '$1' salva."; }
get_shark_credential()  { secret-tool lookup project "$VAULT_COLLECTION" key "$1" 2>/dev/null; }

# Fallback sem Secret Service — OpenSSL AES-256
save_shark_credential_fallback() {
  local dir="$HOME/.shark/vaults/$VAULT_COLLECTION"; mkdir -p "$dir"
  echo "$2" | openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -pass pass:"$(id -u)-$(hostname)" -out "$dir/$1.enc" 2>/dev/null
}
```

## Credenciais padrão por projeto

| Chave | Quando salvar |
|---|---|
| `github_token` | ao configurar GitHub MCP |
| `supabase_url` / `supabase_service_key` | ao configurar Supabase |
| `vercel_token` | ao configurar deploy |
| `stripe_secret_key` | se houver pagamentos |
| `openai_key` / `anthropic_key` | se usar IA |

## Regras
- ✅ SEMPRE perguntar **local vs global** ao receber credencial nova de uso repetido.
- ✅ Ordem de busca ao ler: vault do projeto → vault global (fallback).
- ❌ NUNCA commitar `.shark/`, `.vault*`, `.vault-context`, `.env*` — confirme o `.gitignore` antes.
- ❌ NUNCA hardcodar credencial no código.
- ❌ NUNCA pedir uma chave que já está em algum vault — leia primeiro.
