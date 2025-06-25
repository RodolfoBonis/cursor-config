# 🔄 Centralized Cursor Rules

Central repository to share **Cursor Rules** between multiple projects, eliminating the need to duplicate configurations.

## 📋 Structure

```
cursor-config/
├── rules/                     # 📁 Centralized cursor rules
│   ├── commit-flow.mdc        # ⚡ Conventional commits automation
│   ├── pr-analysis.mdc        # 🔍 Detailed PR analysis
│   └── pr-creation.mdc        # 🚀 Automatic PR creation
├── scripts/                   # 🛠️ Automation scripts
│   ├── cursor-update-rules.sh # 🔄 Update repo and apply rules automatically
│   ├── sync-rules.sh          # 📋 Synchronize rules (copy files)
│   ├── link-rules.sh          # 🔗 Create symlinks (automatic updates)
│   └── setup-project.sh       # 🚀 Complete project setup
└── templates/                 # 📝 Templates for new projects
```

## 🚀 Quick Installation

### 1. Clone this repository
```bash
cd ~
git clone <your-repository> cursor-config
# or if you don't have a remote repo yet:
# Repository already created at ~/cursor-config
```

### 2. Configure useful aliases
Add to your `~/.zshrc` or `~/.bashrc`:

```bash
# Cursor Rules - Aliases
alias cursor-sync="~/cursor-config/scripts/sync-rules.sh"
alias cursor-link="~/cursor-config/scripts/link-rules.sh"
alias cursor-setup="~/cursor-config/scripts/setup-project.sh"
alias cursor-update="~/cursor-config/scripts/cursor-update-rules.sh"
alias cursor-edit="cursor ~/cursor-config/rules"
```

Reload terminal:
```bash
source ~/.zshrc  # or source ~/.bashrc
```

## 📖 How to Use

### 🔄 Option 1: Synchronization (Copy)
Ideal for team projects where you want to version rules with code:

```bash
# In your project directory
cursor-sync

# Or specifying a directory
cursor-sync ~/projects/my-project
```

### 🔗 Option 2: Symlink (Recommended)
Ideal for personal development - rules are always automatically updated:

```bash
# In your project directory
cursor-link

# Or specifying a directory
cursor-link ~/projects/my-project
```

### 🚀 Option 3: Complete Setup
Configure a new or existing project:

```bash
# Current project with copy
cursor-setup

# Specific project with symlink
cursor-setup ~/projects/new-project link

# Current project with symlink
cursor-setup . link
```

## 🛠️ Available Scripts

### `cursor-update-rules.sh` - Complete Update
- ✅ Update cursor-config repository (git pull)
- ✅ Apply rules to project (sync or link)
- ✅ Automated 2-step process
- ✅ Support for multiple modes

**Usage:**
```bash
./scripts/cursor-update-rules.sh [sync|link] [directory]
./scripts/cursor-update-rules.sh --help

# Examples
cursor-update                    # Update and apply sync to current
cursor-update link               # Update and apply link to current  
cursor-update sync ~/project     # Update and apply sync to project
```

### `sync-rules.sh` - Synchronization
- ✅ Copy rules to `.cursor/rules/`
- ✅ Check git changes
- ✅ Support for multiple `.mdc` files
- ✅ Error validation

**Usage:**
```bash
./scripts/sync-rules.sh [directory]
./scripts/sync-rules.sh --help
```

### `link-rules.sh` - Symlinks
- ✅ Create symlink for automatic updates
- ✅ Remove conflicting links/directories
- ✅ Guidance on `.gitignore`
- ✅ Symlink validation

**Usage:**
```bash
./scripts/link-rules.sh [directory]
./scripts/link-rules.sh --help
```

### `setup-project.sh` - Complete Setup
- ✅ Configure new or existing project
- ✅ Support for `copy` or `link` mode
- ✅ Create directory structure
- ✅ Git instructions

**Usage:**
```bash
./scripts/setup-project.sh [directory] [mode]
./scripts/setup-project.sh --help
```

## 📝 Managing Rules

### Editing Rules
```bash
# Open editor in rules directory
cursor-edit

# Or manually
code ~/cursor-config/rules/
```

### Adding New Rule
1. Create a `.mdc` file in `~/cursor-config/rules/`
2. For projects with **symlink**: changes are automatic
3. For projects with **copy**: run `cursor-sync` to update

### Updating Projects
```bash
# For projects with symlink: automatic ✨
# For projects with copy:
cursor-sync ~/projects/project1
cursor-sync ~/projects/project2
```

## 🎯 Workflows

### 💼 For Personal Development
1. Use **symlinks** in all projects
2. Edit rules centrally
3. Changes applied automatically

```bash
# Initial setup
for project in ~/projects/*/; do
    cursor-link "$project"
done
```

### 👥 For Teams
1. Use **copy** to version rules with code
2. Centralize changes in this repository
3. Synchronize when needed

```bash
# Batch update
for project in ~/projects/*/; do
    cursor-sync "$project"
    cd "$project"
    git add .cursor/rules/
    git commit -m "chore: update cursor rules"
    cd -
done
```

### 🔀 Mixed (Recommended)
- **Symlinks** for personal projects
- **Copy** for team projects
- **Automatic setup** for new projects

## 📋 Included Rules

### 1. 🔄 `commit-flow.mdc` - Conventional Commits
**What it does:** Automates conventional commit creation with semantic types, scopes, and descriptions.

**Features:**
- ✅ Interactive conventional commit creation
- ✅ Automatic scope detection based on modified files
- ✅ Semantic commit types (feat, fix, docs, etc.)
- ✅ Breaking change detection
- ✅ Commit message validation
- ✅ Git hooks integration suggestions

**Usage:** When making commits, the AI will guide you through creating conventional commits following best practices.

### 2. 🔍 `pr-analysis.mdc` - Detailed PR Analysis
**What it does:** Performs comprehensive analysis of Pull Requests for code quality, security, and best practices.

**Features:**
- ✅ Code quality assessment
- ✅ Security vulnerability scanning
- ✅ Performance impact analysis
- ✅ Test coverage evaluation
- ✅ Documentation completeness check
- ✅ Breaking changes detection
- ✅ Dependency analysis
- ✅ Architecture consistency validation

**Usage:** When reviewing PRs, the AI will provide detailed analysis and recommendations for improvement.

### 3. 🚀 `pr-creation.mdc` - Automatic PR Creation
**What it does:** Automates Pull Request creation with templates, descriptions, and proper categorization.

**Features:**
- ✅ Automatic PR template selection
- ✅ Intelligent title and description generation
- ✅ Label and reviewer suggestions
- ✅ Change impact assessment
- ✅ Related issue linking
- ✅ Release notes generation
- ✅ Merge strategy recommendations

**Usage:** When creating PRs, the AI will help structure and describe your changes professionally.

## 🔧 Advanced Configuration

### Creating Custom Rules
1. Create a new `.mdc` file in `~/cursor-config/rules/`
2. Follow the Cursor rules format:
```markdown
# Rule Name
Description of what this rule does.

## Instructions
- Specific instructions for the AI
- Use clear, actionable language
- Include examples when helpful

## Context
Additional context or constraints for the rule.
```

### Project-Specific Overrides
For project-specific customizations:
1. Copy the central rule to your project
2. Modify as needed
3. The local rule will take precedence

### Team Sharing
1. Push this repository to your team's git hosting
2. Team members clone and configure aliases
3. Use **sync mode** for shared rules
4. Use **link mode** for personal customizations

## 🚨 Troubleshooting

### Rules Not Working
```bash
# Check if rules directory exists
ls -la .cursor/rules/

# Verify symlink is working
ls -la .cursor/rules
file .cursor/rules

# Re-sync/re-link
cursor-sync  # or cursor-link
```

### Scripts Not Found
```bash
# Check aliases
alias | grep cursor

# Reload shell configuration
source ~/.zshrc  # or ~/.bashrc

# Manual script execution
~/cursor-config/scripts/sync-rules.sh --help
```

### Git Issues
```bash
# Check repository status
cd ~/cursor-config
git status

# Update manually
git pull

# Fix conflicts if needed
git merge
```

## 🤝 Contributing

1. Fork this repository
2. Create your feature branch
3. Add or modify rules in `rules/`
4. Test with different projects
5. Submit a Pull Request

### Rule Guidelines
- Keep rules focused and specific
- Use clear, actionable language
- Include examples when helpful
- Test with real projects
- Document expected behavior

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Cursor AI for the amazing AI-powered editor
- The open-source community for inspiration
- All contributors who help improve these rules

---

**Made with ❤️ for developers who love automation and consistency.**