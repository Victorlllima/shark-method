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
                                  
    MÉTODO S.H.A.R.K. v2.0
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

INSTALL_DIR="$HOME/.gemini"
REPO_URL="https://raw.githubusercontent.com/Victorlllima/shark-method/main"

echo -e "${YELLOW} Criando estrutura...${NC}"
mkdir -p "$INSTALL_DIR/commands"
mkdir -p "$INSTALL_DIR/agents"
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
  "current_version": "2.0",
  "last_update_check": "$(date +%Y-%m-%d)"
}
EOF
fi

echo -e "${YELLOW} Baixando arquivos...${NC}"

download_file "$REPO_URL/config/GEMINI.md" "$INSTALL_DIR/GEMINI.md"
download_file "$REPO_URL/commands/shark-commands.md" "$INSTALL_DIR/commands/shark-commands.md"
download_file "$REPO_URL/commands/shark-help.md" "$INSTALL_DIR/commands/shark-help.md"
download_file "$REPO_URL/commands/shark-status.md" "$INSTALL_DIR/commands/shark-status.md"
download_file "$REPO_URL/commands/yolo.md" "$INSTALL_DIR/commands/yolo.md"
download_file "$REPO_URL/agents-antigravity/shiva.md" "$INSTALL_DIR/agents/shiva.md"
download_file "$REPO_URL/agents-antigravity/hades.md" "$INSTALL_DIR/agents/hades.md"
download_file "$REPO_URL/agents-antigravity/ravena.md" "$INSTALL_DIR/agents/ravena.md"
download_file "$REPO_URL/agents-antigravity/kerberos.md" "$INSTALL_DIR/agents/kerberos.md"
download_file "$REPO_URL/agents-antigravity/atlas.md" "$INSTALL_DIR/agents/atlas.md"
download_file "$REPO_URL/scripts/shark-status.js" "$INSTALL_DIR/scripts/shark-status.js"
download_file "$REPO_URL/scripts/package.json" "$INSTALL_DIR/scripts/package.json"
download_file "$REPO_URL/scripts/shark-rename.ps1" "$INSTALL_DIR/scripts/shark-rename.ps1"
download_file "$REPO_URL/scripts/shark-rename.sh" "$INSTALL_DIR/scripts/shark-rename.sh"

chmod +x "$INSTALL_DIR/scripts/shark-status.js"

echo ""
echo -e "${GREEN} Instalação concluída!${NC}"
echo ""
echo -e "${CYAN}${NC}"
echo -e "${GREEN}    MÉTODO S.H.A.R.K. INSTALADO!${NC}"
echo -e "${CYAN}${NC}"
echo ""
echo -e "${YELLOW} Instalado em:${NC} ~/.gemini/"
echo ""
echo -e "${YELLOW} TESTAR AGORA:${NC}"
echo "   1. Abra o Google Antigravity"
echo "   2. Digite: shark ajuda"
echo "   3. Se aparecer a ajuda, FUNCIONOU! "
echo ""
