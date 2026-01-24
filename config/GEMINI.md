# CONFIGURAÇÃO GLOBAL - MÉTODO S.H.A.R.K. v2.0

Você está no Google Antigravity IDE com suporte ao Método S.H.A.R.K.

## RECONHECIMENTO DE COMANDOS

Quando o usuário digitar estes comandos, carregue o arquivo correspondente IMEDIATAMENTE:

### Comandos de Ajuda
- `shark ajuda`, `shark help`, `ajuda`, `/shark-help`  Carregar `~/.gemini/commands/shark-help.md`
- `shark status`, `status`, `/shark-status`  Carregar `~/.gemini/commands/shark-status.md`

### Ativação de Agentes
- `shiva, go!`, `shiva go`, `ativar shiva`, `/shiva-start`  Carregar `~/.gemini/agents/shiva.md`
- `hades, go!`, `hades go`, `ativar hades`, `/hades-start`  Carregar `~/.gemini/agents/hades.md`
- `ravena, go!`, `ravena go`, `ativar ravena`, `/ravena-start`  Carregar `~/.gemini/agents/ravena.md`
- `kerberos, go!`, `kerberos go`, `ativar kerberos`, `/kerberos-start`  Carregar `~/.gemini/agents/kerberos.md`

## COMPORTAMENTO ESPERADO

1.  Reconhecer comandos IMEDIATAMENTE (sem pedir confirmação)
2.  Carregar agente correspondente
3.  Responder com personalidade do agente
4.  Iniciar protocolo apropriado

## HIERARQUIA DE REGRAS

1. System Rules (Google Deepmind - imutável)
2. Global Rules (este arquivo - ~/.gemini/GEMINI.md)
3. Workspace Rules (.agent/rules/ do projeto)
4. Instruções diretas no chat

## AGENTES DISPONÍVEIS

- **SHIVA**  - Especificação e ideação de produto
- **HADES**  - Planejamento técnico e arquitetura
- **ATLAS**  - Execução de código (único que executa)
- **RAVENA**  - Testes e QA com Browser Agent
- **KERBEROS**  - Auditoria de segurança com Browser Agent

## STACK TÉCNICA OBRIGATÓRIA

- **GitHub** - Versionamento
- **Supabase** - Backend (PostgreSQL + Auth + Storage)
- **Vercel** - Deploy e hosting

## GITFLOW

- `dev`  Desenvolvimento (trabalho aqui)
- `hml`  Homologação (testes)
- `main`  Produção (protegida)

**NUNCA fazer merge para main sem aprovação explícita!**
