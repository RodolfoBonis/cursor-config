#!/bin/bash

# Script para atualizar cursor rules centrais e aplicar no projeto atual
# Uso: ./cursor-update-rules.sh [sync|link] [diretório_do_projeto]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para exibir ajuda
show_help() {
    echo -e "${BLUE}🔄 Cursor Rules Update${NC}"
    echo "Este script atualiza as cursor rules centrais e as aplica no projeto."
    echo ""
    echo "Uso:"
    echo "  $0 [modo] [diretório_do_projeto]"
    echo ""
    echo "Modos:"
    echo "  sync    - Copia rules para o projeto (padrão)"
    echo "  link    - Cria symlink para o projeto"
    echo ""
    echo "Exemplos:"
    echo "  $0                           # Atualiza e aplica sync no diretório atual"
    echo "  $0 sync                      # Atualiza e aplica sync no diretório atual"
    echo "  $0 link                      # Atualiza e aplica link no diretório atual"
    echo "  $0 sync ~/projects/meu-projeto # Atualiza e aplica sync em projeto específico"
    echo "  $0 link ~/projects/meu-projeto # Atualiza e aplica link em projeto específico"
    echo ""
    echo "O script executa:"
    echo "  1. git pull no repositório cursor-config"
    echo "  2. Aplica as rules no projeto usando o modo especificado"
}

# Verifica se o usuário pediu ajuda
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Define o modo (sync ou link)
MODE=""
TARGET_DIR=""

# Parse dos argumentos
if [[ "$1" == "sync" || "$1" == "link" ]]; then
    MODE="$1"
    TARGET_DIR="${2:-$(pwd)}"
elif [[ -n "$1" && "$1" != "sync" && "$1" != "link" ]]; then
    # Se o primeiro argumento não é sync nem link, assume que é um diretório
    MODE="sync"
    TARGET_DIR="$1"
else
    # Sem argumentos, usa sync no diretório atual
    MODE="sync"
    TARGET_DIR="$(pwd)"
fi

# Resolve o caminho absoluto
TARGET_DIR=$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")

# Verifica se o diretório existe
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${RED}❌ Erro: Diretório '$TARGET_DIR' não existe!${NC}"
    exit 1
fi

# Caminho do repositório de cursor rules
CURSOR_CONFIG_DIR="$HOME/cursor-config"

# Verifica se o repositório de cursor rules existe
if [[ ! -d "$CURSOR_CONFIG_DIR" ]]; then
    echo -e "${RED}❌ Erro: Repositório cursor-config não encontrado em '$CURSOR_CONFIG_DIR'!${NC}"
    echo -e "${YELLOW}💡 Certifique-se de que o repositório cursor-config está em ~/cursor-config${NC}"
    exit 1
fi

echo -e "${CYAN}🚀 Cursor Rules Update${NC}"
echo -e "${BLUE}📂 Repositório: $CURSOR_CONFIG_DIR${NC}"
echo -e "${BLUE}🎯 Projeto: $TARGET_DIR${NC}"
echo -e "${BLUE}🔧 Modo: $MODE${NC}"
echo ""

# Passo 1: Atualizar o repositório cursor-config
echo -e "${YELLOW}📥 Passo 1: Atualizando repositório cursor-config...${NC}"
cd "$CURSOR_CONFIG_DIR"

# Verifica se é um repositório git
if [[ ! -d ".git" ]]; then
    echo -e "${RED}❌ Erro: '$CURSOR_CONFIG_DIR' não é um repositório git!${NC}"
    exit 1
fi

# Verifica mudanças locais não commitadas
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️  Aviso: Há mudanças não commitadas no repositório cursor-config.${NC}"
    echo -e "${YELLOW}   As mudanças locais serão preservadas.${NC}"
fi

# Faz o pull
echo -e "${BLUE}🔄 Executando git pull...${NC}"
if git pull; then
    echo -e "${GREEN}✅ Repositório atualizado com sucesso!${NC}"
else
    echo -e "${RED}❌ Erro ao atualizar repositório!${NC}"
    echo -e "${YELLOW}💡 Verifique se há conflitos ou problemas de conectividade.${NC}"
    exit 1
fi

echo ""

# Passo 2: Aplicar as rules no projeto
echo -e "${YELLOW}📋 Passo 2: Aplicando rules no projeto...${NC}"

# Determina qual script usar
if [[ "$MODE" == "link" ]]; then
    SCRIPT_PATH="$CURSOR_CONFIG_DIR/scripts/link-rules.sh"
    echo -e "${BLUE}🔗 Criando symlinks...${NC}"
else
    SCRIPT_PATH="$CURSOR_CONFIG_DIR/scripts/sync-rules.sh"
    echo -e "${BLUE}📋 Sincronizando arquivos...${NC}"
fi

# Verifica se o script existe
if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo -e "${RED}❌ Erro: Script '$SCRIPT_PATH' não encontrado!${NC}"
    exit 1
fi

# Executa o script
if bash "$SCRIPT_PATH" "$TARGET_DIR"; then
    echo ""
    echo -e "${GREEN}🎉 Atualização concluída com sucesso!${NC}"
    echo ""
    echo -e "${CYAN}📊 Resumo:${NC}"
    echo -e "   ${GREEN}✓${NC} Repositório cursor-config atualizado"
    echo -e "   ${GREEN}✓${NC} Rules aplicadas no projeto usando modo '$MODE'"
    echo -e "   ${GREEN}✓${NC} Projeto: $TARGET_DIR"
    
    # Informações adicionais baseadas no modo
    if [[ "$MODE" == "link" ]]; then
        echo ""
        echo -e "${YELLOW}💡 Modo symlink ativo:${NC}"
        echo -e "   - Atualizações futuras serão automáticas"
        echo -e "   - Adicione .cursor/rules ao .gitignore se necessário"
    else
        echo ""
        echo -e "${YELLOW}💡 Modo sync ativo:${NC}"
        echo -e "   - Execute 'cursor-update-rules' para futuras atualizações"
        echo -e "   - As rules foram copiadas e podem ser versionadas"
    fi
else
    echo -e "${RED}❌ Erro ao aplicar rules no projeto!${NC}"
    exit 1
fi 