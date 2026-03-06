# 🦈 SHARK VERSION — Verificar Versão Instalada

## COMPORTAMENTO

Quando o usuário digitar `shark version` ou `/shark-version`:

1. **Verificar versão instalada** — ler `user_data.json`
2. **Buscar versão disponível** — ler `version.json` do GitHub (se possível)
3. **Comparar e informar**

## Protocolo de Verificação

### Para Google Antigravity:
```bash
# Ler versão instalada
cat ~/.gemini/version.json 2>/dev/null || echo "Versão não encontrada"

# Versão do usuário
cat ~/.gemini/memory/$USER/user_data.json 2>/dev/null | grep current_version
```

### Para Claude Code:
```bash
# Ler versão instalada
cat ~/.claude/version.json 2>/dev/null || echo "Versão não encontrada"

# Versão do usuário
cat ~/.claude/memory/$USER/user_data.json 2>/dev/null | grep current_version
```

## Resposta Padrão

```
🦈 MÉTODO S.H.A.R.K. — STATUS DA VERSÃO

📦 Versão instalada: [versão do user_data.json]
🌐 Versão disponível: [versão do GitHub]

[Se desatualizado:]
⚠️ Há uma atualização disponível!
Para atualizar: shark update

[Se atualizado:]
✅ Você está com a versão mais recente!
```
