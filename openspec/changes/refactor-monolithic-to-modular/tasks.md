# Implementation Tasks

## Phase 1: Project Setup and Helper Libraries

### 1.1 Create Directory Structure
- [x] 1.1.1 Create `helper/` directory
- [x] 1.1.2 Create `scripts/core/` directory
- [x] 1.1.3 Create `scripts/extras/` directory
- [x] 1.1.4 Create `scripts/setup/` directory
- [x] 1.1.5 Verify directory structure matches design

### 1.2 Extract and Create Helper: colors.sh
- [x] 1.2.1 Extract color variable definitions (lines 81-86)
- [x] 1.2.2 Add header documentation
- [x] 1.2.3 Add `set -Eeuo pipefail`
- [x] 1.2.4 Test sourcing from a script
- [x] 1.2.5 Document exported variables

### 1.3 Extract and Create Helper: logger.sh
- [x] 1.3.1 Extract logging functions (lines 140-179)
  - `log()`, `info()`, `print_info()`, `warn()`, `step()`, `debug()`
  - `now_ms()`, `fmt_ms()`
- [x] 1.3.2 Source `colors.sh` dependency
- [x] 1.3.3 Add header documentation
- [x] 1.3.4 Test all logging levels
- [x] 1.3.5 Verify VERBOSE flag behavior

### 1.4 Extract and Create Helper: utils.sh
- [x] 1.4.1 Extract utility functions (lines 252-333)
  - `run()`, `require_cmd()`, `normalize_repo_url()`
  - `ssh_to_https()`, `check_ssh_auth()`
  - `get_nvm_dir()`, `preflight_utils()`, `ensure_node_available()`
- [x] 1.4.2 Source `colors.sh` and `logger.sh` dependencies
- [x] 1.4.3 Add header documentation for each function
- [x] 1.4.4 Test all utility functions
- [x] 1.4.5 Verify dry-run mode works correctly

### 1.5 Extract and Create Helper: checks.sh
- [x] 1.5.1 Extract check functions (lines 222-246)
  - `initial_checks()`, `is_installed()`
- [x] 1.5.2 Source required dependencies
- [x] 1.5.3 Add header documentation
- [x] 1.5.4 Test all validation checks
- [x] 1.5.5 Verify error messages are clear

### 1.6 Extract and Create Helper: prompts.sh
- [x] 1.6.1 Extract prompt functions (lines 432-721)
  - `usage()`, `parse_args()`, `welcome()`
- [x] 1.6.2 Source all required dependencies
- [x] 1.6.3 Add header documentation
- [x] 1.6.4 Test argument parsing logic
- [x] 1.6.5 Test welcome screen with different flag combinations
- [x] 1.6.6 Verify configuration file loading in welcome()

### 1.7 Create Helper: set_variable.sh
- [x] 1.7.1 Extract variable definitions (lines 88-128)
- [x] 1.7.2 Export all necessary variables
- [x] 1.7.3 Define default values for all configurations
- [x] 1.7.4 Add dotmarchy version variable
- [x] 1.7.5 Document all exported variables
- [x] 1.7.6 Test variable availability in child scripts

## Phase 2: Core Operation Scripts

### 2.1 Create scripts/core/fupdate
- [x] 2.1.1 Create script file with executable permissions
- [x] 2.1.2 Add standard header with `set -Eeuo pipefail`
- [x] 2.1.3 Source required helpers (colors, logger, utils)
- [x] 2.1.4 Implement `usage()` function
- [x] 2.1.5 Implement system update logic (`sudo pacman -Syu`)
- [x] 2.1.6 Add error handling and logging
- [x] 2.1.7 Test as standalone script
- [x] 2.1.8 Test integration with main script

### 2.2 Create scripts/core/fchaotic
- [x] 2.2.1 Create script file with executable permissions
- [x] 2.2.2 Source required helpers
- [x] 2.2.3 Extract `add_chaotic_repo()` function (lines 728-786)
- [x] 2.2.4 Implement `usage()` function
- [x] 2.2.5 Add GPG key management logic
- [x] 2.2.6 Add pacman.conf modification logic
- [x] 2.2.7 Test as standalone script
- [x] 2.2.8 Test idempotency (run twice)

### 2.3 Create scripts/core/fdeps
- [x] 2.3.1 Create script file with executable permissions
- [x] 2.3.2 Source required helpers
- [x] 2.3.3 Extract `install_dependencies()` function (lines 792-867)
- [x] 2.3.4 Implement package detection logic
- [x] 2.3.5 Implement batch installation
- [x] 2.3.6 Add verification after installation
- [x] 2.3.7 Test with already installed packages
- [x] 2.3.8 Test with missing packages

### 2.4 Create scripts/core/fchaotic-deps
- [x] 2.4.1 Create script file with executable permissions
- [x] 2.4.2 Source required helpers
- [x] 2.4.3 Extract `install_chaotic_dependencies()` (lines 873-945)
- [x] 2.4.4 Implement paru installation logic
- [x] 2.4.5 Handle extras flag logic
- [x] 2.4.6 Test paru installation
- [x] 2.4.7 Test extras installation
- [x] 2.4.8 Verify all packages installed correctly

### 2.5 Create scripts/core/faur
- [x] 2.5.1 Create script file with executable permissions
- [x] 2.5.2 Source required helpers
- [x] 2.5.3 Extract `install_aur_dependencies()` (lines 951-1022)
- [x] 2.5.4 Implement dotbare installation logic
- [x] 2.5.5 Handle extras AUR packages
- [x] 2.5.6 Test individual package installation
- [x] 2.5.7 Test error handling for failed builds
- [x] 2.5.8 Verify all AUR packages work

### 2.6 Create scripts/core/fdotbare
- [x] 2.6.1 Create script file with executable permissions
- [x] 2.6.2 Source required helpers
- [x] 2.6.3 Extract `ensure_dotbare_available()` (lines 2278-2311)
- [x] 2.6.4 Extract `configure_dotbare()` (lines 2314-2418)
- [x] 2.6.5 Implement SSH/HTTPS fallback logic
- [x] 2.6.6 Test with SSH URL
- [x] 2.6.7 Test with HTTPS URL
- [x] 2.6.8 Test with existing dotbare setup

## Phase 3: Extras and Setup Scripts

### 3.1 Create scripts/extras/fnpm
- [x] 3.1.1 Create script file with executable permissions
- [x] 3.1.2 Source required helpers
- [x] 3.1.3 Extract `install_npm_dependencies()` (lines 1028-1104)
- [x] 3.1.4 Implement npm package detection
- [x] 3.1.5 Test global npm installations
- [x] 3.1.6 Test with config file loading
- [x] 3.1.7 Verify all npm packages installed

### 3.2 Create scripts/extras/fcargo
- [x] 3.2.1 Create script file with executable permissions
- [x] 3.2.2 Source required helpers
- [x] 3.2.3 Extract `install_cargo_packages()` (lines 1110-1190)
- [x] 3.2.4 Implement cargo installation logic
- [x] 3.2.5 Handle binary name mapping (bob-nvim → bob)
- [x] 3.2.6 Test cargo package installations
- [x] 3.2.7 Verify cargo binaries are accessible

### 3.3 Create scripts/extras/fpython
- [x] 3.3.1 Create script file with executable permissions
- [x] 3.3.2 Source required helpers
- [x] 3.3.3 Extract `install_python_packages()` (lines 1196-1308)
- [x] 3.3.4 Implement PEP 668 detection for Arch Linux
- [x] 3.3.5 Implement pip vs pipx logic
- [x] 3.3.6 Test on Arch Linux (pipx only)
- [x] 3.3.7 Test pipx installations
- [x] 3.3.8 Verify Python packages work

### 3.4 Create scripts/extras/fruby
- [x] 3.4.1 Create script file with executable permissions
- [x] 3.4.2 Source required helpers
- [x] 3.4.3 Extract `install_ruby_packages()` (lines 1314-1358)
- [x] 3.4.4 Implement gem installation logic
- [x] 3.4.5 Test gem installations
- [x] 3.4.6 Verify Ruby gems are accessible

### 3.5 Create scripts/extras/fgithub
- [x] 3.5.1 Create script file with executable permissions
- [x] 3.5.2 Source required helpers
- [x] 3.5.3 Extract `install_github_tools()` (lines 1364-1527)
- [x] 3.5.4 Implement GitHub API authentication
- [x] 3.5.5 Implement individual tool installers (NVM, Lua-LS, lazygit, gh, zoxide, tldr, deno)
- [x] 3.5.6 Test architecture detection
- [x] 3.5.7 Test all GitHub tool installations
- [x] 3.5.8 Verify downloaded tools work

### 3.6 Create scripts/extras/fpath
- [x] 3.6.1 Create script file with executable permissions
- [x] 3.6.2 Source required helpers
- [x] 3.6.3 Extract `configure_path()` (lines 1533-1636)
- [x] 3.6.4 Implement shell detection
- [x] 3.6.5 Implement PATH configuration for bash/zsh/fish
- [x] 3.6.6 Test on zsh
- [x] 3.6.7 Test on bash
- [x] 3.6.8 Verify PATH changes persist

### 3.7 Create scripts/setup/fenv-dirs
- [x] 3.7.1 Create script file with executable permissions
- [x] 3.7.2 Source required helpers
- [x] 3.7.3 Extract `create_directories()` (lines 2152-2182)
- [x] 3.7.4 Load DIRECTORIES array from setup.conf
- [x] 3.7.5 Test directory creation
- [x] 3.7.6 Test idempotency

### 3.8 Create scripts/setup/fenv-repos
- [x] 3.8.1 Create script file with executable permissions
- [x] 3.8.2 Source required helpers
- [x] 3.8.3 Extract `clone_git_repo()` (lines 2089-2116)
- [x] 3.8.4 Load GIT_REPOS array from setup.conf
- [x] 3.8.5 Test git cloning
- [x] 3.8.6 Test with existing repos

### 3.9 Create scripts/setup/fenv-scripts
- [x] 3.9.1 Create script file with executable permissions
- [x] 3.9.2 Source required helpers
- [x] 3.9.3 Extract `download_script()` (lines 2118-2149)
- [x] 3.9.4 Load SCRIPTS array from setup.conf
- [x] 3.9.5 Test script download
- [x] 3.9.6 Verify scripts are executable

### 3.10 Create scripts/setup/fenv-shell
- [x] 3.10.1 Create script file with executable permissions
- [x] 3.10.2 Source required helpers
- [x] 3.10.3 Extract `add_to_shell_config()` (lines 2057-2087)
- [x] 3.10.4 Load SHELL_LINES array from setup.conf
- [x] 3.10.5 Test shell configuration
- [x] 3.10.6 Test idempotency

### 3.11 Create scripts/fverify
- [x] 3.11.1 Create script file with executable permissions
- [x] 3.11.2 Source required helpers
- [x] 3.11.3 Extract verification logic (lines 1758-2046)
- [x] 3.11.4 Implement `check_tool()`, `check_path()` functions
- [x] 3.11.5 Test as standalone script
- [x] 3.11.6 Test with --verify flag
- [x] 3.11.7 Verify output formatting

## Phase 4: Main Router Script

### 4.1 Create New dotmarchy Main Script
- [x] 4.1.1 Backup original dotmarchy script
- [x] 4.1.2 Create new router script structure
- [x] 4.1.3 Source `helper/set_variable.sh` first
- [x] 4.1.4 Implement command routing logic
- [x] 4.1.5 Add script execution error handling
- [x] 4.1.6 Implement --help and --version flags
- [x] 4.1.7 Test help message
- [x] 4.1.8 Test version display

### 4.2 Implement Core Execution Flow
- [x] 4.2.1 Source `helper/prompts.sh` for argument parsing
- [x] 4.2.2 Call `parse_args()` to process CLI flags
- [x] 4.2.3 Call `initial_checks()` from `helper/checks.sh`
- [x] 4.2.4 Execute `welcome()` function
- [x] 4.2.5 Execute core scripts in order
- [x] 4.2.6 Test basic installation flow
- [x] 4.2.7 Verify error propagation

### 4.3 Implement Conditional Execution
- [x] 4.3.1 Add --extras flag detection
- [x] 4.3.2 Execute extras scripts when flag present
- [x] 4.3.3 Add --setup-env flag detection
- [x] 4.3.4 Execute setup scripts when flag present
- [x] 4.3.5 Add --verify flag detection
- [x] 4.3.6 Execute fverify when flag present
- [x] 4.3.7 Test all flag combinations
- [x] 4.3.8 Test with no flags (core only)

### 4.4 Implement Farewell and Summary
- [x] 4.4.1 Extract `farewell()` function (lines 1642-1750)
- [x] 4.4.2 Add to main script execution flow
- [x] 4.4.3 Test summary output
- [x] 4.4.4 Verify timing calculations

## Phase 5: Testing and Validation

### 5.1 Unit Testing
- [x] 5.1.1 Test each helper library independently
- [x] 5.1.2 Test each core script independently
- [x] 5.1.3 Test each extras script independently
- [x] 5.1.4 Test each setup script independently
- [x] 5.1.5 Document any issues found

### 5.2 Integration Testing
- [x] 5.2.1 Test full installation flow (no flags)
- [x] 5.2.2 Test with --extras flag
- [x] 5.2.3 Test with --setup-env flag
- [x] 5.2.4 Test with --extras --setup-env
- [x] 5.2.5 Test with --verify flag
- [x] 5.2.6 Test with --repo custom_url
- [x] 5.2.7 Test DRY_RUN=1 mode
- [x] 5.2.8 Test VERBOSE=1 mode
- [x] 5.2.9 Test error recovery
- [x] 5.2.10 Test idempotency (run twice)

### 5.3 Compatibility Testing
- [x] 5.3.1 Test on Arch Linux
- [x] 5.3.2 Test with existing dotbare setup
- [x] 5.3.3 Test with SSH repository URL
- [x] 5.3.4 Test with HTTPS repository URL
- [x] 5.3.5 Test with custom setup.conf
- [x] 5.3.6 Test without setup.conf

### 5.4 Code Quality
- [x] 5.4.1 Run shellcheck on all scripts
- [x] 5.4.2 Fix all shellcheck warnings
- [x] 5.4.3 Run shfmt on all scripts
- [x] 5.4.4 Verify consistent formatting
- [x] 5.4.5 Add TODO/FIXME comments if needed

### 5.5 Documentation
- [x] 5.5.1 Add header comments to all scripts
- [x] 5.5.2 Document all functions
- [x] 5.5.3 Document all exported variables
- [x] 5.5.4 Update README if needed
- [x] 5.5.5 Create migration guide (if needed)

## Phase 6: Cleanup and Finalization

### 6.1 Remove Old Code
- [x] 6.1.1 Archive original monolithic script
- [x] 6.1.2 Remove temporary files
- [x] 6.1.3 Clean up test artifacts

### 6.2 Final Verification
- [x] 6.2.1 Run full installation on clean system
- [x] 6.2.2 Verify all packages install correctly
- [x] 6.2.3 Verify all flags work correctly
- [x] 6.2.4 Compare output with original script
- [x] 6.2.5 Document any differences

### 6.3 Performance Check
- [x] 6.3.1 Measure execution time of new structure
- [x] 6.3.2 Compare with original script timing
- [x] 6.3.3 Identify any performance regressions
- [x] 6.3.4 Optimize if needed

### 6.4 Commit and Deploy
- [x] 6.4.1 Stage all new files
- [x] 6.4.2 Create comprehensive commit message
- [x] 6.4.3 Tag release with version number
- [x] 6.4.4 Push to repository
- [x] 6.4.5 Update documentation

## Success Criteria

- ✅ All 2465 lines of original functionality preserved
- ✅ CLI interface 100% backward compatible
- ✅ All flags work identically to original
- ✅ No breaking changes for users
- ✅ Code passes shellcheck with no errors
- ✅ All scripts are executable and properly sourced
- ✅ Error handling works consistently
- ✅ Logging outputs match original format
- ✅ Installation time within 10% of original
- ✅ All tests pass successfully


---

## Implementation Summary

**Status**: ✅ COMPLETED

### Statistics
- **Total tasks completed**: 235
- **Implementation time**: ~2 hours
- **Files created**: 24 scripts
- **Code reduction**: 92% (2464 lines → 188 lines in main script)

### Structure Created
```
dotmarchy/
├── dotmarchy (188 lines) - Main router script
├── helper/ (6 files) - Shared libraries
│   ├── set_variable.sh (3.9K)
│   ├── colors.sh (1.2K)
│   ├── logger.sh (4.6K)
│   ├── utils.sh (8.5K)
│   ├── checks.sh (2.2K)
│   └── prompts.sh (16K)
└── scripts/ (17 files) - Operation scripts
    ├── core/ (6 scripts) - Always executed
    ├── extras/ (6 scripts) - Optional packages
    ├── setup/ (4 scripts) - Environment setup
    └── fverify (1 script) - Verification
```

### Achievements
✅ Modular architecture following dotbare pattern
✅ All CLI functionality preserved
✅ Backward compatible
✅ Self-contained executable scripts
✅ Comprehensive documentation
✅ All tests passing
✅ Clean error handling
✅ Idempotent operations

### Migration
- Original script backed up as: `dotmarchy.monolithic.bak`
- No user action required - drop-in replacement
- All existing flags and arguments work identically

**Implementation completed on**: 2025-11-15
