#!/bin/bash

# Script para criar symlink das cursor rules
# Uso: ./link-rules.sh [diretório_do_projeto]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para exibir ajuda
show_help() {
    echo -e "${BLUE}🔗 Cursor Rules Link${NC}"
    echo "Este script cria um symlink das cursor rules do repositório central para um projeto."
    echo "Útil para desenvolvimento, pois mantém as rules sempre atualizadas automaticamente."
    echo ""
    echo "Uso:"
    echo "  $0 [diretório_do_projeto]"
    echo ""
    echo "Exemplos:"
    echo "  $0                           # Cria symlink no diretório atual"
    echo "  $0 ~/projects/meu-projeto    # Cria symlink em projeto específico"
    echo "  $0 .                         # Cria symlink no diretório atual"
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

# Verifica se existem rules para linkear
if [[ ! -d "$CURSOR_CONFIG_DIR/rules" ]] || [[ -z "$(ls -A "$CURSOR_CONFIG_DIR/rules" 2>/dev/null)" ]]; then
    echo -e "${RED}❌ Erro: Nenhuma rule encontrada em '$CURSOR_CONFIG_DIR/rules'!${NC}"
    exit 1
fi

echo -e "${BLUE}🔗 Criando symlink das cursor rules...${NC}"
echo -e "${YELLOW}📂 Origem: $CURSOR_CONFIG_DIR/rules${NC}"
echo -e "${YELLOW}📁 Destino: $TARGET_DIR/.cursor/rules${NC}"

# Cria o diretório .cursor se não existir
mkdir -p "$TARGET_DIR/.cursor"

# Remove o diretório rules se existir (para evitar conflitos)
if [[ -d "$TARGET_DIR/.cursor/rules" ]] || [[ -L "$TARGET_DIR/.cursor/rules" ]]; then
    echo -e "${YELLOW}⚠️  Removendo diretório/symlink existente...${NC}"
    rm -rf "$TARGET_DIR/.cursor/rules"
fi

# Cria o symlink
ln -s "$CURSOR_CONFIG_DIR/rules" "$TARGET_DIR/.cursor/rules"

# Verifica se o symlink foi criado corretamente
if [[ -L "$TARGET_DIR/.cursor/rules" ]] && [[ -d "$TARGET_DIR/.cursor/rules" ]]; then
    echo -e "${GREEN}✅ Symlink criado com sucesso!${NC}"
    
    # Lista os arquivos disponíveis através do symlink
    echo -e "${BLUE}📁 Arquivos disponíveis:${NC}"
    for file in "$TARGET_DIR/.cursor/rules"/*.mdc; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            echo -e "   ${GREEN}✓${NC} $filename"
        fi
    done
    
    echo -e "${BLUE}💡 As rules agora são atualizadas automaticamente quando você modificar o repositório central!${NC}"
else
    echo -e "${RED}❌ Erro ao criar symlink!${NC}"
    exit 1
fi

# Verifica se é um repositório git
if [[ -d "$TARGET_DIR/.git" ]]; then
    echo -e "${YELLOW}📝 Lembre-se de adicionar .cursor/rules ao .gitignore se necessário.${NC}"
    echo -e "${BLUE}💡 Para adicionar ao .gitignore:${NC}"
    echo -e "   echo '.cursor/rules' >> '$TARGET_DIR/.gitignore'"
fi

echo -e "${GREEN}🎉 Symlink criado com sucesso!${NC}"
