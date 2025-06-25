# 🔄 Cursor Rules Centralizadas

Repositório central para compartilhar **Cursor Rules** entre múltiplos projetos, eliminando a necessidade de duplicar configurações.

## 📋 Estrutura

```
cursor-config/
├── rules/                     # 📁 Cursor rules centralizadas
│   ├── commit-flow.mdc        # ⚡ Automação de commits convencionais
│   ├── pr-analysis.mdc        # 🔍 Análise detalhada de PRs
│   └── pr-creation.mdc        # 🚀 Criação automática de PRs
├── scripts/                   # 🛠️ Scripts de automação
│   ├── cursor-update-rules.sh # 🔄 Atualiza repo e aplica rules automaticamente
│   ├── sync-rules.sh          # 📋 Sincroniza rules (copia arquivos)
│   ├── link-rules.sh          # 🔗 Cria symlinks (atualização automática)
│   └── setup-project.sh       # 🚀 Configura projeto completo
└── templates/                 # 📝 Templates para novos projetos
```

## 🚀 Instalação Rápida

### 1. Clone este repositório
```bash
cd ~
git clone <seu-repositorio> cursor-config
# ou se ainda não tiver um repo remoto:
# O repositório já foi criado em ~/cursor-config
```

### 2. Configure aliases úteis
Adicione ao seu `~/.zshrc` ou `~/.bashrc`:

```bash
# Cursor Rules - Aliases
alias cursor-sync="~/cursor-config/scripts/sync-rules.sh"
alias cursor-link="~/cursor-config/scripts/link-rules.sh"
alias cursor-setup="~/cursor-config/scripts/setup-project.sh"
alias cursor-update="~/cursor-config/scripts/cursor-update-rules.sh"
alias cursor-edit="code ~/cursor-config/rules"
```

Recarregue o terminal:
```bash
source ~/.zshrc  # ou source ~/.bashrc
```

## 📖 Como Usar

### 🔄 Opção 1: Sincronização (Cópia)
Ideal para projetos em equipe onde você quer versionar as rules com o código:

```bash
# No diretório do seu projeto
cursor-sync

# Ou especificando um diretório
cursor-sync ~/projects/meu-projeto
```

### 🔗 Opção 2: Symlink (Recomendado)
Ideal para desenvolvimento pessoal - as rules são sempre atualizadas automaticamente:

```bash
# No diretório do seu projeto
cursor-link

# Ou especificando um diretório
cursor-link ~/projects/meu-projeto
```

### 🚀 Opção 3: Configuração Completa
Configura um projeto novo ou existente:

```bash
# Projeto atual com cópia
cursor-setup

# Projeto específico com symlink
cursor-setup ~/projects/novo-projeto link

# Projeto atual com symlink
cursor-setup . link
```

## 🛠️ Scripts Disponíveis

### `cursor-update-rules.sh` - Atualização Completa
- ✅ Atualiza repositório cursor-config (git pull)
- ✅ Aplica rules no projeto (sync ou link)
- ✅ Processo automatizado em 2 passos
- ✅ Suporte para múltiplos modos

**Uso:**
```bash
./scripts/cursor-update-rules.sh [sync|link] [diretório]
./scripts/cursor-update-rules.sh --help

# Exemplos
cursor-update                    # Atualiza e aplica sync no atual
cursor-update link               # Atualiza e aplica link no atual  
cursor-update sync ~/projeto     # Atualiza e aplica sync em projeto
```

### `sync-rules.sh` - Sincronização
- ✅ Copia rules para `.cursor/rules/`
- ✅ Verifica mudanças no git
- ✅ Suporte para múltiplos arquivos `.mdc`
- ✅ Validação de erros

**Uso:**
```bash
./scripts/sync-rules.sh [diretório]
./scripts/sync-rules.sh --help
```

### `link-rules.sh` - Symlinks
- ✅ Cria symlink para atualização automática
- ✅ Remove links/diretórios conflitantes
- ✅ Orientação sobre `.gitignore`
- ✅ Validação de symlinks

**Uso:**
```bash
./scripts/link-rules.sh [diretório]
./scripts/link-rules.sh --help
```

### `setup-project.sh` - Setup Completo
- ✅ Configura projeto novo ou existente
- ✅ Suporte para modo `copy` ou `link`
- ✅ Cria estrutura de diretórios
- ✅ Instruções para git

**Uso:**
```bash
./scripts/setup-project.sh [diretório] [modo]
./scripts/setup-project.sh --help
```

## 📝 Gerenciando Rules

### Editando Rules
```bash
# Abre o editor no diretório de rules
cursor-edit

# Ou manualmente
code ~/cursor-config/rules/
```

### Adicionando Nova Rule
1. Crie um arquivo `.mdc` em `~/cursor-config/rules/`
2. Para projetos com **symlink**: mudanças são automáticas
3. Para projetos com **cópia**: execute `cursor-sync` para atualizar

### Atualizando Projetos
```bash
# Para projetos com symlink: automático ✨
# Para projetos com cópia:
cursor-sync ~/projects/projeto1
cursor-sync ~/projects/projeto2
```

## 🎯 Fluxos de Trabalho

### 💼 Para Desenvolvimento Pessoal
1. Use **symlinks** em todos os projetos
2. Edite rules centralmente
3. Mudanças aplicadas automaticamente

```bash
# Configuração inicial
for project in ~/projects/*/; do
    cursor-link "$project"
done
```

### 👥 Para Equipes
1. Use **cópia** para versionar rules com o código
2. Centralize mudanças neste repositório
3. Sincronize quando necessário

```bash
# Atualização em lote
for project in ~/projects/*/; do
    cursor-sync "$project"
    cd "$project"
    git add .cursor/rules/
    git commit -m "chore: update cursor rules"
    cd -
done
```

### 🔀 Misto (Recomendado)
- **Symlinks** para projetos pessoais
- **Cópia** para projetos de equipe
- **Setup automático** para novos projetos

## 📋 Rules Incluídas

### `commit-flow.mdc`
- ⚡ Automação de commits convencionais
- 📊 Análise individual de arquivos
- 🏷️ Classificação automática de mudanças
- 📝 Mensagens de commit padronizadas

### `pr-analysis.mdc`
- 🔍 Análise detalhada de Pull Requests
- 📊 Extração de metadados via API
- 🎯 Insights e recomendações
- 📋 Relatórios em português

### `pr-creation.mdc`
- 🚀 Criação automática de PRs
- 📝 Descrições detalhadas e estruturadas
- 🎯 Detecção automática de branch de destino
- ✅ Checklists e templates

## 🔧 Personalização

### Adicionando Rules Específicas por Projeto
Mesmo usando rules centralizadas, você pode ter rules específicas:

```bash
# Estrutura do projeto
meu-projeto/
├── .cursor/
│   ├── rules/          # ← Symlink ou cópia das rules centrais
│   └── local-rules/    # ← Rules específicas do projeto
│       └── project-specific.mdc
```

### Criando Templates
Adicione templates em `~/cursor-config/templates/` para diferentes tipos de projeto.

## 📚 Exemplos de Uso

### Novo Projeto React
```bash
mkdir ~/projects/react-app
cursor-setup ~/projects/react-app link
cd ~/projects/react-app
# Suas cursor rules já estão configuradas!
```

### Projeto Existente
```bash
cd ~/projects/existing-project
cursor-sync  # ou cursor-link para symlink
```

### Múltiplos Projetos
```bash
# Bash
for dir in ~/projects/*/; do cursor-sync "$dir"; done

# Fish shell
for dir in ~/projects/*/; cursor-sync $dir; end
```

## 🚨 Troubleshooting

### Rules não aparecem no Cursor
1. Verifique se os arquivos estão em `.cursor/rules/`
2. Reinicie o Cursor
3. Verifique se os arquivos têm extensão `.mdc`

### Symlink quebrado
```bash
# Remove e recria
rm -rf .cursor/rules
cursor-link
```

### Script não encontrado
```bash
# Verifique se os scripts são executáveis
chmod +x ~/cursor-config/scripts/*.sh
```

### Permission denied
```bash
# Torne os scripts executáveis
cd ~/cursor-config
chmod +x scripts/*.sh
```

## 🔄 Atualizações

### Atualizando Rules Central
```bash
cd ~/cursor-config
git pull origin main
# Projetos com symlink: atualizados automaticamente
# Projetos com cópia: execute cursor-sync
```

### Sincronizando Todos os Projetos
```bash
# Para projetos com cópia
find ~/projects -name ".cursor" -type d | while read dir; do
    project_dir=$(dirname "$dir")
    echo "Atualizando: $project_dir"
    cursor-sync "$project_dir"
done
```

## 🎉 Pronto!

Agora você tem um sistema centralizado de cursor rules que:

- ✅ **Elimina duplicação** de configurações
- ✅ **Facilita atualizações** em múltiplos projetos
- ✅ **Suporta diferentes workflows** (symlink vs copy)
- ✅ **Inclui automação completa** via scripts
- ✅ **Mantém flexibilidade** para customizações

---

**💡 Dica:** Use `cursor-setup . link` em projetos pessoais e `cursor-setup . copy` em projetos de equipe!