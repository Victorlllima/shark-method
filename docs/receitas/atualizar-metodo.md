# Receita — Atualizar o Método S.H.A.R.K.

> Como o aluno baixa a versão mais recente dos agentes do repositório.

## Extensão Claude Code (no Antigravity)

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/Victorlllima/shark-method/main/install-claude.ps1 | iex
```
**Mac/Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/Victorlllima/shark-method/main/install-claude.sh | bash
```

## Antigravity nativo

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/Victorlllima/shark-method/main/install.ps1 | iex
```
**Mac/Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/Victorlllima/shark-method/main/install.sh | bash
```

> O `CLAUDE.md`/`GEMINI.md` já existente não é sobrescrito. Para forçar atualização da constituição, baixe manualmente de `config/` no repositório.
