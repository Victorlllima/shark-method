# PROTOCOLO PLUGINS POR AGENTE — MÉTODO S.H.A.R.K.

> **Versão:** 1.0
> **Ambiente:** Claude Code (não se aplica ao Antigravity — sem sistema de plugins)
> **Status:** Oficial — parte da configuração de produção do Método

---

## 🎯 Problema que este protocolo resolve

No Claude Code, **plugins, skills e MCPs são globais por sessão** — qualquer agente que rodar enxerga tudo. Isso vai contra o princípio S.H.A.R.K. de **especialização por função**: o Atlas não deveria estar pensando em SAST, o Kerberos não deveria estar invocando `/carrossel`, a Ravena não precisa de Terraform skills.

Este protocolo define **três mecanismos combinados** para alcançar ~85% de "atribuição de plugin por agente":

1. **`tools` field no frontmatter** — filtro real de MCPs e tools por subagente
2. **Plugin whitelist no system prompt** — instrução explícita de quais skills usar
3. **Hooks de enforcement em `settings.json`** — bloqueio crítico no nível do harness

---

## 📊 Matriz de Atribuição — Plugins x Agentes S.H.A.R.K.

| Plugin / Skill / MCP | Shiva | Hades | Atlas | Ravena | Kerberos |
|---------------------|:-----:|:-----:|:-----:|:------:|:--------:|
| **Context7** (docs atualizadas) | ✅ | ✅ | ✅ | ⚪ | ⚪ |
| **HashiCorp Terraform/Packer** | ⚪ | ✅ | ✅ | ⚪ | ⚪ |
| **Shipyard** (infra IaC) | ⚪ | ✅ | ✅ | ⚪ | ✅ |
| **`/frontend-design`** | ✅ | ⚪ | ⚪ | ⚪ | ⚪ |
| **`/writing-plans`** | ✅ | ✅ | ✅ | ⚪ | ⚪ |
| **`/systematic-debugging`** | ⚪ | ✅ | ⚪ | ⚪ | ⚪ |
| **`/subagent-driven-development`** | ⚪ | ✅ | ⚪ | ⚪ | ⚪ |
| **`/git-commit` + `/gh-cli`** | ⚪ | ⚪ | ✅ | ⚪ | ⚪ |
| **`/verification-before-completion`** | ⚪ | ⚪ | ✅ | ⚪ | ⚪ |
| **`/stripe-best-practices`** | ⚪ | ⚪ | ✅ | ⚪ | ⚪ |
| **`/neon-postgres`** | ⚪ | ⚪ | ✅ | ⚪ | ⚪ |
| **Playwright Official Plugin** | ⚪ | ⚪ | 🟡 | ✅ | ⚪ |
| **Playwright MCP** | ⚪ | ⚪ | 🟡 | ✅ | 🟡 |
| **Dev-Browser** (alternativa lite) | ⚪ | ⚪ | ⚪ | ✅ | ⚪ |
| **Chrome DevTools MCP** | ⚪ | ⚪ | 🟡 | ✅ | ⚪ |
| **`/webapp-testing`** | ⚪ | ⚪ | ⚪ | ✅ | ⚪ |
| **Claude Code Security (Anthropic SAST)** | ⚪ | ⚪ | ⚪ | ⚪ | ✅ |
| **`/security-review`** (built-in) | ⚪ | ⚪ | ⚪ | ⚪ | ✅ |
| **Snyk Claude Skill** | ⚪ | ⚪ | ⚪ | ⚪ | ✅ |
| **Aikido Security MCP** | ⚪ | ⚪ | ⚪ | ⚪ | ✅ |
| **`/insecure-defaults`** | ⚪ | ⚪ | ⚪ | ⚪ | ✅ |
| **`/supply-chain-risk-auditor`** | ⚪ | ⚪ | ⚪ | ⚪ | ✅ |
| **`/semgrep` + `/semgrep-rule-creator`** | ⚪ | ⚪ | ⚪ | ⚪ | ✅ |
| **`/differential-review`** | ⚪ | ⚪ | ⚪ | ⚪ | ✅ |
| **OpenTelemetry Observability** | ✅ | ✅ | ✅ | ✅ | ✅ |

**Legenda:**
- ✅ — **Permitido e esperado** (skill/plugin entra no system prompt do agente)
- 🟡 — **Permitido em contexto específico** (Atlas usa Playwright só pós-fix de bug encontrado pela Ravena)
- ⚪ — **Não atribuído** (agente não deve invocar)

---

## 🔧 Mecanismo 1 — `tools` field por subagente

Cada agente do S.H.A.R.K. pode ter sua definição em `agents/<nome>.md` enriquecida com frontmatter YAML que **lista as tools permitidas**. O harness do Claude Code respeita esse filtro para subagentes invocados via Task tool.

### Template do frontmatter

```yaml
---
name: <agente>
description: <descrição curta>
tools: Read, Grep, Glob, Edit, Write, Bash, <MCP/plugin tools específicos>
---
```

### Atribuição por agente

#### Shiva — Arquiteta de Produto
```yaml
tools: Read, Grep, Glob, Edit, Write, WebFetch, WebSearch, mcp__context7__*
```
**Por quê:** precisa ler/criar specs e tokens de design, pesquisar referências visuais. Não executa código nem mexe em infra.

#### Hades — Estrategista Técnico
```yaml
tools: Read, Grep, Glob, Edit, Write, Bash, WebFetch, mcp__context7__*, mcp__hashicorp__*, mcp__shipyard__*
```
**Por quê:** planeja arquitetura, lê código existente, consulta docs e padrões de infra. Pode rodar `gh` e `git` para inspeção (não para commits).

#### Atlas — Executor Silencioso
```yaml
tools: Read, Grep, Glob, Edit, Write, Bash, NotebookEdit, mcp__context7__*, mcp__hashicorp__*, mcp__shipyard__*, mcp__neon__*, mcp__stripe__*
```
**Por quê:** o único agente que **executa e commita**. Sem acesso a Playwright (Ravena testa, Atlas só corrige após report) nem a tools de segurança (Kerberos audita, Atlas só aplica fix).

#### Ravena — QA Especialista
```yaml
tools: Read, Grep, Glob, Bash, mcp__playwright__*, mcp__chrome-devtools__*, mcp__dev-browser__*
```
**Por quê:** **whitelist real de browser MCPs**. Não tem Edit/Write — Ravena reporta bugs, Atlas corrige.

#### Kerberos — Guardião de Segurança
```yaml
tools: Read, Grep, Glob, Bash, WebFetch, mcp__claude-code-security__*, mcp__snyk__*, mcp__aikido__*, mcp__semgrep__*
```
**Por quê:** lê tudo, executa scanners via Bash, audita via MCPs específicos. **Não tem Edit/Write** — Kerberos reprova, Atlas remedia.

---

## 🧠 Mecanismo 2 — Plugin whitelist no system prompt

O `tools` field não filtra **skills** (skills carregam via system prompt do modelo, não via harness). Por isso, cada agente.md DEVE conter um bloco explícito:

```markdown
## 🔌 SKILLS PERMITIDAS (whitelist)

Você SÓ pode invocar estas skills:
- /<skill-1>
- /<skill-2>

❌ NUNCA invocar skills fora desta lista. Se uma tarefa exigir skill não permitida,
   passe o bastão para o agente correto:
   - Skills de design → Shiva
   - Skills de debug → Hades
   - Skills de execução/git → Atlas
   - Skills de QA/browser → Ravena
   - Skills de segurança → Kerberos
```

**Funciona em "honor system"** — o modelo escolhe respeitar. Combinado com hooks (Mecanismo 3), vira enforcement real para casos críticos.

---

## 🛡️ Mecanismo 3 — Hooks de enforcement em `settings.json`

Hooks são scripts que rodam **antes ou depois** de tool calls, interceptando no nível do harness (não confia no modelo). Permitem regras como:

- **Bloquear** que o Atlas faça `git push` para `main` sem aprovação do Kerberos
- **Forçar** que toda mudança em `app/api/` passe pelo `/security-review`
- **Logar** todas as tool calls da Ravena para observabilidade de QA

### Hooks críticos recomendados

#### Hook 1 — Bloquear push para `main` sem aprovação dupla
```json
{
  "PreToolUse": [{
    "matcher": "Bash",
    "hooks": [{
      "type": "command",
      "command": "node ~/.shark/hooks/block-main-push.js"
    }]
  }]
}
```
Script verifica se o comando é `git push origin main` e exige existência de arquivo `.shark/approvals/kerberos-approved-<commit-hash>` e `.shark/approvals/ravena-approved-<commit-hash>`.

#### Hook 2 — Auto-disparar `/security-review` ao editar arquivos sensíveis
```json
{
  "PostToolUse": [{
    "matcher": "Edit|Write",
    "hooks": [{
      "type": "command",
      "command": "node ~/.shark/hooks/trigger-security-review.js"
    }]
  }]
}
```
Script detecta edits em `app/api/**`, `lib/auth/**`, `supabase/migrations/**` e adiciona reminder ao próximo turno do agente.

#### Hook 3 — Bloquear Atlas de invocar skills de outros agentes
```json
{
  "PreToolUse": [{
    "matcher": "Skill",
    "hooks": [{
      "type": "command",
      "command": "node ~/.shark/hooks/enforce-agent-skill-whitelist.js"
    }]
  }]
}
```
Script lê o agente ativo (do `tasks/todo.md` ou contexto), consulta a matriz deste protocolo, e bloqueia se a skill não estiver na whitelist do agente.

---

## 🚀 Workflow de adoção

### Para Red (manutenção do Método)
1. Manter a **matriz de atribuição** deste arquivo atualizada quando novos plugins forem adicionados
2. Quando promover skill nova do `~/.claude/` (SharkIgnore) para o Método → atualizar matriz + agente.md
3. Hooks ficam em `~/.shark/hooks/` (privado de Red) — não vão pro repositório público

### Para alunos do Método
1. Instalam o shark-method via `install.ps1` / `install.sh`
2. Recebem os 5 agentes `.md` com tools field correto
3. `config/CLAUDE.md` referencia este protocolo
4. Hooks são **opcionais** — alunos avançados podem ativar copiando exemplos de `config/hooks-examples/`

---

## 🚧 Limitações conhecidas (Maio/2026)

1. **`tools` field só filtra para subagentes** — o agente principal de uma sessão Claude Code ainda tem todas as tools disponíveis. Workaround: o usuário sempre invoca via `/shiva`, `/hades`, etc., que disparam o subagente correto.

2. **Skills carregam via system prompt** — não há filtro nativo. Por isso o "honor system" + hooks de enforcement.

3. **MCPs são instalados globalmente** — todos os agentes "veem" todos os MCPs instalados. O filtro acontece via `tools` field, não via instalação.

4. **Roadmap Anthropic:** discussões no GitHub do claude-code mencionam `agent.allowedSkills` como feature futura — quando lançar, este protocolo será simplificado.

---

## 📖 Referências externas

- [Anthropic Claude Plugins Official](https://github.com/anthropics/claude-plugins-official)
- [Playwright Plugin Oficial](https://claude.com/plugins/playwright)
- [Claude Code Security Review](https://github.com/anthropics/claude-code-security-review)
- [Snyk Claude Skills](https://snyk.io/articles/top-claude-skills-cybersecurity-hacking-vulnerability-scanning/)
- [Aikido MCP](https://mcpmarket.com/server/sast)
- [Claude Code Plugins Marketplace](https://claudemarketplaces.com/)

---

## 🔄 Histórico

| Data | Mudança | Por |
|------|---------|-----|
| 2026-05-17 | Versão inicial do protocolo | Red + Shiva |
