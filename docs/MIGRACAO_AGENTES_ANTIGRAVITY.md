# Guia de Migração — Agentes S.H.A.R.K. para Google Antigravity
**Versão:** 3.0 → Antigravity Edition
**Data:** 2026-03-04
**Status:** Pronto para aplicar

---

## Contexto

Os arquivos em `~/.claude/agents/` são a versão de Red (Claude Code).
Os arquivos em `shark-method/agents/` são os que os alunos recebem via `install.sh` / `install.ps1`, instalados em `~/.gemini/agents/`.

Este documento descreve **o que mudou** na versão 3.0 e **como adaptar** cada mudança para o ambiente Antigravity dos alunos.

---

## Diferenças entre os dois ambientes

| Aspecto | Claude Code (Red) | Google Antigravity (Alunos) |
|---------|-------------------|----------------------------|
| Diretório de agentes | `~/.claude/agents/` | `~/.gemini/agents/` |
| Arquivo de config global | `~/.claude/CLAUDE.md` | `~/.gemini/GEMINI.md` |
| Frontmatter YAML | `name`, `description`, `model`, `color` | **Não usa** — começa direto com `#` |
| Ferramenta de browser | Playwright MCP (`mcp__plugin_playwright_*`) | Google Antigravity Browser Agent (`browser.goto()`, etc.) |
| Ferramentas de arquivo | `Read`, `Write`, `Edit`, `Glob`, `Grep` (Claude Code) | `view_file`, `create_file`, `edit_file` (Antigravity) |
| Identificação do usuário | Hardcoded: "Red" | Via `~/.gemini/memory/{username}/user_data.json` |
| Skills | Não usa | `~/.gemini/skills/curated/{agente}/` |
| Subagentes | Agent tool com `subagent_type` | Não usa subagentes — agentes são ativados por contexto |

---

## O que mudou na versão 3.0 (vs versão atual no repo)

### Mudanças aplicadas na versão do Red (Claude Code) que precisam ser portadas:

#### 1. TODAS as descrições dos agentes — atualizadas
A descrição no `GEMINI.md` dos alunos precisa refletir as atribuições reais:

```
# ANTES (errado):
- Ravena → Documentação, explicações, comunicação didática

# DEPOIS (correto):
- Shiva → Arquiteta de produto — Descoberta, Design System, MoSCoW, spec para Hades. AGENTE PADRÃO.
- Hades → Estrategista técnico — roadmap faseado, instrui Atlas, diagnostica erros complexos
- Atlas → Executor silencioso — implementa código, commits, GitFlow, reporta ao Hades
- Ravena → QA especialista — testa via browser real, valida rotas/botões/CSS/responsividade/performance
- Kerberos → Guardião de segurança — audita antes de deploy: XSS, SQL injection, RLS, CVEs
```

**Shiva como agente padrão** — adicionar no GEMINI.md:
```
Shiva é o agente padrão. Use Shiva quando o aluno inicia conversa nova sem contexto técnico explícito.
```

#### 2. RAVENA — QA com browser real
**Versão atual (repo):** usa ferramentas fictícias/Antigravity Browser Agent
**Versão 3.0 (Red):** usa Playwright MCP real

**Para os alunos:** adaptar para as ferramentas reais do Antigravity:
```
# Claude Code (Red):
mcp__plugin_playwright_playwright__browser_navigate(url)
mcp__plugin_playwright_playwright__browser_click(ref)
mcp__plugin_playwright_playwright__browser_take_screenshot()
mcp__plugin_playwright_playwright__browser_console_messages()
mcp__plugin_playwright_playwright__browser_evaluate(script)
mcp__plugin_playwright_playwright__browser_resize(w, h)

# Antigravity (Alunos) — equivalente:
browser.goto(url)
browser.click(selector)
browser.screenshot()
browser.console()
browser.evaluate(script)
browser.setViewport(width, height)
```

**O protocolo de 7 fases permanece idêntico:**
1. Mapeamento de rotas
2. Teste de interatividade (botões, formulários, links, modais)
3. Verificação de CSS/Tailwind via evaluate
4. Responsividade (375/768/1440px)
5. Erros de console e rede
6. Acessibilidade básica
7. Performance básica

#### 3. HADES — GitFlow + RCA + Output Contract
**Adições que devem ir para os alunos:**
- Estrutura do GitFlow: `local → dev → hml → main → Vercel`
- RCA Protocol: 3 hipóteses + regra das 2 tentativas
- Output Contract obrigatório ao instruir Atlas
- Formato do `asbuilt.md` compatível com RVM
- ADR automático para decisões arquiteturais

#### 4. ATLAS — Quality gates + SHIELDA
**Adições que devem ir para os alunos:**
- Verificação Critic antes de todo commit (secrets, TS, build, testes)
- Classificação de erros SHIELDA (Terminal / Retryable)
- Self-healing limitado (lint, format, imports)
- Setup de qualidade: Biome + Husky + commitlint
- Conventional Commits (tabela completa)
- Rollback procedure

#### 5. KERBEROS — Ferramentas reais + CVEs 2025
**Adaptações para Antigravity:**
```
# Claude Code (Red):
Semgrep CLI, TruffleHog CLI, Gitleaks CLI, Nuclei CLI

# Antigravity (Alunos):
# Alunos provavelmente não têm essas CLIs instaladas.
# Alternativa: manter verificações manuais via bash + browser
# e focar nas fases que não dependem de CLI externo:
# - Fase 1: grep manual por secrets
# - Fase 4: Supabase SQL via editor
# - Fase 5: headers via browser
# - Fase 6: pentests XSS/SQLi via browser.fill()
```

**CVE-2025-29927 e OWASP Top 10 2025** — mantém igual, independente do ambiente.

#### 6. SHIVA — Sem mudanças estruturais
Apenas remoção de referências a Claude Code (Read/Write tools) e substituição por ferramentas Antigravity equivalentes. Protocolo de 5 fases, MoSCoW e anti-clichê permanecem iguais.

---

## Integração RVM — O que vai para os alunos?

**A integração RVM é exclusiva do ambiente de Red** (via rvm-listener no servidor privado, acessível apenas por túnel SSH).

Os alunos **não têm acesso** a:
- `http://localhost:4000` (API privada de Red — porta bloqueada para a internet, exige túnel SSH)
- rvm-listener.js
- project_shark_state / shark_handoffs (tabelas privadas)

**O que os alunos mantêm:**
- Protocolo `CURRENT_STATUS.md` — formato e disciplina de atualização ✅
- Formato do `asbuilt.md` — estrutura e campos ✅
- Protocolo de handoff entre agentes (via texto, não via API) ✅

---

## Checklist de migração

### Para cada agente (`agents/*.md` no repo):

- [ ] **SHIVA** — Remover referências a Read/Write/Claude Code. Ajustar para Antigravity tools. Manter 5 fases intactas.
- [ ] **HADES** — Adicionar GitFlow estruturado, RCA, Output Contract. Remover RVM API (manter CURRENT_STATUS.md). Ajustar ferramentas.
- [ ] **ATLAS** — Adicionar Critic verification, SHIELDA, Biome/Husky setup. Remover RVM API (manter CURRENT_STATUS.md). Adaptar ferramentas.
- [ ] **RAVENA** — Substituir Playwright MCP por Antigravity Browser Agent. Manter protocolo de 7 fases. Remover RVM API.
- [ ] **KERBEROS** — Adaptar CLIs para alternativas disponíveis no Antigravity. Manter CVE-2025-29927. Manter OWASP Top 10 2025. Remover RVM API.

### Para `config/GEMINI.md`:

- [ ] Atualizar descrições dos 5 agentes (substituir definições erradas)
- [ ] Adicionar Shiva como agente padrão
- [ ] Atualizar guia de escolha de agente

### Para `install.sh` e `install.ps1`:

Nenhuma mudança necessária — os scripts já baixam os 5 agentes corretamente de `agents/*.md`.

---

## Referência: Mapeamento de ferramentas Claude Code → Antigravity

| Operação | Claude Code | Google Antigravity |
|----------|------------|-------------------|
| Ler arquivo | `Read tool` | `view_file` |
| Criar arquivo | `Write tool` | `create_file` |
| Editar arquivo | `Edit tool` | `edit_file` |
| Buscar arquivos | `Glob tool` | `list_files` / `find_files` |
| Buscar conteúdo | `Grep tool` | `search_in_files` |
| Executar comando | `Bash tool` | `run_command` |
| Navegar browser | `browser_navigate` (Playwright) | `browser.goto()` |
| Clicar elemento | `browser_click` | `browser.click()` |
| Screenshot | `browser_take_screenshot` | `browser.screenshot()` |
| Console | `browser_console_messages` | `browser.console()` |
| Executar JS | `browser_evaluate` | `browser.evaluate()` |
| Redimensionar | `browser_resize` | `browser.setViewport()` |
| Preencher form | `browser_fill_form` | `browser.fill()` |
| Snapshot DOM | `browser_snapshot` | `browser.dom()` |
| Requisições HTTP | `browser_network_requests` | `browser.network()` |
| Identificar usuário | Hardcoded "Red" | `~/.gemini/memory/{username}/user_data.json` |
| Docs de libs | Context7 MCP | Pesquisa direta / WebFetch |
| GitHub | GitHub MCP | `run_command(gh ...)` |
| Supabase | Supabase MCP | `run_command(npx supabase ...)` |

---

## Próximos Passos (quando Red aprovar)

1. Atualizar os 5 arquivos em `shark-method/agents/` com as versões adaptadas
2. Atualizar `shark-method/config/GEMINI.md` com descrições corretas + Shiva padrão
3. Fazer commit e push para o repo
4. Testar `install.sh` para validar que os arquivos chegam corretamente em `~/.gemini/agents/`
5. Validar no Google Antigravity que Ravena responde com o protocolo de QA real

---

## Arquivos de referência (versão Red — fonte da verdade)

| Agente | Arquivo Red (fonte) | Arquivo Aluno (destino) |
|--------|--------------------|-----------------------|
| Shiva | `~/.claude/agents/shiva.md` | `shark-method/agents/shiva.md` |
| Hades | `~/.claude/agents/hades.md` | `shark-method/agents/hades.md` |
| Atlas | `~/.claude/agents/atlas.md` | `shark-method/agents/atlas.md` |
| Ravena | `~/.claude/agents/ravena.md` | `shark-method/agents/ravena.md` |
| Kerberos | `~/.claude/agents/kerberos.md` | `shark-method/agents/kerberos.md` |
| Config global | `~/.claude/CLAUDE.md` | `shark-method/config/GEMINI.md` |

---

## ⚠️ Tailscale descontinuado (2026-08-04)

O Tailscale foi **removido** da infraestrutura (purge executado no servidor). Os IPs `100.64.77.5` (servidor) e `100.69.142.117` (máquina local) estão **mortos** — qualquer referência a eles é legado e não funciona.

- **SSH:** `ssh -i <CHAVE_SSH> root@<IP_SERVIDOR>`
- **Banco/APIs internas:** portas bloqueadas para a internet. Acesso apenas via **túnel SSH**:
  ```bash
  ssh -i <CHAVE_SSH> -L 4000:localhost:4000 root@<IP_SERVIDOR>
  ```
- Nunca reintroduzir `100.64.77.5`, `100.69.142.117`, `100.64.0.0/10` ou dependência de VPN Tailscale neste projeto.

> 🔐 **`<IP_SERVIDOR>` fica no vault, nunca neste arquivo.** Este repositório é público —
> IP de servidor em repo aberto é alvo de scan e brute force de SSH em horas.
> ```bash
> node ~/.claude/vault/vault-read.js --vault=hetzner-redpro ssh_host_public
> ```
> `<CHAVE_SSH>` é o caminho da chave privada na máquina local (fora do repo, nunca versionada).
