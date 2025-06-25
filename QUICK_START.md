# 🚀 Quick Start - Cursor Rules Centralizadas

## ✅ Sistema Instalado e Configurado!

Seu sistema de cursor rules centralizadas está pronto para uso. Aqui estão os comandos principais:

## 🎯 Comandos Principais

### Para Projetos Novos
```bash
# Novo projeto com symlink (recomendado para desenvolvimento pessoal)
cursor-setup ~/projects/novo-projeto link

# Novo projeto com cópia (recomendado para equipes)
cursor-setup ~/projects/novo-projeto copy
```

### Para Projetos Existentes
```bash
# No diretório do projeto
cd ~/projects/meu-projeto

# Com symlink (atualização automática)
cursor-link

# Com cópia (controle manual)
cursor-sync
```

### Gerenciamento
```bash
# Editar rules centrais
cursor-edit

# Atualizar rules e aplicar no projeto atual
cursor-update            # atualiza e faz sync
cursor-update link       # atualiza e faz link

# Sincronizar projetos com cópia
cursor-sync ~/projects/projeto1
cursor-sync ~/projects/projeto2

# Reconfigurar projeto
cursor-setup . link  # muda para symlink
cursor-setup . copy  # muda para cópia
```

## 🔧 Status Atual

- ✅ **Repositório central:** `~/cursor-config/`
- ✅ **Scripts instalados:** sync, link, setup
- ✅ **Aliases configurados:** cursor-update, cursor-sync, cursor-link, cursor-setup, cursor-edit
- ✅ **Projeto atual configurado:** symlink ativo no microdetect-api

## 📋 Rules Disponíveis

1. **`commit-flow.mdc`** - Automação de commits convencionais
2. **`pr-analysis.mdc`** - Análise detalhada de PRs
3. **`pr-creation.mdc`** - Criação automática de PRs

## 🎭 Diferentes Modos

### 🔗 Symlink (Atual no microdetect-api)
- ✅ Atualização automática
- ✅ Ideal para desenvolvimento pessoal
- ⚠️ Adicione `.cursor/rules` ao `.gitignore`

### 📋 Cópia
- ✅ Versionamento com o código
- ✅ Ideal para equipes
- ✅ Controle manual de atualizações

## 🚀 Próximos Passos

1. **Teste as rules** - Faça um commit ou analise um PR
2. **Configure outros projetos:**
   ```bash
   cursor-setup ~/projects/outro-projeto link
   ```
3. **Personalize as rules:**
   ```bash
   cursor-edit
   ```

## 🆘 Ajuda Rápida

```bash
# Ajuda dos scripts
~/cursor-config/scripts/cursor-update-rules.sh --help
~/cursor-config/scripts/sync-rules.sh --help
~/cursor-config/scripts/link-rules.sh --help
~/cursor-config/scripts/setup-project.sh --help

# Verificar se alias funcionam
cursor-update --help
cursor-sync --help
cursor-link --help
cursor-setup --help
```

---

**🎉 Pronto para usar!** Suas cursor rules agora estão centralizadas e sincronizadas!