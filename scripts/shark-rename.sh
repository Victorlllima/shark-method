#!/bin/bash

# ========================================
#  SHARK RENAME - Personalizar seu Nome
#  Método S.H.A.R.K. v3.0
# ========================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
WHITE='\033[1;37m'
NC='\033[0m'

clear
echo -e "${CYAN}"
cat << "EOF"

   _____ __  _____    ____  __ __
  / ___// / / /   |  / __ \/ //_/
  \__ \/ /_/ / /| | / /_/ / ,<
 ___/ / __  / ___ |/ _, _/ /| |
/____/_/ /_/_/  |_/_/ |_/_/ |_|

    SHARK RENAME - Personalizar Nome

EOF
echo -e "${NC}"

# ── Detectar qual AI está instalada ──────────────────────────────
GEMINI_DIR="$HOME/.gemini"
CLAUDE_DIR="$HOME/.claude"

HAS_GEMINI=false
HAS_CLAUDE=false

[ -f "$GEMINI_DIR/GEMINI.md" ] && HAS_GEMINI=true
[ -f "$CLAUDE_DIR/CLAUDE.md" ] && HAS_CLAUDE=true

if [ "$HAS_GEMINI" = false ] && [ "$HAS_CLAUDE" = false ]; then
    echo -e "${RED} Método S.H.A.R.K. não encontrado.${NC}"
    echo -e "${YELLOW} Execute o instalador primeiro.${NC}"
    exit 1
fi

# ── Perguntar o nome desejado ─────────────────────────────────────
echo ""
echo -e "${GREEN} Ola! A Shiva vai te chamar pelo nome que VOCE escolher.${NC}"
echo ""
read -p " Qual nome voce quer usar com os agentes? " NOME_DESEJADO
NOME_DESEJADO=$(echo "$NOME_DESEJADO" | xargs)  # trim whitespace

if [ -z "$NOME_DESEJADO" ]; then
    echo -e "${RED} Nenhum nome digitado. Operacao cancelada.${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN} Confirmacao: os agentes vao te chamar de '${NOME_DESEJADO}'${NC}"
read -p " Confirmar? (s/n) " CONFIRM

if [[ ! "$CONFIRM" =~ ^[sS] ]]; then
    echo -e "${YELLOW} Operacao cancelada.${NC}"
    exit 0
fi

# ── Função para atualizar user_data.json ─────────────────────────
update_user_data() {
    local dir="$1"
    local label="$2"

    # Busca recursiva por user_data.json
    local files
    files=$(find "$dir" -name "user_data.json" 2>/dev/null)

    if [ -z "$files" ]; then
        # Criar se não existir
        local user_folder="$dir/$(whoami)"
        mkdir -p "$user_folder"
        local data_path="$user_folder/user_data.json"
        cat > "$data_path" << EOF
{
  "name": "$NOME_DESEJADO",
  "bio": "",
  "preferences": {},
  "current_version": "3.0",
  "last_update_check": "$(date +%Y-%m-%d)"
}
EOF
        echo -e "${GREEN} [$label] Perfil criado com nome '$NOME_DESEJADO'${NC}"
    else
        while IFS= read -r file; do
            # Extrai nome antigo
            NOME_ANTIGO=$(python3 -c "import json,sys; d=json.load(open('$file')); print(d.get('name','?'))" 2>/dev/null || echo "?")

            # Atualiza campo name usando python3 (disponível em Mac/Linux)
            python3 - "$file" "$NOME_DESEJADO" << 'PYEOF'
import json, sys
path = sys.argv[1]
novo_nome = sys.argv[2]
with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)
data['name'] = novo_nome
with open(path, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
PYEOF

            echo -e "${GREEN} [$label] '$NOME_ANTIGO' substituido por '$NOME_DESEJADO' em $file${NC}"
        done <<< "$files"
    fi
}

# ── Executar atualização ──────────────────────────────────────────
[ "$HAS_GEMINI" = true ] && update_user_data "$GEMINI_DIR/memory" "Gemini"
[ "$HAS_CLAUDE" = true ] && update_user_data "$CLAUDE_DIR/memory" "Claude"

# ── Resultado ────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  PRONTO! Nome atualizado com sucesso!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}  Os agentes vao te chamar de: $NOME_DESEJADO${NC}"
echo ""
echo -e "${WHITE}  Reinicie o Gemini/Claude Code para aplicar.${NC}"
echo ""
