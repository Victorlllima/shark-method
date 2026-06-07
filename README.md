<h1 align="center">🦈 Método S.H.A.R.K.</h1>

<p align="center">
  <strong>Uma equipe de 5 agentes de IA que automatiza a sua empresa.</strong><br>
  Você não aprende a programar. Você comanda especialistas que constroem por você.
</p>

<p align="center">
  <em>Edição Empresário · v4.0</em>
</p>

---

## O que é

O **Método S.H.A.R.K.** transforma a IA do seu editor em uma **equipe nomeada de 5 especialistas**, cada um com função, personalidade e skills curadas. Em vez de uma IA genérica que faz tudo mais ou menos, você ganha cinco que fazem cada coisa bem — e conversam entre si seguindo um fluxo de trabalho profissional.

O foco não é virar programador. É ser o **dono que automatiza o próprio negócio**: você descreve a dor (o processo que te trava), e a equipe arquiteta, constrói, testa e protege a solução — falando com você em linguagem de negócio, não em jargão técnico.

## A equipe

| Agente | Papel | O que faz por você |
|--------|-------|--------------------|
| 💡 **SHIVA** | Líder & Arquiteta de Produto | Conduz a descoberta pela **dor**, desenha a solução e o visual, prioriza o que entra na 1ª versão. É quem **lidera e convoca os outros**. |
| 🔥 **HADES** | Estrategista Técnico | Transforma a visão num plano de execução claro — e te explica o que cada etapa significa pro seu negócio. |
| ⚙️ **ATLAS** | Executor | Constrói o que foi planejado e te mostra **funcionando** — sem encher você de terminal. |
| 🔍 **RAVENA** | QA | Testa como se fosse o seu cliente mais exigente. Garante que **não vai quebrar na frente de quem importa**. |
| 🛡️ **KERBEROS** | Segurança | Audita se é seguro antes de você botar os dados dos seus clientes no ar. Se alguém conseguir invadir, ele trava. |

> O fluxo: **S**hiva especifica → **H**ades planeja → **A**tlas executa → **R**avena revisa → **K**erberos protege.

## Os 2 pacotes

O método vem em duas edições — mesmo núcleo, ferramentas afinadas pro seu ambiente:

- **`agents-antigravity/`** — para quem usa as **IAs nativas do Google Antigravity** (constituição `GEMINI.md`, memória em `~/.gemini/`).
- **`agents-claude/`** — para quem roda a **extensão Claude Code dentro do Antigravity** (constituição `CLAUDE.md`, memória em `~/.claude/`, skills e subagents).

A personalidade e o fluxo S→H→A→R→K são idênticos nos dois. Só mudam as ferramentas, os caminhos e o arquivo de constituição.

## Instalação (Windows · PowerShell)

**Antigravity nativo:**
```powershell
irm https://raw.githubusercontent.com/Victorlllima/shark-method/main/install.ps1 | iex
```

**Extensão Claude Code no Antigravity** ⭐ recomendado:
```powershell
irm https://raw.githubusercontent.com/Victorlllima/shark-method/main/install-claude.ps1 | iex
```

**Mac / Linux (Terminal):**
```bash
# Antigravity nativo
curl -fsSL https://raw.githubusercontent.com/Victorlllima/shark-method/main/install.sh | bash
# Extensão Claude Code
curl -fsSL https://raw.githubusercontent.com/Victorlllima/shark-method/main/install-claude.sh | bash
```

Depois de instalar, abra a IDE e digite **`shiva`** — a líder se apresenta e conduz a partir daí.

## O diferencial

Qualquer um ensina "use IA pra programar". O Método S.H.A.R.K. entrega **5 agentes nomeados, com personalidade e skills curadas, que já chegam treinados** — a Ravena já sabe testar, o Kerberos já sabe auditar. Você não configura nada. É uma equipe pronta, não um chat genérico.

## Estrutura do repositório

```
agents-antigravity/   → os 5 agentes (edição Antigravity nativo)
agents-claude/        → os 5 agentes (edição Claude Code)
commands/             → comandos /shark-*
config/               → constituições GEMINI.md e CLAUDE.md
docs/receitas/        → receitas black-box (vault, ferramentas, setup)
install*.ps1 / .sh    → instaladores
```

---

<p align="center">
  Feito por <strong>RedPro AI Academy</strong> · Método S.H.A.R.K. 🦈
</p>
