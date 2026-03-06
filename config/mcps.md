# MCPs DISPONÍVEIS — MÉTODO S.H.A.R.K. v3.0

> **LEITURA OBRIGATÓRIA** para todos os agentes antes de qualquer tarefa.
> **REGRA DE OURO**: Antes de pedir ao usuário para fazer qualquer coisa manualmente,
> verifique se existe um MCP neste arquivo que execute a tarefa automaticamente.
> Se existir: USE. Se não existir: execute via terminal (`run_command` / Bash).
> **NUNCA** liste tarefas para o usuário executar se você pode fazer por ele.

---

## 🔄 PROTOCOLO DE ATUALIZAÇÃO DESTE ARQUIVO

Quando um novo MCP for instalado (pelo usuário ou pelo Atlas):
1. O **Atlas** adiciona o MCP neste arquivo imediatamente após a instalação
2. Formato: nome, categoria, descrição, ferramentas disponíveis, quando usar
3. Commit: `chore: adiciona MCP [nome] ao inventário`

---

## 📦 MCPs INSTALADOS

### 🖥️ HETZNER CLOUD
**Categoria:** Infraestrutura / Cloud
**Quando usar:** Criar servidores, bancos de dados, volumes, redes na Hetzner. Sempre que o projeto usar Hetzner como backend de infraestrutura.
**Ferramentas disponíveis:**
- Criar/listar/deletar servidores
- Criar/listar/deletar databases (PostgreSQL, MySQL)
- Gerenciar volumes, firewalls, redes privadas
- Consultar status e métricas de recursos

**Chave necessária:** `hetzner_api_token` (verificar vault antes de pedir ao usuário)

---

### 🔍 CONTEXT7
**Categoria:** Documentação / Pesquisa
**Quando usar:** Buscar documentação atualizada de bibliotecas, frameworks e ferramentas. Use antes de implementar qualquer integração com lib externa.
**Ferramentas disponíveis:**
- Resolver ID de biblioteca
- Consultar docs e exemplos de código atualizados

**Chave necessária:** Nenhuma (gratuito)

---

### 🎭 PLAYWRIGHT MCP
**Categoria:** Browser Automation / QA
**Quando usar:** Testes E2E, automação de browser, validação de UI, captura de screenshots. Usado principalmente pela **Ravena**.
**Ferramentas disponíveis:**
- Navegar para URLs
- Clicar em elementos
- Preencher formulários
- Tirar screenshots
- Inspecionar DOM (snapshot)
- Ler console e network requests

**Chave necessária:** Nenhuma

---

### 🔧 CHROME DEVTOOLS MCP
**Categoria:** Debug / Browser
**Quando usar:** Debug de frontend em tempo real, inspecionar console errors, network requests, avaliar JavaScript na página. Use sempre que Red reportar erro visual ou comportamental no browser.
**Ferramentas disponíveis:**
- Conectar ao Chrome em execução
- Ler logs do console (errors, warnings)
- Inspecionar network requests
- Executar JavaScript na página
- Capturar screenshots do estado atual

**Chave necessária:** Nenhuma

---

### 💬 EVOLUTION API (WhatsApp)
**Categoria:** Mensageria / Automação
**Quando usar:** Enviar mensagens WhatsApp, gerenciar instâncias, configurar webhooks, enviar mídia. Quando o projeto tiver integração com WhatsApp via Evolution API.
**Ferramentas disponíveis:**
- Criar/conectar/deletar instâncias WhatsApp
- Enviar texto, mídia, áudio, sticker, localização
- Configurar webhooks
- Buscar contatos, grupos, chats
- Enviar enquetes, listas, botões

**Chave necessária:** `evolution_api_url` + `evolution_api_key` (verificar vault)

---

## 🔒 MCPs SEM TOKEN (CLIs locais — usados pelo Kerberos)

| Ferramenta | Função | Como usar |
|------------|--------|-----------|
| `trufflehog` | Detecta secrets no histórico Git | `trufflehog git file://.` |
| `semgrep` | Análise estática de vulnerabilidades | `semgrep --config=auto .` |
| `nuclei` | Scanner de CVEs e misconfigurations | `nuclei -u [URL]` |

---

## ➕ COMO ADICIONAR UM NOVO MCP

Quando Red instalar um novo MCP, o Atlas deve adicionar aqui no formato:

```markdown
### [NOME DO MCP]
**Categoria:** [Infraestrutura / QA / Mensageria / IA / etc]
**Quando usar:** [descrever o contexto de uso em 1-2 linhas]
**Ferramentas disponíveis:**
- [ferramenta 1]
- [ferramenta 2]
**Chave necessária:** [nome da chave no vault] ou "Nenhuma"
```

---

## ⚠️ MCPs PLANEJADOS (não instalados ainda)

| MCP | Uso | Status |
|-----|-----|--------|
| Supabase MCP | Operações diretas no Supabase | Usar `npx supabase` via terminal por enquanto |
| GitHub MCP | PR, issues, releases | Usar `gh` via terminal por enquanto |
| Stripe MCP | Pagamentos | Usar SDK via código por enquanto |
