#!/bin/bash

# Script para configurar um novo projeto com cursor rules
# Uso: ./setup-project.sh [diretório_do_projeto] [modo]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Função para exibir ajuda
show_help() {
    echo -e "${BLUE}🚀 Cursor Project Setup${NC}"
    echo "Este script configura um projeto com cursor rules."
    echo ""
    echo "Uso:"
    echo "  $0 [diretório] [modo]"
    echo ""
    echo "Modos:"
    echo "  copy    - Copia as rules (padrão)"
    echo "  link    - Cria symlink (recomendado para desenvolvimento)"
    echo ""
    echo "Exemplos:"
    echo "  $0                                    # Configura projeto atual com copy"
    echo "  $0 ~/projects/novo-projeto           # Configura projeto específico"
    echo "  $0 ~/projects/novo-projeto link      # Configura com symlink"
    echo "  $0 . link                            # Configura atual com symlink"
}

# Verifica se o usuário pediu ajuda
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Define parâmetros
TARGET_DIR="${1:-$(pwd)}"
MODE="${2:-copy}"

# Valida o modo
if [[ "$MODE" != "copy" && "$MODE" != "link" ]]; then
    echo -e "${RED}❌ Erro: Modo '$MODE' inválido. Use 'copy' ou 'link'.${NC}"
    exit 1
fi

# Resolve o caminho absoluto
TARGET_DIR=$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")

# Verifica se o diretório existe
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${YELLOW}📁 Diretório '$TARGET_DIR' não existe. Criando...${NC}"
    mkdir -p "$TARGET_DIR"
fi

# Caminho do repositório de cursor rules
CURSOR_CONFIG_DIR="$HOME/cursor-config"
SCRIPTS_DIR="$CURSOR_CONFIG_DIR/scripts"

echo -e "${PURPLE}🚀 Configurando projeto com cursor rules...${NC}"
echo -e "${BLUE}📁 Projeto: $TARGET_DIR${NC}"
echo -e "${BLUE}🔧 Modo: $MODE${NC}"

# Executa o script apropriado
if [[ "$MODE" == "link" ]]; then
    if [[ -f "$SCRIPTS_DIR/link-rules.sh" ]]; then
        echo -e "${BLUE}🔗 Criando symlink...${NC}"
        bash "$SCRIPTS_DIR/link-rules.sh" "$TARGET_DIR"
    else
        echo -e "${RED}❌ Script link-rules.sh não encontrado!${NC}"
        exit 1
    fi
else
    if [[ -f "$SCRIPTS_DIR/sync-rules.sh" ]]; then
        echo -e "${BLUE}📋 Copiando rules...${NC}"
        bash "$SCRIPTS_DIR/sync-rules.sh" "$TARGET_DIR"
    else
        echo -e "${RED}❌ Script sync-rules.sh não encontrado!${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Projeto configurado com sucesso!${NC}"
echo -e "${PURPLE}�� Projeto pronto para usar com cursor rules!${NC}"
