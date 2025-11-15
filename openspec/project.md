# Project Context

## Purpose
dotmarchy is an automated installation and configuration script for setting up a complete development environment on Arch Linux (including Omarchy Linux). The project manages dotfiles through dotbare (a git-based dotfiles manager) and automates the installation of development tools, programming languages, and utilities from multiple package sources.

Key goals:
- Automate the entire setup process for a development environment
- Support multiple package sources (pacman, Chaotic-AUR, AUR, npm, cargo, pip/pipx, gem)
- Make the installation idempotent (safe to run multiple times)
- Allow customization through configuration files
- Maintain a reproducible development environment

## Tech Stack
- **Bash** - Main scripting language (Bourne-Again Shell)
- **Git** - Version control and dotfiles management
- **dotbare** - Git-based dotfiles manager (based on kazhala/dotbare)
- **Package Managers**:
  - pacman (Arch Linux official repositories)
  - paru (AUR helper)
  - npm (Node.js packages)
  - cargo (Rust packages)
  - pipx/pip (Python packages)
  - gem (Ruby packages)
- **Shell Tools**: fzf, ripgrep, fd, bat, lsd/eza
- **OpenSpec** - Specification-driven development framework

## Project Conventions

### Code Style
- Follow POSIX-compliant Bash practices where possible
- Use `shellcheck` for linting (directive: `# shellcheck shell=bash`)
- Use `shfmt` for formatting (directive: `# shfmt: -ln=bash`)
- Strict mode: `set -Eeuo pipefail` (fail on errors, undefined variables, and pipe failures)
- Color variables: `CRE` (red), `CYE` (yellow), `CGR` (green), `CBL` (blue), `BLD` (bold), `CNC` (reset)
- Function naming: snake_case (e.g., `log_error`, `run_command`)
- Variable naming: UPPER_CASE for global configs, snake_case for local variables
- Comments: Include section headers with ASCII art and detailed index at the top
- Line length: Aim for ~100 characters, break longer lines logically

### Architecture Patterns
- **Modular sections**: Script organized into numbered sections (1-11)
  1. Appearance and options (colors, flags, paths)
  2. Logging and utilities
  3. Visual header (ASCII logo)
  4. Error handling (trap handlers)
  5. Internal utilities (run, require_cmd, normalize_repo_url, is_installed)
  6. CLI argument parsing
  7. User interaction
  8. Dependency installation (multiple package sources)
  9. Environment setup
  10. dotbare configuration
  11. Main execution flow
- **Separation of concerns**: Core packages vs extras, system vs environment setup
- **Idempotent operations**: Check before install, backup before overwrite
- **Configuration-driven**: Use external config file `~/.config/dotmarchy/setup.conf`
- **Fail-safe**: Error traps, logging, dry-run mode, verbose mode

### Testing Strategy
- Manual testing on clean Arch Linux installations
- Dry-run mode: `DRY_RUN=1 dotmarchy` to simulate without installing
- Verbose mode: `VERBOSE=1 dotmarchy` for debugging
- Verification mode: Check installation success post-install
- Test on both SSH and HTTPS repository URLs
- Validate with shellcheck before commits

### Git Workflow
- Main branch: `master`
- Commit messages: Spanish language (author preference), descriptive
- Date format in headers: DD-MMM-YYYY (e.g., 12-nov-2025)
- Keep dotmarchy script licensed under GPL-3.0
- Use OpenSpec for feature proposals and changes

## Domain Context

### Dotfiles Management
- **dotbare**: A wrapper around git for managing dotfiles in a bare repository
- **Bare repository**: Git repo without a working tree, stored in `$DOTBARE_DIR` (default: `~/.cfg`)
- **Working tree**: The actual $HOME directory (`$DOTBARE_TREE`)
- Advantages: No symlinks, version control entire home directory selectively

### Arch Linux Package Ecosystem
- **Official repos**: Installed via `pacman -S`
- **Chaotic-AUR**: Pre-compiled AUR packages (faster than building)
- **AUR** (Arch User Repository): Community packages built from source via `paru`
- **PEP 668**: Python packaging restriction on Arch - use system packages (python-*) or pipx for apps

### Installation Modes
- **Core mode** (default): Essential packages only
- **Extras mode** (`--extras`): Includes additional tools from config file
- **Environment setup** (`--setup-env`): Creates directories, clones repos, downloads scripts
- **Combined** (`--extras --setup-env`): Full setup

### Key Paths
- Config file: `~/.config/dotmarchy/setup.conf`
- Example config: `setup.conf.example` (in repo root)
- Dotbare directory: `~/.cfg` (bare git repo)
- Working tree: `$HOME`

## Important Constraints
- **Platform**: Arch Linux only (uses pacman, paru, Arch-specific packages)
- **Shell**: Requires Bash 4.0+ (uses Bash-isms)
- **Root access**: Requires sudo for system package installation
- **Internet**: Needs network access for all package downloads
- **PEP 668 compliance**: Must use system Python packages or pipx on Arch
- **Idempotency**: Must be safe to run multiple times without breaking the system
- **Backward compatibility**: Changes to dotmarchy script should not break existing users

## External Dependencies

### Required System Tools
- `bash` - Main shell
- `git` - Version control and dotbare backend
- `curl`/`wget` - Downloading files and scripts
- `pacman` - Arch package manager
- `sudo` - Root privilege escalation
- `tput` - Terminal control (for colors)

### Optional but Expected
- `paru` - AUR helper (installed by dotmarchy if missing)
- `fzf` - Fuzzy finder (used by dotbare)
- `dotbare` - Dotfiles manager (cloned during setup)

### External Services
- **GitHub**: Hosting dotfiles repositories, dotbare repository
- **Arch Linux repositories**: Official package mirrors
- **Chaotic-AUR**: Pre-compiled AUR mirror (chaotic.cx)
- **AUR**: Arch User Repository (aur.archlinux.org)
- **npm registry**: Node.js packages (registry.npmjs.org)
- **crates.io**: Rust packages
- **PyPI**: Python packages
- **RubyGems**: Ruby packages

### Reference Projects
- **kazhala/dotbare**: Original dotbare implementation (used as reference)
- **kazhala/scripts**: Personal scripts repository (optional clone target)
