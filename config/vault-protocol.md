# VAULT PROTOCOL — MÉTODO S.H.A.R.K. v3.0

> Protocolo obrigatório para todos os agentes ao lidar com tokens, senhas e chaves de API.
> O vault é o cofre local criptografado do usuário. Nenhuma credencial deve ser pedida
> ao usuário mais de uma vez, nem hardcoded no código, nem commitada no Git.

---

## 🔑 ÍNDICE DE CHAVES PADRÃO

Todo vault de projeto S.H.A.R.K. usa estas chaves padronizadas.
Os agentes **sempre** buscam pelo nome exato da chave abaixo antes de pedir ao usuário.

| Chave no Vault | Serviço | Onde obter |
|----------------|---------|------------|
| `anthropic_api_key` | Claude / Anthropic API | console.anthropic.com → API Keys |
| `github_token` | GitHub Personal Access Token | github.com → Settings → Developer settings → PAT |
| `supabase_url` | URL do projeto Supabase | app.supabase.com → Project Settings → API |
| `supabase_anon_key` | Chave pública Supabase | app.supabase.com → Project Settings → API |
| `supabase_service_key` | Chave privada Supabase (admin) | app.supabase.com → Project Settings → API |
| `vercel_token` | Token da Vercel | vercel.com → Settings → Tokens |
| `stripe_publishable_key` | Chave pública Stripe | dashboard.stripe.com → Developers → API keys |
| `stripe_secret_key` | Chave secreta Stripe | dashboard.stripe.com → Developers → API keys |
| `stripe_webhook_secret` | Secret do webhook Stripe | dashboard.stripe.com → Webhooks |
| `openai_api_key` | OpenAI API | platform.openai.com → API keys |
| `voyage_api_key` | Voyage AI (embeddings) | dash.voyageai.com → API keys |
| `hetzner_api_token` | Hetzner Cloud API | console.hetzner.com → Security → API Tokens |
| `evolution_api_url` | URL da Evolution API | configurado no servidor |
| `evolution_api_key` | Chave da Evolution API | configurado no servidor |
| `postgres_url` | Connection string PostgreSQL | host do banco de dados |
| `redis_url` | Connection string Redis | host do Redis |

> **Chave não listada?** O agente define um nome em `snake_case` e adiciona nesta tabela.

---

## 🔐 TECNOLOGIA DE CRIPTOGRAFIA POR SO

### Windows — DPAPI
```powershell
$vaultDir = "$env:USERPROFILE\.shark\vaults\[SLUG_DO_PROJETO]"
New-Item -ItemType Directory -Force -Path $vaultDir | Out-Null

function Save-SharkCredential {
    param([string]$Key, [string]$Value)
    $encrypted = [System.Security.Cryptography.ProtectedData]::Protect(
        [System.Text.Encoding]::UTF8.GetBytes($Value), $null,
        [System.Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    Set-Content -Path "$vaultDir\$Key.vault" -Value ([Convert]::ToBase64String($encrypted))
    Write-Host "✅ '$Key' salvo com criptografia DPAPI."
}

function Get-SharkCredential {
    param([string]$Key)
    $path = "$vaultDir\$Key.vault"
    if (-not (Test-Path $path)) { return $null }
    $enc = [Convert]::FromBase64String((Get-Content $path))
    $bytes = [System.Security.Cryptography.ProtectedData]::Unprotect($enc, $null,
        [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    return [System.Text.Encoding]::UTF8.GetString($bytes)
}
```

### macOS — Keychain
```bash
VAULT_SERVICE="shark-[SLUG_DO_PROJETO]"

save_shark_credential() {
    security add-generic-password -s "$VAULT_SERVICE" -a "$1" -w "$2" -U 2>/dev/null
    echo "✅ '$1' salvo no Keychain."
}

get_shark_credential() {
    security find-generic-password -s "$VAULT_SERVICE" -a "$1" -w 2>/dev/null
}
```

### Linux — Secret Service / OpenSSL
```bash
VAULT_COLLECTION="shark-[SLUG_DO_PROJETO]"

# Com Secret Service (requer: sudo apt install libsecret-tools)
save_shark_credential() {
    secret-tool store --label="Shark/$VAULT_COLLECTION/$1" \
        project "$VAULT_COLLECTION" key "$1" <<< "$2"
}
get_shark_credential() {
    secret-tool lookup project "$VAULT_COLLECTION" key "$1" 2>/dev/null
}

# Fallback OpenSSL AES-256
save_shark_credential_fallback() {
    local vault_dir="$HOME/.shark/vaults/$VAULT_COLLECTION"
    mkdir -p "$vault_dir"
    echo "$2" | openssl enc -aes-256-cbc -pbkdf2 -iter 100000 \
        -pass pass:"$(id -u)-$(hostname)" -out "$vault_dir/$1.enc" 2>/dev/null
}
```

---

## 🤖 PROTOCOLO AUTÔNOMO DOS AGENTES

### Fluxo OBRIGATÓRIO ao precisar de uma credencial:

```
PASSO 1 — Verificar vault
  → Buscar a chave pelo nome padronizado (tabela acima)
  → Se encontrada: usar silenciosamente. NÃO perguntar ao usuário.
  → Se não encontrada: ir para PASSO 2

PASSO 2 — Pedir ao usuário UMA vez
  → "[NOME], preciso da sua chave [SERVIÇO] para continuar.
     Você encontra ela em [ONDE OBTER].
     Pode me passar? Vou guardar no cofre e nunca mais precisar pedir."

PASSO 3 — Salvar no vault
  → Salvar com o nome padronizado da tabela acima
  → Confirmar: "✅ Chave salva no cofre. Não precisarei pedir de novo."

PASSO 4 — Colocar no .env do projeto
  → Adicionar a variável de ambiente correspondente no .env.local (ou .env)
  → Verificar que .env está no .gitignore ANTES de adicionar

PASSO 5 — Nunca commitar
  → Verificar git diff --cached antes de qualquer commit
  → Se detectar credencial: ABORTAR commit, reportar ao Hades
```

### Mapeamento vault → .env

| Chave no Vault | Variável de Ambiente |
|----------------|---------------------|
| `anthropic_api_key` | `ANTHROPIC_API_KEY` |
| `supabase_url` | `NEXT_PUBLIC_SUPABASE_URL` |
| `supabase_anon_key` | `NEXT_PUBLIC_SUPABASE_ANON_KEY` |
| `supabase_service_key` | `SUPABASE_SERVICE_ROLE_KEY` |
| `stripe_publishable_key` | `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` |
| `stripe_secret_key` | `STRIPE_SECRET_KEY` |
| `stripe_webhook_secret` | `STRIPE_WEBHOOK_SECRET` |
| `openai_api_key` | `OPENAI_API_KEY` |
| `voyage_api_key` | `VOYAGE_API_KEY` |
| `hetzner_api_token` | `HETZNER_API_TOKEN` |
| `postgres_url` | `DATABASE_URL` |
| `github_token` | `GITHUB_TOKEN` |

---

## 🚨 REGRAS ABSOLUTAS

- ❌ NUNCA pedir uma chave que já está no vault
- ❌ NUNCA commitar arquivos `.env`, `.env.local`, `.secrets`, `*.vault`
- ❌ NUNCA hardcodar credencial no código
- ❌ NUNCA logar o valor de uma credencial no terminal
- ✅ SEMPRE verificar `.gitignore` antes de qualquer push
- ✅ SEMPRE salvar no vault após receber do usuário
- ✅ SEMPRE colocar no `.env` após salvar no vault
- ✅ SEMPRE confirmar ao usuário que salvou ("nunca precisarei pedir de novo")
