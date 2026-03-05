# 🦈 SHARK DOCTOR — Diagnóstico da Instalação

## COMPORTAMENTO

Quando o usuário digitar `shark doctor` ou `/shark-doctor`:

Execute uma sequência de verificações e reporte os resultados.

## Protocolo de Diagnóstico

### Para Google Antigravity:

**Verificar se agentes estão instalados:**
```bash
echo "=== 🦈 SHARK DOCTOR ==="
echo ""

# Verificar agentes
MISSING_AGENTS=0
for agent in shiva hades atlas ravena kerberos; do
    if [ -f "$HOME/.gemini/agents/$agent.md" ]; then
        echo "✅ Agente $agent: instalado"
    else
        echo "❌ Agente $agent: AUSENTE"
        MISSING_AGENTS=$((MISSING_AGENTS+1))
    fi
done

echo ""

# Verificar user_data.json
USER_DATA="$HOME/.gemini/memory/$USER/user_data.json"
if [ -f "$USER_DATA" ]; then
    NAME=$(cat "$USER_DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('name',''))" 2>/dev/null)
    if [ -n "$NAME" ] && [ "$NAME" != "" ]; then
        echo "✅ Perfil do usuário: configurado (nome: $NAME)"
    else
        echo "⚠️ Perfil do usuário: existe mas nome está vazio"
    fi
else
    echo "❌ Perfil do usuário: AUSENTE"
fi

echo ""

# Versão instalada
VERSION=$(cat "$HOME/.gemini/version.json" 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('version','desconhecida'))" 2>/dev/null || echo "desconhecida")
echo "📦 Versão instalada: $VERSION"

echo ""

# Resultado
if [ $MISSING_AGENTS -eq 0 ]; then
    echo "✅ DIAGNÓSTICO: Instalação OK!"
else
    echo "❌ DIAGNÓSTICO: $MISSING_AGENTS agente(s) faltando. Execute: shark update"
fi
```

### Para Claude Code:
Mesma lógica mas usando `~/.claude/` em vez de `~/.gemini/`

```bash
echo "=== 🦈 SHARK DOCTOR ==="
echo ""

# Verificar agentes
MISSING_AGENTS=0
for agent in shiva hades atlas ravena kerberos; do
    if [ -f "$HOME/.claude/agents/$agent.md" ]; then
        echo "✅ Agente $agent: instalado"
    else
        echo "❌ Agente $agent: AUSENTE"
        MISSING_AGENTS=$((MISSING_AGENTS+1))
    fi
done

echo ""

# Verificar user_data.json
USER_DATA="$HOME/.claude/memory/$USER/user_data.json"
if [ -f "$USER_DATA" ]; then
    NAME=$(cat "$USER_DATA" | python3 -c "import sys,json; print(json.load(sys.stdin).get('name',''))" 2>/dev/null)
    if [ -n "$NAME" ] && [ "$NAME" != "" ]; then
        echo "✅ Perfil do usuário: configurado (nome: $NAME)"
    else
        echo "⚠️ Perfil do usuário: existe mas nome está vazio"
    fi
else
    echo "❌ Perfil do usuário: AUSENTE"
fi

echo ""

# Versão instalada
VERSION=$(cat "$HOME/.claude/version.json" 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('version','desconhecida'))" 2>/dev/null || echo "desconhecida")
echo "📦 Versão instalada: $VERSION"

echo ""

# Resultado
if [ $MISSING_AGENTS -eq 0 ]; then
    echo "✅ DIAGNÓSTICO: Instalação OK!"
else
    echo "❌ DIAGNÓSTICO: $MISSING_AGENTS agente(s) faltando. Execute: shark update"
fi
```

## Resposta Padrão

```
🦈 SHARK DOCTOR — Diagnóstico da Instalação

Verificando agentes:
✅ Shiva: instalada
✅ Hades: instalado
✅ Atlas: instalado
✅ Ravena: instalada
✅ Kerberos: instalado

Verificando perfil:
✅ user_data.json: encontrado
✅ Nome configurado: [NOME]

Versão instalada: 3.0.0

━━━━━━━━━━━━━━━━
✅ Tudo funcionando! Para atualizar: shark update
```
