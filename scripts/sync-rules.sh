#!/bin/bash

# Script para sincronizar cursor rules para um projeto
# Uso: ./sync-rules.sh [diretório_do_projeto]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para exibir ajuda
show_help() {
    echo -e "${BLUE}🔄 Cursor Rules Sync${NC}"
    echo "Este script sincroniza as cursor rules do repositório central para um projeto."
    echo ""
    echo "Uso:"
    echo "  $0 [diretório_do_projeto]"
    echo ""
    echo "Exemplos:"
    echo "  $0                           # Sincroniza no diretório atual"
    echo "  $0 ~/projects/meu-projeto    # Sincroniza em projeto específico"
    echo "  $0 .                         # Sincroniza no diretório atual"
}

# Verifica se o usuário pediu ajuda
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Define o diretório de destino
TARGET_DIR="${1:-$(pwd)}"

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

# Verifica se existem rules para sincronizar
if [[ ! -d "$CURSOR_CONFIG_DIR/rules" ]] || [[ -z "$(ls -A "$CURSOR_CONFIG_DIR/rules" 2>/dev/null)" ]]; then
    echo -e "${RED}❌ Erro: Nenhuma rule encontrada em '$CURSOR_CONFIG_DIR/rules'!${NC}"
    exit 1
fi

echo -e "${BLUE}🔄 Sincronizando cursor rules...${NC}"
echo -e "${YELLOW}📂 Origem: $CURSOR_CONFIG_DIR/rules${NC}"
echo -e "${YELLOW}📁 Destino: $TARGET_DIR/.cursor/rules${NC}"

# Cria a estrutura .cursor/rules se não existir
mkdir -p "$TARGET_DIR/.cursor/rules"

# Conta arquivos para sincronizar
TOTAL_FILES=$(find "$CURSOR_CONFIG_DIR/rules" -name "*.mdc" | wc -l | tr -d ' ')

if [[ "$TOTAL_FILES" -eq 0 ]]; then
    echo -e "${RED}❌ Nenhum arquivo .mdc encontrado para sincronizar!${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Sincronizando $TOTAL_FILES arquivo(s)...${NC}"

# Copia todas as rules
cp "$CURSOR_CONFIG_DIR/rules"/*.mdc "$TARGET_DIR/.cursor/rules/" 2>/dev/null || {
    echo -e "${RED}❌ Erro ao copiar arquivos!${NC}"
    exit 1
}

# Lista os arquivos sincronizados
echo -e "${GREEN}✅ Rules sincronizadas com sucesso!${NC}"
echo -e "${BLUE}📁 Arquivos sincronizados:${NC}"

for file in "$TARGET_DIR/.cursor/rules"/*.mdc; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        echo -e "   ${GREEN}✓${NC} $filename"
    fi
done

# Verifica se é um repositório git
if [[ -d "$TARGET_DIR/.git" ]]; then
    cd "$TARGET_DIR"
    
    # Verifica se há mudanças nas rules
    if git status --porcelain .cursor/rules/ | grep -q .; then
        echo -e "${YELLOW}📝 Mudanças detectadas nas cursor rules do git.${NC}"
        echo -e "${BLUE}💡 Para committar as mudanças, execute:${NC}"
        echo -e "   cd '$TARGET_DIR'"
        echo -e "   git add .cursor/rules/"
        echo -e "   git commit -m 'chore: update cursor rules'"
    else
        echo -e "${GREEN}✅ Nenhuma mudança detectada no git.${NC}"
    fi
fi

echo -e "${GREEN}🎉 Sincronização concluída!${NC}"
