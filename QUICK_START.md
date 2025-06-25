# 🚀 Quick Start - Centralized Cursor Rules

## ✅ System Installed and Configured!

Your centralized cursor rules system is ready to use. Here are the main commands:

## 🎯 Main Commands

### For New Projects
```bash
# New project with symlink (recommended for personal development)
cursor-setup ~/projects/new-project link

# New project with copy (recommended for teams)
cursor-setup ~/projects/new-project copy
```

### For Existing Projects
```bash
# In project directory
cd ~/projects/my-project

# With symlink (automatic updates)
cursor-link

# With copy (manual control)
cursor-sync
```

### Management
```bash
# Edit central rules
cursor-edit

# Update rules and apply to current project
cursor-update            # update and sync
cursor-update link       # update and link

# Synchronize projects with copy
cursor-sync ~/projects/project1
cursor-sync ~/projects/project2

# Reconfigure project
cursor-setup . link  # change to symlink
cursor-setup . copy  # change to copy
```

## 🔧 Current Status

- ✅ **Central repository:** `~/cursor-config/`
- ✅ **Scripts installed:** sync, link, setup
- ✅ **Aliases configured:** cursor-update, cursor-sync, cursor-link, cursor-setup, cursor-edit
- ✅ **Current project configured:** active symlink in microdetect-api

## 📋 Available Rules

1. **`commit-flow.mdc`** - Conventional commits automation
2. **`pr-analysis.mdc`** - Detailed PR analysis
3. **`pr-creation.mdc`** - Automatic PR creation

## 🎭 Different Modes

### 🔗 Symlink
- ✅ Automatic updates
- ✅ Ideal for personal development
- ⚠️ Add `.cursor/rules` to `.gitignore`

### 📋 Copy
- ✅ Versioning with code
- ✅ Ideal for teams
- ✅ Manual update control

## 🚀 Next Steps

1. **Test the rules** - Make a commit or analyze a PR
2. **Configure other projects:**
   ```bash
   cursor-setup ~/projects/another-project link
   ```
3. **Customize rules:**
   ```bash
   cursor-edit
   ```

## 🆘 Quick Help

```bash
# Script help
~/cursor-config/scripts/cursor-update-rules.sh --help
~/cursor-config/scripts/sync-rules.sh --help
~/cursor-config/scripts/link-rules.sh --help
~/cursor-config/scripts/setup-project.sh --help

# Check if aliases work
cursor-update --help
cursor-sync --help
cursor-link --help
cursor-setup --help
```

---

**🎉 Ready to use!** Your cursor rules are now centralized and synchronized!