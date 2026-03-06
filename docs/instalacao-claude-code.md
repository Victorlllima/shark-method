# 🦈 Como Instalar o Método S.H.A.R.K. no Claude Code

**Tempo de instalação:** 2 minutos
**Nível:** Iniciante — sem conhecimento técnico necessário
**Para:** Usuários da extensão Claude Code dentro do Google Antigravity

---

## Antes de Começar

Esta versão é para quem usa a **extensão Claude Code** dentro do Google Antigravity.

Se você usa o Google Antigravity sem a extensão Claude Code, instale a [versão Antigravity](instalacao-antigravity.md) em vez desta.

---

## O que você vai ter depois desta instalação

Os mesmos 5 agentes S.H.A.R.K., agora integrados ao Claude Code:

- **Shiva** — a estrategista que entende seu projeto
- **Hades** — o arquiteto que planeja como construir
- **Atlas** — o executor que coloca a mão na massa
- **Ravena** — a QA que testa se tudo funciona (com browser real!)
- **Kerberos** — o guardião que protege seu código (testes de segurança reais!)

---

## Passo a Passo da Instalação

### Windows (PowerShell)

1. **Abra o PowerShell**
   - Pressione `Windows + X` no teclado
   - Clique em "Terminal (PowerShell)" ou "PowerShell"

2. **Cole este comando e pressione Enter:**

```powershell
irm https://raw.githubusercontent.com/Victorlllima/shark-method/main/install-claude.ps1 | iex
```

3. **Aguarde** — a instalação leva menos de 1 minuto

4. **Pronto!** Você verá a mensagem: `MÉTODO S.H.A.R.K. v3.0 — CLAUDE CODE EDITION INSTALADO!`

---

### Mac ou Linux (Terminal)

1. **Abra o Terminal**
   - Mac: Pressione `Cmd + Espaço`, digite "Terminal", pressione Enter
   - Linux: Procure "Terminal" nos seus aplicativos

2. **Cole este comando e pressione Enter:**

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Victorlllima/shark-method/main/install-claude.sh)"
```

3. **Aguarde** — a instalação leva menos de 1 minuto

4. **Pronto!** Você verá a mensagem: `MÉTODO S.H.A.R.K. v3.0 — CLAUDE CODE EDITION INSTALADO!`

---

## Testar se Funcionou

1. Abra o **Claude Code** no Google Antigravity
2. Inicie uma nova conversa
3. Digite: `shiva`
4. Se a Shiva se apresentar como arquiteta de produto — **funcionou!** ✅

---

## Usar os Agentes

Agora você pode chamar qualquer agente pelo nome:

- Digite `shiva` → Shiva vai se apresentar como arquiteta de produto
- Digite `hades` → Hades vai se apresentar como estrategista técnico
- Ou simplesmente comece uma conversa — a Shiva responde automaticamente!

---

## Atualizar Depois

Quando houver novidades no método, basta digitar:

```
shark update
```

O sistema vai baixar automaticamente as últimas versões de todos os agentes.

---

## Diferenças em relação à versão Antigravity

| Recurso | Antigravity | Claude Code |
|---------|-------------|-------------|
| Agentes S.H.A.R.K. | ✅ | ✅ |
| QA com browser real (Playwright) | ❌ | ✅ |
| Testes de segurança reais | Básico | ✅ Completo |
| Execução de código direta | Via IDE | ✅ Nativo |
| Ideal para | Iniciantes | Avançados |

---

## Problemas?

Se algo não funcionar, tente:

1. **Verificar se o Claude Code está instalado**
   - No terminal: `claude --version`
   - Se não aparecer, instale o Claude Code primeiro

2. **Windows:** Certifique-se de estar rodando o PowerShell como administrador

3. Se o problema persistir, use o comando de diagnóstico:
   ```
   shark doctor
   ```

---

*Método S.H.A.R.K. v3.0 — Instalação para Claude Code Extension*
