# 🐙 Receita: Configuração do MCP GitHub

Para que o Método S.H.A.R.K. possa criar repositórios, abrir PRs e gerenciar arquivos no seu GitHub, ele precisa de uma " chave mestra".

---

## 🎟️ PASSO 1: GERAR SEU TOKEN (O Acesso)

1.  Acesse seu GitHub > Clique na sua foto (canto superior direito) > **Settings**.
2.  No menu lateral esquerdo, role até o final e clique em **Developer Settings**.
3.  Vá em **Personal access tokens** > **Tokens (classic)**.
4.  Clique em **Generate new token** > **Generate new token (classic)**.
5.  Dê um nome (ex: `shark-method-ide`).
6.  **Selecione as permissões (Scopes):**
    *   `repo` (Tudo dentro de repo) - **OBRIGATÓRIO**
    *   `workflow` (Se for usar CI/CD)
    *   `admin:org` (Se você trabalha dentro de uma organização)
7.  Clique em **Generate token**.
8.  **COPIE O TOKEN AGORA!** Ele vai sumir para sempre se você fechar a página.

---

## 🖇️ PASSO 2: CONFIGURAR NA IDE

1.  Abra as configurações de **MCP Servers** na IDE.
2.  Adicione um novo servidor:
    *   **Nome:** `github`
    *   **Tipo:** `command`
    *   **Comando:** `npx -y @modelcontextprotocol/server-github`
3.  Adicione a **Variável de Ambiente**:
    *   `GITHUB_PERSONAL_ACCESS_TOKEN`: (Cole o token que você copiou aqui)

---

## ✅ PASSO 3: TESTAR

1.  Reinicie a IDE.
2.  Peça ao Atlas: "Crie um arquivo teste.txt no meu github".
3.  Se ele conseguir, você agora tem superpoderes de automação.

---

**😏 Nota do Hades:** "Lembre-se: quem guarda tokens no .env sem .gitignore está pedindo para ser hackeado. Eu não salvo ninguém que ignora as regras básicas de segurança."

**Última atualização:** Método S.H.A.R.K. v2.1
