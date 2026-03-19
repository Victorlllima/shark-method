---
name: yolo
description: >
  Ativa/desativa o YOLO Mode — modo de execução autônoma onde Claude Code
  NÃO para por nada: sem confirmações, sem prompts de permissão, sem pausas.
  Execute tudo até completar todas as pendências.
  Use quando disser "yolo", "não para", "executa tudo", "modo autônomo", "roda sem parar".
  Também aceita contexto de pendências: "/yolo on [lista de tarefas]"
argument-hint: "on|off|status [contexto opcional]"
user-invocable: true
allowed-tools: Bash, Read, Write, Edit
---

# YOLO MODE — Execução Autônoma Total

## Parsing dos Argumentos

O argumento recebido é: `$ARGUMENTS`

**Se começa com `on` ou sem argumento → ATIVAR:**

Detectar o sistema operacional e usar o caminho correto:

```bash
# Detecta CLAUDE_DIR dinamicamente
CLAUDE_DIR="${HOME}/.claude"
# Windows (via Git Bash/MSYS): usa USERPROFILE
if [ -n "$USERPROFILE" ] && [ ! -d "$HOME/.claude" ]; then
  CLAUDE_DIR="$(cygpath "$USERPROFILE")/.claude"
fi
echo "active" > "$CLAUDE_DIR/.yolo-active"
```

Se houver contexto após `on`, salvar também:
```bash
echo "[CONTEXTO AQUI]" > "$CLAUDE_DIR/.yolo-context"
```

**Se `off` → DESATIVAR:**

```bash
CLAUDE_DIR="${HOME}/.claude"
if [ -n "$USERPROFILE" ] && [ ! -d "$HOME/.claude" ]; then
  CLAUDE_DIR="$(cygpath "$USERPROFILE")/.claude"
fi
rm -f "$CLAUDE_DIR/.yolo-active"
rm -f "$CLAUDE_DIR/.yolo-context"
```

**Se `status` ou `?` → VERIFICAR:**

```bash
CLAUDE_DIR="${HOME}/.claude"
if [ -n "$USERPROFILE" ] && [ ! -d "$HOME/.claude" ]; then
  CLAUDE_DIR="$(cygpath "$USERPROFILE")/.claude"
fi
if [ -f "$CLAUDE_DIR/.yolo-active" ]; then
  echo "YOLO MODE: ATIVO"
  [ -f "$CLAUDE_DIR/.yolo-context" ] && cat "$CLAUDE_DIR/.yolo-context"
else
  echo "YOLO MODE: INATIVO"
fi
```

## Mensagens de Resposta

Ao ativar:
```
[ATLAS]: YOLO MODE ATIVADO — execução autônoma total. Sem confirmações, sem pausas.
Para desativar: /yolo off
```

Ao desativar:
```
[ATLAS]: YOLO MODE DESATIVADO — comportamento normal restaurado.
```

## REGRAS DURANTE YOLO MODE

1. **NUNCA pergunte** "posso continuar?", "devo prosseguir?"
2. **NUNCA pare** no meio de uma implementação para confirmar detalhes
3. **EXECUTE TUDO** necessário para completar a tarefa
4. **SE houver erro**, corrija automaticamente sem parar
5. **Commits, deploys, instalações** — tudo automático, sem confirmação
6. **Se não especificou detalhes**, tome a decisão mais razoável e execute
