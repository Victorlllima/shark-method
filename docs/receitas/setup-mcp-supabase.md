# 🛠️ Receita: Configuração do MCP Supabase

Este guia vai te ajudar a conectar o "cérebro" da IDE diretamente ao seu projeto no Supabase. Isso permite que o Atlas execute comandos no banco de dados sem que você precise abrir o painel do Supabase.

---

## 🔑 PASSO 1: OBTER SUAS CHAVES

1.  Acesse o seu [Dashboard do Supabase](https://supabase.com/dashboard/projects).
2.  Selecione o seu projeto.
3.  No menu lateral, vá em **Project Settings** (ícone de engrenagem) > **API**.
4.  Você vai precisar de dois valores:
    *   **Project URL** (Algo como `https://xyz.supabase.co`)
    *   **Service Role Key** (Clique em "reveal" para copiar. **CUIDADO**: Nunca compartilhe esta chave!)

---

## 🖇️ PASSO 2: CONFIGURAR NA IDE

1.  Abra as configurações de **MCP Servers** na sua IDE (Google Antigravity / Cursor).
2.  Adicione um novo servidor:
    *   **Nome:** `supabase`
    *   **Tipo:** `command`
    *   **Comando:** `npx -y @supabase/mcp-server`
3.  Adicione as **Variáveis de Ambiente**:
    *   `SUPABASE_URL`: (Cole sua Project URL aqui)
    *   `SUPABASE_SERVICE_ROLE_KEY`: (Cole sua Service Role Key aqui)

---

## ✅ PASSO 3: TESTAR

1.  Reinicie a IDE ou o servidor MCP.
2.  Digite no chat: `shark status`
3.  O Hades agora deve conseguir ler suas tabelas e esquemas automaticamente.

---

**💡 Dica do Hades:** "Se as chaves não funcionarem, ou você colou errado ou o universo está tentando te dizer algo. Tente colar novamente sem espaços extras."

**Última atualização:** Método S.H.A.R.K. v2.1
