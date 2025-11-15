# Implementation Tasks

## Phase 1: Project Setup and Helper Libraries

### 1.1 Create Directory Structure
- [ ] 1.1.1 Create `helper/` directory
- [ ] 1.1.2 Create `scripts/core/` directory
- [ ] 1.1.3 Create `scripts/extras/` directory
- [ ] 1.1.4 Create `scripts/setup/` directory
- [ ] 1.1.5 Verify directory structure matches design

### 1.2 Extract and Create Helper: colors.sh
- [ ] 1.2.1 Extract color variable definitions (lines 81-86)
- [ ] 1.2.2 Add header documentation
- [ ] 1.2.3 Add `set -Eeuo pipefail`
- [ ] 1.2.4 Test sourcing from a script
- [ ] 1.2.5 Document exported variables

### 1.3 Extract and Create Helper: logger.sh
- [ ] 1.3.1 Extract logging functions (lines 140-179)
  - `log()`, `info()`, `print_info()`, `warn()`, `step()`, `debug()`
  - `now_ms()`, `fmt_ms()`
- [ ] 1.3.2 Source `colors.sh` dependency
- [ ] 1.3.3 Add header documentation
- [ ] 1.3.4 Test all logging levels
- [ ] 1.3.5 Verify VERBOSE flag behavior

### 1.4 Extract and Create Helper: utils.sh
- [ ] 1.4.1 Extract utility functions (lines 252-333)
  - `run()`, `require_cmd()`, `normalize_repo_url()`
  - `ssh_to_https()`, `check_ssh_auth()`
  - `get_nvm_dir()`, `preflight_utils()`, `ensure_node_available()`
- [ ] 1.4.2 Source `colors.sh` and `logger.sh` dependencies
- [ ] 1.4.3 Add header documentation for each function
- [ ] 1.4.4 Test all utility functions
- [ ] 1.4.5 Verify dry-run mode works correctly

### 1.5 Extract and Create Helper: checks.sh
- [ ] 1.5.1 Extract check functions (lines 222-246)
  - `initial_checks()`, `is_installed()`
- [ ] 1.5.2 Source required dependencies
- [ ] 1.5.3 Add header documentation
- [ ] 1.5.4 Test all validation checks
- [ ] 1.5.5 Verify error messages are clear

### 1.6 Extract and Create Helper: prompts.sh
- [ ] 1.6.1 Extract prompt functions (lines 432-721)
  - `usage()`, `parse_args()`, `welcome()`
- [ ] 1.6.2 Source all required dependencies
- [ ] 1.6.3 Add header documentation
- [ ] 1.6.4 Test argument parsing logic
- [ ] 1.6.5 Test welcome screen with different flag combinations
- [ ] 1.6.6 Verify configuration file loading in welcome()

### 1.7 Create Helper: set_variable.sh
- [ ] 1.7.1 Extract variable definitions (lines 88-128)
- [ ] 1.7.2 Export all necessary variables
- [ ] 1.7.3 Define default values for all configurations
- [ ] 1.7.4 Add dotmarchy version variable
- [ ] 1.7.5 Document all exported variables
- [ ] 1.7.6 Test variable availability in child scripts

## Phase 2: Core Operation Scripts

### 2.1 Create scripts/core/fupdate
- [ ] 2.1.1 Create script file with executable permissions
- [ ] 2.1.2 Add standard header with `set -Eeuo pipefail`
- [ ] 2.1.3 Source required helpers (colors, logger, utils)
- [ ] 2.1.4 Implement `usage()` function
- [ ] 2.1.5 Implement system update logic (`sudo pacman -Syu`)
- [ ] 2.1.6 Add error handling and logging
- [ ] 2.1.7 Test as standalone script
- [ ] 2.1.8 Test integration with main script

### 2.2 Create scripts/core/fchaotic
- [ ] 2.2.1 Create script file with executable permissions
- [ ] 2.2.2 Source required helpers
- [ ] 2.2.3 Extract `add_chaotic_repo()` function (lines 728-786)
- [ ] 2.2.4 Implement `usage()` function
- [ ] 2.2.5 Add GPG key management logic
- [ ] 2.2.6 Add pacman.conf modification logic
- [ ] 2.2.7 Test as standalone script
- [ ] 2.2.8 Test idempotency (run twice)

### 2.3 Create scripts/core/fdeps
- [ ] 2.3.1 Create script file with executable permissions
- [ ] 2.3.2 Source required helpers
- [ ] 2.3.3 Extract `install_dependencies()` function (lines 792-867)
- [ ] 2.3.4 Implement package detection logic
- [ ] 2.3.5 Implement batch installation
- [ ] 2.3.6 Add verification after installation
- [ ] 2.3.7 Test with already installed packages
- [ ] 2.3.8 Test with missing packages

### 2.4 Create scripts/core/fchaotic-deps
- [ ] 2.4.1 Create script file with executable permissions
- [ ] 2.4.2 Source required helpers
- [ ] 2.4.3 Extract `install_chaotic_dependencies()` (lines 873-945)
- [ ] 2.4.4 Implement paru installation logic
- [ ] 2.4.5 Handle extras flag logic
- [ ] 2.4.6 Test paru installation
- [ ] 2.4.7 Test extras installation
- [ ] 2.4.8 Verify all packages installed correctly

### 2.5 Create scripts/core/faur
- [ ] 2.5.1 Create script file with executable permissions
- [ ] 2.5.2 Source required helpers
- [ ] 2.5.3 Extract `install_aur_dependencies()` (lines 951-1022)
- [ ] 2.5.4 Implement dotbare installation logic
- [ ] 2.5.5 Handle extras AUR packages
- [ ] 2.5.6 Test individual package installation
- [ ] 2.5.7 Test error handling for failed builds
- [ ] 2.5.8 Verify all AUR packages work

### 2.6 Create scripts/core/fdotbare
- [ ] 2.6.1 Create script file with executable permissions
- [ ] 2.6.2 Source required helpers
- [ ] 2.6.3 Extract `ensure_dotbare_available()` (lines 2278-2311)
- [ ] 2.6.4 Extract `configure_dotbare()` (lines 2314-2418)
- [ ] 2.6.5 Implement SSH/HTTPS fallback logic
- [ ] 2.6.6 Test with SSH URL
- [ ] 2.6.7 Test with HTTPS URL
- [ ] 2.6.8 Test with existing dotbare setup

## Phase 3: Extras and Setup Scripts

### 3.1 Create scripts/extras/fnpm
- [ ] 3.1.1 Create script file with executable permissions
- [ ] 3.1.2 Source required helpers
- [ ] 3.1.3 Extract `install_npm_dependencies()` (lines 1028-1104)
- [ ] 3.1.4 Implement npm package detection
- [ ] 3.1.5 Test global npm installations
- [ ] 3.1.6 Test with config file loading
- [ ] 3.1.7 Verify all npm packages installed

### 3.2 Create scripts/extras/fcargo
- [ ] 3.2.1 Create script file with executable permissions
- [ ] 3.2.2 Source required helpers
- [ ] 3.2.3 Extract `install_cargo_packages()` (lines 1110-1190)
- [ ] 3.2.4 Implement cargo installation logic
- [ ] 3.2.5 Handle binary name mapping (bob-nvim → bob)
- [ ] 3.2.6 Test cargo package installations
- [ ] 3.2.7 Verify cargo binaries are accessible

### 3.3 Create scripts/extras/fpython
- [ ] 3.3.1 Create script file with executable permissions
- [ ] 3.3.2 Source required helpers
- [ ] 3.3.3 Extract `install_python_packages()` (lines 1196-1308)
- [ ] 3.3.4 Implement PEP 668 detection for Arch Linux
- [ ] 3.3.5 Implement pip vs pipx logic
- [ ] 3.3.6 Test on Arch Linux (pipx only)
- [ ] 3.3.7 Test pipx installations
- [ ] 3.3.8 Verify Python packages work

### 3.4 Create scripts/extras/fruby
- [ ] 3.4.1 Create script file with executable permissions
- [ ] 3.4.2 Source required helpers
- [ ] 3.4.3 Extract `install_ruby_packages()` (lines 1314-1358)
- [ ] 3.4.4 Implement gem installation logic
- [ ] 3.4.5 Test gem installations
- [ ] 3.4.6 Verify Ruby gems are accessible

### 3.5 Create scripts/extras/fgithub
- [ ] 3.5.1 Create script file with executable permissions
- [ ] 3.5.2 Source required helpers
- [ ] 3.5.3 Extract `install_github_tools()` (lines 1364-1527)
- [ ] 3.5.4 Implement GitHub API authentication
- [ ] 3.5.5 Implement individual tool installers (NVM, Lua-LS, lazygit, gh, zoxide, tldr, deno)
- [ ] 3.5.6 Test architecture detection
- [ ] 3.5.7 Test all GitHub tool installations
- [ ] 3.5.8 Verify downloaded tools work

### 3.6 Create scripts/extras/fpath
- [ ] 3.6.1 Create script file with executable permissions
- [ ] 3.6.2 Source required helpers
- [ ] 3.6.3 Extract `configure_path()` (lines 1533-1636)
- [ ] 3.6.4 Implement shell detection
- [ ] 3.6.5 Implement PATH configuration for bash/zsh/fish
- [ ] 3.6.6 Test on zsh
- [ ] 3.6.7 Test on bash
- [ ] 3.6.8 Verify PATH changes persist

### 3.7 Create scripts/setup/fenv-dirs
- [ ] 3.7.1 Create script file with executable permissions
- [ ] 3.7.2 Source required helpers
- [ ] 3.7.3 Extract `create_directories()` (lines 2152-2182)
- [ ] 3.7.4 Load DIRECTORIES array from setup.conf
- [ ] 3.7.5 Test directory creation
- [ ] 3.7.6 Test idempotency

### 3.8 Create scripts/setup/fenv-repos
- [ ] 3.8.1 Create script file with executable permissions
- [ ] 3.8.2 Source required helpers
- [ ] 3.8.3 Extract `clone_git_repo()` (lines 2089-2116)
- [ ] 3.8.4 Load GIT_REPOS array from setup.conf
- [ ] 3.8.5 Test git cloning
- [ ] 3.8.6 Test with existing repos

### 3.9 Create scripts/setup/fenv-scripts
- [ ] 3.9.1 Create script file with executable permissions
- [ ] 3.9.2 Source required helpers
- [ ] 3.9.3 Extract `download_script()` (lines 2118-2149)
- [ ] 3.9.4 Load SCRIPTS array from setup.conf
- [ ] 3.9.5 Test script download
- [ ] 3.9.6 Verify scripts are executable

### 3.10 Create scripts/setup/fenv-shell
- [ ] 3.10.1 Create script file with executable permissions
- [ ] 3.10.2 Source required helpers
- [ ] 3.10.3 Extract `add_to_shell_config()` (lines 2057-2087)
- [ ] 3.10.4 Load SHELL_LINES array from setup.conf
- [ ] 3.10.5 Test shell configuration
- [ ] 3.10.6 Test idempotency

### 3.11 Create scripts/fverify
- [ ] 3.11.1 Create script file with executable permissions
- [ ] 3.11.2 Source required helpers
- [ ] 3.11.3 Extract verification logic (lines 1758-2046)
- [ ] 3.11.4 Implement `check_tool()`, `check_path()` functions
- [ ] 3.11.5 Test as standalone script
- [ ] 3.11.6 Test with --verify flag
- [ ] 3.11.7 Verify output formatting

## Phase 4: Main Router Script

### 4.1 Create New dotmarchy Main Script
- [ ] 4.1.1 Backup original dotmarchy script
- [ ] 4.1.2 Create new router script structure
- [ ] 4.1.3 Source `helper/set_variable.sh` first
- [ ] 4.1.4 Implement command routing logic
- [ ] 4.1.5 Add script execution error handling
- [ ] 4.1.6 Implement --help and --version flags
- [ ] 4.1.7 Test help message
- [ ] 4.1.8 Test version display

### 4.2 Implement Core Execution Flow
- [ ] 4.2.1 Source `helper/prompts.sh` for argument parsing
- [ ] 4.2.2 Call `parse_args()` to process CLI flags
- [ ] 4.2.3 Call `initial_checks()` from `helper/checks.sh`
- [ ] 4.2.4 Execute `welcome()` function
- [ ] 4.2.5 Execute core scripts in order
- [ ] 4.2.6 Test basic installation flow
- [ ] 4.2.7 Verify error propagation

### 4.3 Implement Conditional Execution
- [ ] 4.3.1 Add --extras flag detection
- [ ] 4.3.2 Execute extras scripts when flag present
- [ ] 4.3.3 Add --setup-env flag detection
- [ ] 4.3.4 Execute setup scripts when flag present
- [ ] 4.3.5 Add --verify flag detection
- [ ] 4.3.6 Execute fverify when flag present
- [ ] 4.3.7 Test all flag combinations
- [ ] 4.3.8 Test with no flags (core only)

### 4.4 Implement Farewell and Summary
- [ ] 4.4.1 Extract `farewell()` function (lines 1642-1750)
- [ ] 4.4.2 Add to main script execution flow
- [ ] 4.4.3 Test summary output
- [ ] 4.4.4 Verify timing calculations

## Phase 5: Testing and Validation

### 5.1 Unit Testing
- [ ] 5.1.1 Test each helper library independently
- [ ] 5.1.2 Test each core script independently
- [ ] 5.1.3 Test each extras script independently
- [ ] 5.1.4 Test each setup script independently
- [ ] 5.1.5 Document any issues found

### 5.2 Integration Testing
- [ ] 5.2.1 Test full installation flow (no flags)
- [ ] 5.2.2 Test with --extras flag
- [ ] 5.2.3 Test with --setup-env flag
- [ ] 5.2.4 Test with --extras --setup-env
- [ ] 5.2.5 Test with --verify flag
- [ ] 5.2.6 Test with --repo custom_url
- [ ] 5.2.7 Test DRY_RUN=1 mode
- [ ] 5.2.8 Test VERBOSE=1 mode
- [ ] 5.2.9 Test error recovery
- [ ] 5.2.10 Test idempotency (run twice)

### 5.3 Compatibility Testing
- [ ] 5.3.1 Test on Arch Linux
- [ ] 5.3.2 Test with existing dotbare setup
- [ ] 5.3.3 Test with SSH repository URL
- [ ] 5.3.4 Test with HTTPS repository URL
- [ ] 5.3.5 Test with custom setup.conf
- [ ] 5.3.6 Test without setup.conf

### 5.4 Code Quality
- [ ] 5.4.1 Run shellcheck on all scripts
- [ ] 5.4.2 Fix all shellcheck warnings
- [ ] 5.4.3 Run shfmt on all scripts
- [ ] 5.4.4 Verify consistent formatting
- [ ] 5.4.5 Add TODO/FIXME comments if needed

### 5.5 Documentation
- [ ] 5.5.1 Add header comments to all scripts
- [ ] 5.5.2 Document all functions
- [ ] 5.5.3 Document all exported variables
- [ ] 5.5.4 Update README if needed
- [ ] 5.5.5 Create migration guide (if needed)

## Phase 6: Cleanup and Finalization

### 6.1 Remove Old Code
- [ ] 6.1.1 Archive original monolithic script
- [ ] 6.1.2 Remove temporary files
- [ ] 6.1.3 Clean up test artifacts

### 6.2 Final Verification
- [ ] 6.2.1 Run full installation on clean system
- [ ] 6.2.2 Verify all packages install correctly
- [ ] 6.2.3 Verify all flags work correctly
- [ ] 6.2.4 Compare output with original script
- [ ] 6.2.5 Document any differences

### 6.3 Performance Check
- [ ] 6.3.1 Measure execution time of new structure
- [ ] 6.3.2 Compare with original script timing
- [ ] 6.3.3 Identify any performance regressions
- [ ] 6.3.4 Optimize if needed

### 6.4 Commit and Deploy
- [ ] 6.4.1 Stage all new files
- [ ] 6.4.2 Create comprehensive commit message
- [ ] 6.4.3 Tag release with version number
- [ ] 6.4.4 Push to repository
- [ ] 6.4.5 Update documentation

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

