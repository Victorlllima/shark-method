# Hooks de Enforcement — Método S.H.A.R.K.

Exemplos plug-and-play de hooks para o Claude Code que implementam o protocolo
[Plugins por Agente](../../docs/protocolos/plugins-por-agente.md).

## 🚀 Instalação rápida

### 1. Copiar hooks para o diretório de scripts

```bash
# Windows (PowerShell)
mkdir -Force "$HOME\.shark\hooks"
Copy-Item *.js "$HOME\.shark\hooks\"

# macOS / Linux
mkdir -p ~/.shark/hooks
cp *.js ~/.shark/hooks/
chmod +x ~/.shark/hooks/*.js
```

### 2. Mesclar `settings.json` com seu `~/.claude/settings.json`

O arquivo `settings.json` deste diretório é um **template**. Não substitua o seu
direto — mescle o bloco `"hooks"` com sua configuração existente.

### 3. Validar instalação

```bash
# Em qualquer projeto S.H.A.R.K., faça uma edição em app/api/ ou auth/.
# O hook trigger-security-review.js deve disparar reminder do Kerberos.

# Tente git push origin main sem aprovações.
# O hook block-main-push.js deve bloquear.
```

---

## 📋 Hooks incluídos

| Hook | Tipo | O que faz |
|------|------|-----------|
| `block-main-push.js` | PreToolUse (Bash) | Bloqueia `git push origin main` sem aprovação de Ravena + Kerberos |
| `trigger-security-review.js` | PostToolUse (Edit\|Write) | Reminder de auditoria ao tocar `app/api/`, `auth/`, `migrations/`, `.env*`, `middleware.ts` |
| `enforce-agent-skill-whitelist.js` | PreToolUse (Skill) | Bloqueia skill fora da whitelist do agente ativo |
| `log-qa-activity.js` | PostToolUse (Playwright/Chrome DevTools) | Loga toda atividade de QA em `.shark/logs/qa-<data>.jsonl` |

---

## 🛠️ Como Ravena e Kerberos aprovam um commit

Ao final de relatório APROVADO, o agente executa via Bash:

```bash
# Ravena (após QA passar)
mkdir -p .shark/approvals
touch ".shark/approvals/ravena-approved-$(git rev-parse HEAD)"

# Kerberos (após auditoria passar)
mkdir -p .shark/approvals
touch ".shark/approvals/kerberos-approved-$(git rev-parse HEAD)"
```

Esses arquivos viram a "chave" para destravar o `git push origin main`.

---

## ⚠️ Filosofia: fail-open

Todos os hooks usam **fail-open** em caso de erro interno (exit code 0).
Filosofia: o método não pode travar Red por bug no hook. Se algo der errado no
hook, ele se cala e deixa passar. Apenas regras explícitas bloqueiam.

A única exceção: regras de segurança explícitas (push para main, skill fora da
whitelist) — essas usam exit code 2 para forçar o bloqueio.

---

## 🔒 SharkIgnore

Os hooks ficam em `~/.shark/hooks/` (laboratório de Red) por padrão. Para
promover para o Método público, copie para `shark-method/config/hooks/` e
adicione ao `install.ps1` / `install.sh`.
