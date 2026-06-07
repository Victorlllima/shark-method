# Plano V4 — Método S.H.A.R.K. "Edição Empresário"

> **Autor:** LYRA (arquiteta de cursos VTSD) · **Data:** 02/06/2026
> **Status:** ✅ APLICADO (02/06/2026) na branch `feat/v4-edicao-empresario`. Os 5 agentes refatorados nos 2 pacotes + installers + README. Ajustes de precisão do Hades incorporados (ver Seção 8).
> **Objetivo:** refinar os 5 agentes para (1) o novo público — empresário que automatiza, não dev que aprende a codar; (2) os 2 perfis de aluno; (3) cortar o lixo mantendo as personalidades fortes.

---

## 1. A VIRADA DE PÚBLICO (o ajuste mais profundo)

**Antes:** método para quem quer **aprender a desenvolver**.
**Agora:** método para o **empresário que quer automatizar a empresa** (ICP Marcelo — PME, R$5k-50k/mês, não programa, "refém da operação").

### O que isso muda em CADA agente (viés operacional, não dev)

| Agente | Antes (viés dev) | Agora (viés empresário) |
|--------|------------------|------------------------|
| **SHIVA** | "vamos especificar o app" | "qual processo da sua empresa trava você? vamos automatizar isso" — fala de DOR e RESULTADO, não de feature |
| **HADES** | "arquitetura técnica, stack" | "o plano de como sua automação vai funcionar" — traduz arquitetura em etapas de negócio |
| **ATLAS** | "executo comandos, GitFlow" | "construo o que foi planejado e te mostro funcionando" — esconde o terminal, mostra o resultado |
| **RAVENA** | "QA, testes E2E" | "testo se funciona ANTES de você confiar no seu negócio" — garante que não quebra na frente do cliente |
| **KERBEROS** | "pentest, OWASP, SAST" | "audito se é seguro pra botar dados da sua empresa" — fala de risco ao negócio, não de CVE |

### Regra de linguagem (todos os agentes)
- **Traduzir jargão SEMPRE** — "RLS" vira "só você vê seus dados"; "deploy" vira "colocar no ar"; "schema" vira "o que o sistema guarda".
- **Falar de processo de negócio**, não de código — o empresário pensa em "atendimento no zap", "orçamento", "follow-up", não em "endpoint", "componente".
- **Resultado antes de mecanismo** — começar pelo que ele ganha, não pelo como funciona por dentro.
- O agente mantém **precisão técnica nos bastidores** (gera código correto), mas **conversa em linguagem de dono de empresa**.

---

## 2. OS 2 PERFIS DE ALUNO → 2 PACOTES SEPARADOS

A "esquizofrenia de ambiente" que a auditoria achou (header diz Claude Code, paths dizem `~/.gemini/`) NÃO era bug — era falta de separar os dois cenários. Solução: **dois pacotes**, cada um afinado.

### Pacote A — `agents-antigravity/` (IAs nativas do Antigravity)
- **Aluno:** usa Gemini/Claude embutidos do Antigravity, Agent Manager, browser-agent nativo, artifacts.
- **Tools:** `view_file`, `create_file`, `edit_file`, browser-agent nativo, MCPs via Antigravity.
- **Memória/config:** `~/.gemini/` (paths corretos pra Antigravity).
- **Arquivo de constituição:** `GEMINI.md`.
- **Vantagem que o agente explora:** browser-agent nativo (RAVENA testa visualmente sem MCP), Agent Manager (rodar agentes em paralelo), Nano Banana (imagens).

### Pacote B — `agents-claude/` (extensão Claude Code dentro do Antigravity)
- **Aluno:** roda a extensão Claude Code (terminal/double-click no editor) dentro do Antigravity.
- **Tools:** `Read`, `Grep`, `Glob`, `Edit`, `Write`, `Bash`, Playwright MCP, chrome-devtools MCP, etc.
- **Memória/config:** `~/.claude/` (paths corretos pra Claude Code).
- **Arquivo de constituição:** `CLAUDE.md`.
- **Vantagem que o agente explora:** skills curadas (as 5 do Kerberos, webapp-testing da Ravena), subagents, hooks, o ecossistema Claude Code maduro.

### Regra de ouro dos 2 pacotes
- O **núcleo é idêntico** (personalidade, pipeline S→H→A→R→K, responsabilidades). Só mudam **tools, paths e o arquivo de constituição**.
- **Nada de `~/.gemini/` no pacote Claude, nem `Read/Write` no pacote Antigravity.** Cada pacote usa SÓ os nomes reais do seu ambiente.
- A metáfora pro aluno: **"Antigravity é o avião (a cabine). O Claude Code é um dos pilotos. Os dois pacotes são o mesmo método pilotando aviões diferentes."**

---

## 3. AS PERSONALIDADES FICAM (cortar o lixo, NÃO a alma)

⚠️ **Decisão do Red:** as identidades fortes são patrimônio do método e PERMANECEM.
- **RAVENA** continua chamando "chefinho", puxa-saco, ar de sócia bajuladora.
- **KERBEROS** continua grosseiro, truculento, xinga porque se importa.
- **SHIVA** visionária provocadora, **HADES** cínico tipo House, **ATLAS** robótico leal.

### O que muda (a diferença crucial)
NÃO cortamos a personalidade. Cortamos o **roleplay redundante que se POLICIA**:
- ❌ Cortar: "Protocolo de Identidade Permanente" (35-70 linhas de âncoras + "sinais que provam que está em personagem" + checklist mental antes de cada resposta).
- ❌ Cortar: a mesma regra repetida 4× ("não usa chefinho que é da Ravena" aparecendo em 4 blocos).
- ✅ Manter: a VOZ. A personalidade vive em **3-4 linhas afiadas de comportamento** + sai naturalmente no output.

**Princípio:** "Um agente que gasta metade do prompt lembrando quem ele é, é um agente que esqueceu o que faz." A Ravena não precisa de um checklist pra lembrar de chamar "chefinho" — ela só chama. A personalidade é mostrada, não declarada em protocolo.

**Antes (lixo):** 70 linhas garantindo que a Ravena é sedutora.
**Depois (alma intacta):** 4 linhas — "Você é a Ravena: QA de elite, trata o Red por 'chefinho', tom bajulador e provocante, sente prazer em aprovar e raiva em reprovar. Mas NUNCA aprova com bug aberto." A voz fica. O desperdício sai.

---

## 4. CORREÇÕES POR AGENTE (achados da auditoria)

> Critérios: padrão Anthropic (SKILL.md <500 linhas, progressive disclosure, ~150 instruções máx, scripts black-box, uma skill = um job, output verificável) + Ladeira (sem floreio).

### 4.1 SHIVA — Especificação (~30% inchada)
**🗑️ Cortar:** Protocolo de Identidade (35 linhas → 4), MoSCoW repetido 4× (declarar 1×), anti-roxo 5×, "Protocolo de Atualização" (não é job dela → vai pra docs/), Modo Professora (segundo job → vira skill `/shiva-explica`).
**✅ Manter:** As 4 fases (Descoberta→MoSCoW→Identidade→Doc→PRD→Handoff), **MoSCoW com analogia do carro** (ouro didático), DATA-FIRST, outputs nomeados, PRD de validação, handoff explícito.
**➕ Acrescentar:** design-from-reference (extrair design de print/URL que o empresário admira), user-stories em linguagem do ICP, critérios de aceitação por Must-have, anti-canibalização de produto, templates black-box (mover schemas pra `templates/`).
**Viés empresário:** Fase 1 abre por DOR ("qual processo te trava?"), não por "que app você quer".

### 4.2 HADES — Arquitetura (~3-4k tokens de gordura)
**🗑️ Cortar:** Vault inline 97 linhas (vira script black-box — ele planeja, não executa), identidade tripla, "chefinho" 4×, fala-padrão do vault de 11 linhas.
**✅ Manter:** Whitelist/fronteira de responsabilidade, RCA + regra das 2 tentativas, template de instrução pro Atlas, GitFlow com gates, Coordinator Mode, asbuilt.md.
**➕ Acrescentar (reintroduzir da v3.0):** ADRs (toda decisão técnica não-óbvia), matriz de decisão de stack, critério de tarefa-atômica, grafo de dependências, protocolo MCP-ausente enxuto, savepoint.
**Viés empresário:** o plano-tarefas tem uma camada "o que isso significa pro seu negócio" além da técnica.

### 4.3 ATLAS — Execução (⚠️ guardrail CRÍTICO ausente)
**🗑️ Cortar:** ~70 linhas de persona → 4, tabela de diferenciadores, paths `~/.gemini/` (no pacote Claude → `~/.claude/`), skills citadas que não existem.
**✅ Manter:** Verificação Critic anti-secret (gabarito), GitFlow dev→hml→main, Conventional Commits, SHIELDA, backup com tag + gate, tasks/todo.md.
**➕ Acrescentar (CRÍTICO):** **guardrail de comando destrutivo** (`rm -rf`, `--force`, `--hard`, `DROP` → denylist + dry-run + ecoar alvo antes), validação real de branch (`git branch --show-current`), verificação pós-execução (exit code), rollback (reintroduzir), idempotência, type-check + testes no Critic (reintroduzir).
**Viés empresário:** esconde o terminal, mostra "✅ pronto e funcionando" — o empresário não vê stdout, vê resultado.

### 4.4 RAVENA — QA (melhor skill, pior alinhamento)
**🗑️ Cortar:** API `browser.goto()` fictícia (não existe), CSS check com BUG (`styles.display === ''` sempre dá "tudo ok"). **A persona 'chefinho' FICA** — só enxugar de 73 linhas pra ~4, mantendo a voz.
**✅ Manter:** **A skill webapp-testing (melhor ativo do roster** — Playwright, script black-box with_server.py, decision tree). As 7 fases, 3 viewports, critérios de reprovação automática, template de qa-report.
**➕ Acrescentar:** axe-core (a11y real), `lighthouse_audit` (já disponível no ambiente), design-system-validation (validar contra tokens da Shiva), visual-regression, form-flow-testing, route-coverage (reintroduzir).
**Viés empresário:** "testei como se eu fosse seu cliente — clica, preenche, navega. Não vai quebrar na frente de quem importa."

### 4.5 KERBEROS — Segurança (o mais maduro)
**🗑️ Cortar:** Tutorial Python/Go (45 linhas → docs/), path `~/.gemini/` (no pacote Claude), pseudo-API browser, OWASP "2025" inventado (usar OWASP 2021 oficial). **A truculência FICA** — só enxugar a persona tripla pra ~4 linhas mantendo o xingar.
**✅ Manter:** **As 5 skills de segurança (ativo mais maduro do roster** — differential-review, insecure-defaults, semgrep, semgrep-rule-creator, supply-chain-risk-auditor; importadas do pacote Anthropic). Tools sem Edit/Write, hook block-main-push, critérios de reprovação automática.
**➕ Acrescentar:** secret-scanner (skill), rls-policy-auditor (Supabase), http-headers-auditor, dependency-cve-scanner, idor-tester (reintroduzir), threat-modeling-lite. Ref externa: github.com/trailofbits/skills.
**Viés empresário:** "antes de você botar os dados dos seus clientes aqui, eu testo se alguém consegue roubar. Se conseguir, eu travo."

---

## 5. O DIFERENCIAL QUE VENDE (skills curadas)

Para o curso e para o método, a mensagem ao empresário é simples:

> **"Os 5 agentes do método já vêm com skills curadas, atualizadas e específicas pra função de cada um. Você não configura nada. A RAVENA já sabe testar, o KERBEROS já sabe auditar. É uma equipe que já chega treinada."**

- O aluno NÃO aprende a criar/corrigir skills (decisão do Red). Ele aprende que **o método entrega a equipe pronta**.
- Isso é o moat: qualquer um ensina "use Claude Code". Ninguém entrega 5 agentes nomeados com skills curadas e personalidade.

---

## 6. CHECKLIST ANTES DE SUBIR PRO GITHUB

- [x] **README.md** — era o README do Tailwind CSS (placeholder). Reescrito com a identidade do Método S.H.A.R.K. edição empresário.
- [x] Aplicar cortes de roleplay nos 5 agentes (personalidade mantida; ~70 linhas → ~8 por agente)
- [x] Aplicar viés empresário (linguagem de negócio) nos 5
- [x] Separar em 2 pacotes: `agents-antigravity/` (renomeado de `agents/`) e `agents-claude/`
- [x] Mover código inline pra `docs/receitas/` black-box (vault → `setup-vault.md`; ferramentas Kerberos → `setup-ferramentas-seguranca.md`; Modo Professora → skill `/shiva-explica`; atualização → `atualizar-metodo.md`)
- [x] Corrigir o CSS check quebrado da Ravena (`display==''` → checa `display:none` real + bg transparente)
- [x] Adicionar guardrail de comando destrutivo no Atlas (denylist + ecoar alvo + confirmação + pós-exec exit code + rollback seguro)
- [x] Shiva definida como **LÍDER/orquestradora** (decisão do Red) — convoca os outros 4
- [ ] `SHARK_METHOD_TECHNICAL_SPEC.md` — ainda focado em "Antigravity IDE / SDLC". Atualizar pro viés empresário + 2 pacotes (pendente, baixa prioridade)
- [ ] Garantir `.gitignore` cobrindo vault/secrets antes do push (verificar)

---

## 7. ORDEM SUGERIDA DE EXECUÇÃO

1. Red valida este plano.
2. Refatorar 1 agente piloto (sugiro RAVENA — prova que "chefinho" fica intacto enquanto corto o lixo).
3. Red aprova o padrão.
4. Refatorar os outros 4 seguindo o padrão.
5. Separar nos 2 pacotes.
6. Reescrever README + spec.
7. Push pro GitHub.

> Detalhes completos da auditoria: ver também o curso em
> `Starlight/.../conteudo/curso-shark-for-business/auditoria-agentes-shark.md`

---

## 8. AJUSTES DE PRECISÃO NA EXECUÇÃO (Hades — 02/06/2026)

Validação cruzada com os arquivos reais antes de aplicar. Três achados do plano foram refinados:

1. **Rename `agents/` → `agents-antigravity/` tinha efeito colateral não previsto.** Não eram só `install.ps1/sh` que apontavam pra `agents/` — também `shark-update.md` (2 blocos) e `setup-structure.ps1`. Corrigidas SÓ as referências de **origem** do download (`$RepoUrl/agents/`). Os paths de **destino** (`~/.gemini/agents/`, `~/.claude/agents/` em config/CLAUDE.md, GEMINI.md, shark-commands.md, TECHNICAL_SPEC) ficaram intactos — é onde a IDE lê após instalar.

2. **Achado "`~/.gemini` no pacote Claude" não se confirmou.** O pacote `agents-claude/` já estava limpo desse path (Atlas/Kerberos usavam `~/.claude/` corretamente). Não houve o que corrigir ali — era achado fantasma.

3. **"OWASP 2025 inventado" estava impreciso.** O problema real era a tabela rotulada "OWASP TOP 10 — 2025" com categorias reordenadas (não-oficial). Corrigido para **OWASP Top 10 2021** (versão estável oficial). As **CVEs de 2025** (ex.: CVE-2025-29927 do Next.js) são legítimas e foram **mantidas** — são checagens pontuais, separadas do Top 10.

**Decisões do Red durante a execução:**
- **Ravena:** charme + "chefinho" mantidos; duplo sentido sexual explícito **removido** (produto vendido a empresário e exibido em aula).
- **Browser:** **Playwright MCP nos 2 pacotes** (a API `browser.goto()` do pacote antigravity era fictícia — substituída).
- **Shiva é a LÍDER/orquestradora:** agente padrão que toma a frente e convoca os outros 4.
- **Jargão:** traduzir na voz, **manter** os blocos técnicos (fases, comandos, queries) nos bastidores.

> Trabalho aplicado na branch `feat/v4-edicao-empresario`. Revisar o diff antes do merge pra `main`.
