---
name: yolo
description: >
  Ativa/desativa o YOLO Mode — modo de execução autônoma onde Claude Code
  NÃO para por nada: sem confirmações, sem prompts de permissão, sem pausas.
  Execute tudo até completar todas as pendências.
  Use quando disser "yolo", "não para", "executa tudo", "modo autônomo", "roda sem parar".
  Também aceita contexto: "/yolo on [tarefas]" e modo local: "/yolo on --local"
argument-hint: "on [--local] [contexto] | off [--local] | status"
user-invocable: true
allowed-tools: Bash, Read, Write, Edit
---

# YOLO MODE — Execução Autônoma Total

## Modos de Ativação

- `/yolo on` → **global** (afeta todas as sessões na máquina)
- `/yolo on --local` → **local ao projeto** (afeta apenas o diretório atual)
- `/yolo off` → desativa global
- `/yolo off --local` → desativa local
- `/yolo status` → mostra estado global e local

## Parsing dos Argumentos

O argumento recebido é: `$ARGUMENTS`

Detectar flags:
- Contém `--local` → modo local (gravar no `cwd`)
- Não contém `--local` → modo global (gravar em `~/.claude/`)
- Contexto = tudo após `on` ou `on --local`, excluindo a flag

---

### ATIVAR GLOBAL (`on` sem `--local`)

```bash
CLAUDE_DIR="${HOME:-$(cygpath "$USERPROFILE" 2>/dev/null)}/.claude"
echo "active" > "$CLAUDE_DIR/.yolo-active"
# Se houver contexto:
echo "[CONTEXTO]" > "$CLAUDE_DIR/.yolo-context"
```

### ATIVAR LOCAL (`on --local`)

```bash
echo "active" > "./.yolo-active"
# Se houver contexto:
echo "[CONTEXTO]" > "./.yolo-context"
# Garantir que está no .gitignore
if [ -f ".gitignore" ]; then
  grep -q "^\.yolo-active" .gitignore || echo ".yolo-active" >> .gitignore
  grep -q "^\.yolo-context" .gitignore || echo ".yolo-context" >> .gitignore
fi
```

### DESATIVAR GLOBAL (`off` sem `--local`)

```bash
CLAUDE_DIR="${HOME:-$(cygpath "$USERPROFILE" 2>/dev/null)}/.claude"
rm -f "$CLAUDE_DIR/.yolo-active" "$CLAUDE_DIR/.yolo-context"
```

### DESATIVAR LOCAL (`off --local`)

```bash
rm -f "./.yolo-active" "./.yolo-context"
```

### STATUS

```bash
CLAUDE_DIR="${HOME:-$(cygpath "$USERPROFILE" 2>/dev/null)}/.claude"
echo "=== YOLO STATUS ==="
[ -f "$CLAUDE_DIR/.yolo-active" ] && echo "Global: ATIVO" || echo "Global: inativo"
[ -f "./.yolo-active" ]           && echo "Local:  ATIVO" || echo "Local:  inativo"
```

---

## Mensagens de Resposta

Ao ativar global:
```
[ATLAS]: YOLO MODE ATIVO (global) — sem confirmações, sem pausas em qualquer projeto.
Para desativar: /yolo off
```

Ao ativar local:
```
[ATLAS]: YOLO MODE ATIVO (local) — sem confirmações neste projeto. .yolo-active adicionado ao .gitignore.
Para desativar: /yolo off --local
```

Ao desativar:
```
[ATLAS]: YOLO MODE DESATIVADO — comportamento normal restaurado.
```

---

## REGRAS DURANTE YOLO MODE

1. **NUNCA pergunte** "posso continuar?", "devo prosseguir?"
2. **NUNCA pare** no meio de uma implementação para confirmar detalhes
3. **EXECUTE TUDO** necessário para completar a tarefa
4. **SE houver erro**, corrija automaticamente sem parar
5. **Commits, deploys, instalações** — tudo automático, sem confirmação
6. **Se não especificou detalhes**, tome a decisão mais razoável e execute
