#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}"
cat << "EOF"
   _____ __  _____    ____  __ __
  / ___// / / /   |  / __ \/ //_/
  \__ \/ /_/ / /| | / /_/ / ,<
 ___/ / __  / ___ |/ _, _/ /| |
/____/_/ /_/_/  |_/_/ |_/_/ |_|

    MÉTODO S.H.A.R.K. v3.0
    Claude Code Edition
EOF
echo -e "${NC}"
echo ""

if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
    echo -e "${RED} Erro: curl ou wget não encontrado.${NC}"
    exit 1
fi

download_file() {
    local url=$1
    local output=$2
    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$output"
    else
        wget -q "$url" -O "$output"
    fi
}

INSTALL_DIR="$HOME/.claude"
REPO_URL="https://raw.githubusercontent.com/Victorlllima/shark-method/main"

echo -e "${YELLOW} Criando estrutura...${NC}"
mkdir -p "$INSTALL_DIR/agents"
mkdir -p "$INSTALL_DIR/commands"
mkdir -p "$INSTALL_DIR/scripts"

# Criar estrutura de memória do usuário
USERNAME=$(whoami)
MEMORY_DIR="$INSTALL_DIR/memory/$USERNAME"
mkdir -p "$MEMORY_DIR/projects"
mkdir -p "$MEMORY_DIR/interactions"

USER_DATA_PATH="$MEMORY_DIR/user_data.json"
if [ ! -f "$USER_DATA_PATH" ]; then
    cat > "$USER_DATA_PATH" << EOF
{
  "name": "$USERNAME",
  "bio": "",
  "preferences": {},
  "current_version": "3.0",
  "last_update_check": "$(date +%Y-%m-%d)"
}
EOF
fi

echo -e "${YELLOW} Baixando agentes S.H.A.R.K. (versão Claude Code)...${NC}"

download_file "$REPO_URL/agents-claude/shiva.md" "$INSTALL_DIR/agents/shiva.md"
download_file "$REPO_URL/agents-claude/hades.md" "$INSTALL_DIR/agents/hades.md"
download_file "$REPO_URL/agents-claude/atlas.md" "$INSTALL_DIR/agents/atlas.md"
download_file "$REPO_URL/agents-claude/ravena.md" "$INSTALL_DIR/agents/ravena.md"
download_file "$REPO_URL/agents-claude/kerberos.md" "$INSTALL_DIR/agents/kerberos.md"

echo -e "${YELLOW} Baixando comandos...${NC}"

download_file "$REPO_URL/commands/shark-commands.md" "$INSTALL_DIR/commands/shark-commands.md"
download_file "$REPO_URL/commands/shark-help.md" "$INSTALL_DIR/commands/shark-help.md"
download_file "$REPO_URL/commands/shark-status.md" "$INSTALL_DIR/commands/shark-status.md"
download_file "$REPO_URL/commands/shark-version.md" "$INSTALL_DIR/commands/shark-version.md"
download_file "$REPO_URL/commands/shark-doctor.md" "$INSTALL_DIR/commands/shark-doctor.md"

# Instalar CLAUDE.md apenas se não existir (não sobrescrever config personalizada)
CLAUDE_MD="$INSTALL_DIR/CLAUDE.md"
if [ ! -f "$CLAUDE_MD" ]; then
    echo -e "${YELLOW} Instalando configuração global...${NC}"
    download_file "$REPO_URL/config/CLAUDE.md" "$CLAUDE_MD"
    echo -e "${GREEN} CLAUDE.md instalado.${NC}"
else
    echo -e "${YELLOW} CLAUDE.md já existe — não sobrescrevendo.${NC}"
    echo -e "${YELLOW} Para atualizar manualmente, baixe: $REPO_URL/config/CLAUDE.md${NC}"
fi

echo ""
echo -e "${GREEN} Instalação concluída!${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}    MÉTODO S.H.A.R.K. v3.0 — CLAUDE CODE EDITION INSTALADO!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW} Instalado em:${NC} ~/.claude/"
echo ""
echo -e "${YELLOW} TESTAR AGORA:${NC}"
echo "   1. Abra o Claude Code no Google Antigravity"
echo "   2. Digite: shiva"
echo "   3. A Shiva vai se apresentar como arquiteta de produto"
echo "   4. Se funcionar, está pronto!"
echo ""
echo -e "${YELLOW} Para atualizar depois:${NC} shark update"
echo ""
