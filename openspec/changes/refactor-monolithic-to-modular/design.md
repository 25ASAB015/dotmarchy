# Design Document: Modular Architecture for dotmarchy

## Context

The current `dotmarchy` script is a single 2465-line bash file that handles:
- System updates and repository configuration
- Package installation from 7 different sources (pacman, Chaotic-AUR, AUR, npm, cargo, pip/pipx, gem, GitHub)
- Development environment setup
- Dotfiles management via dotbare
- Verification of installed tools

This monolithic structure has served its purpose but now hinders:
- **Maintainability**: Difficult to locate and modify specific functionality
- **Testing**: Cannot test individual components in isolation
- **Collaboration**: Multiple developers cannot work on different features simultaneously
- **Extensibility**: Adding new package managers requires modifying the entire script

## Goals

### Primary Goals
1. **Modularize without breaking**: Refactor into independent modules while maintaining 100% CLI compatibility
2. **Follow proven patterns**: Adopt the structure used by [dotbare](https://github.com/kazhala/dotbare), a mature and well-architected project
3. **Enable extensibility**: Make it easy to add new package managers or operations
4. **Improve testability**: Allow individual components to be tested independently
5. **Maintain performance**: No significant performance degradation

### Non-Goals
1. **Not changing CLI interface**: All existing flags and arguments work identically
2. **Not adding new features**: This is purely a refactoring effort
3. **Not changing configuration format**: `setup.conf` format remains unchanged
4. **Not rewriting in another language**: Staying with bash for compatibility

## Decisions

### Decision 1: Adopt dotbare's Architecture Pattern

**What**: Use the same modular structure as kazhala/dotbare

**Why**:
- Proven pattern with 700+ GitHub stars
- Clear separation of concerns
- Simple router + independent scripts model
- Easy to understand and contribute to
- Aligns with Unix philosophy (do one thing well)

**Structure**:
```
dotmarchy                    # Router script (~150 lines)
├── helper/                  # Shared libraries (sourceable)
│   ├── set_variable.sh      # Variables and exports
│   ├── colors.sh            # Color definitions
│   ├── logger.sh            # Logging functions
│   ├── utils.sh             # General utilities
│   ├── checks.sh            # System checks
│   └── prompts.sh           # User interaction
└── scripts/                 # Executable commands
    ├── core/                # Always executed
    ├── extras/              # --extras flag
    ├── setup/               # --setup-env flag
    └── fverify              # --verify flag
```

**Alternatives Considered**:
1. **Single file with functions**: Rejected - doesn't solve the problem
2. **Library approach (all sourceable)**: Rejected - less flexible than executable scripts
3. **Plugin system with hooks**: Rejected - too complex for current needs

### Decision 2: Helper Libraries vs Executable Scripts

**What**: Two types of modules:
1. **Helpers** (`helper/`): Sourceable libraries (functions, variables)
2. **Scripts** (`scripts/`): Executable commands (operations)

**Why**:
- **Helpers**: Reusable functions needed by multiple scripts
  - Example: `log()`, `info()`, `warn()` used everywhere
  - Sourced at script startup, no execution overhead
  
- **Scripts**: Self-contained operations
  - Example: `fcargo` installs Rust packages
  - Can be executed independently for testing
  - Can be called sequentially by router

**How to decide**:
- If it's a reusable function → Helper
- If it's a complete operation → Script
- If it defines variables/constants → Helper

**Examples**:
```bash
# Helper (colors.sh) - sourceable
CRE=$(tput setaf 1)
CGR=$(tput setaf 2)
# No main execution

# Script (fcargo) - executable
#!/usr/bin/env bash
source "${mydir}/../helper/colors.sh"
main() { ... }
main "$@"
```

### Decision 3: Sourcing Strategy and Path Resolution

**What**: Each script sources its dependencies using relative paths from `${BASH_SOURCE[0]}`

**Why**:
- Works regardless of where dotmarchy is installed
- No need for global PATH modifications
- Scripts can be executed directly for testing
- Follows dotbare's pattern

**Implementation**:
```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# Determine script's directory
mydir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source helpers with relative paths
source "${mydir}/../helper/colors.sh"
source "${mydir}/../helper/logger.sh"
source "${mydir}/../helper/utils.sh"
```

**Alternatives Considered**:
1. **Absolute paths**: Rejected - not portable
2. **PATH-based sourcing**: Rejected - requires setup
3. **Single global source**: Rejected - creates tight coupling

### Decision 4: Variable Communication Between Scripts

**What**: Three mechanisms for inter-script communication:
1. **Exported environment variables**: For configuration and flags
2. **Exit codes**: For success/failure status
3. **Shared state files**: For complex data (NOT USED - keep it simple)

**Environment Variables to Export** (in `set_variable.sh`):
```bash
# Core configuration
export DOTBARE_DIR="${DOTBARE_DIR:-$HOME/.cfg}"
export DOTBARE_TREE="${DOTBARE_TREE:-$HOME}"
export REPO_URL
export ERROR_LOG

# Flags
export INSTALL_EXTRAS
export SETUP_ENVIRONMENT
export DRY_RUN
export VERBOSE
export FORCE

# Statistics
export PACKAGES_INSTALLED
export PACKAGES_SKIPPED
export INSTALL_START_TIME
```

**Why**:
- Environment variables are bash's native IPC mechanism
- Exit codes provide clear success/failure indication
- No need for complex state management

**Alternatives Considered**:
1. **Passing as arguments**: Rejected - too many variables
2. **JSON state file**: Rejected - overkill for bash
3. **Global sourced file**: Rejected - creates order dependencies

### Decision 5: Error Handling Strategy

**What**: Standardized error handling across all modules

**Implementation**:
```bash
# In every script
set -Eeuo pipefail  # Fail fast

# Error trap
trap on_error ERR

on_error() {
    exit_code=$?
    line=${BASH_LINENO[0]:-UNKNOWN}
    log_error "Failed at line ${line}. Code: ${exit_code}"
    exit "$exit_code"
}

# Logging to ERROR_LOG
log_error "Error message" >> "$ERROR_LOG"
```

**Why**:
- `set -e`: Exit on any error
- `set -u`: Exit on undefined variable
- `set -o pipefail`: Exit on pipe failure
- `set -E`: ERR trap inherited by functions
- Consistent across all scripts

**Alternatives Considered**:
1. **Manual error checking**: Rejected - too error-prone
2. **No error traps**: Rejected - harder to debug
3. **Different levels per script**: Rejected - inconsistent behavior

### Decision 6: Script Naming Convention

**What**: Follow dotbare's naming convention with `f` prefix

**Pattern**:
- `f` + descriptive name
- Examples: `fcargo`, `fnpm`, `fdotbare`, `fverify`
- Exception: helpers have no prefix

**Why**:
- Consistent with dotbare (proven pattern)
- `f` indicates "dotmarchy function/feature"
- Easy to identify dotmarchy-specific scripts
- Avoids name collisions

**Mapping**:
| Old Function | New Script | Location |
|-------------|------------|----------|
| `add_chaotic_repo()` | `fchaotic` | `scripts/core/` |
| `install_dependencies()` | `fdeps` | `scripts/core/` |
| `install_npm_dependencies()` | `fnpm` | `scripts/extras/` |
| `install_cargo_packages()` | `fcargo` | `scripts/extras/` |
| `setup_development_environment()` | `fenv-*` | `scripts/setup/` |
| `verify_installation()` | `fverify` | `scripts/` |

### Decision 7: Configuration Loading Strategy

**What**: Configuration file (`~/.config/dotmarchy/setup.conf`) loaded in two places:
1. In `set_variable.sh` for default arrays
2. In individual scripts that need specific arrays

**Why**:
- Some scripts need config (extras, setup)
- Some scripts don't need config (core)
- Avoids loading config unnecessarily
- Keeps scripts independent

**Implementation**:
```bash
# In set_variable.sh - set defaults
declare -a EXTRA_DEPENDENCIES=()
declare -a CARGO_PACKAGES=()
# ... etc

# In scripts/extras/fcargo - load if needed
if [ -f "$SETUP_CONFIG" ]; then
    source "$SETUP_CONFIG"
fi
cargo_packages="${CARGO_PACKAGES[*]:-bob-nvim tree-sitter-cli stylua}"
```

**Alternatives Considered**:
1. **Load config in all scripts**: Rejected - wasteful
2. **Centralized config loader**: Rejected - adds complexity
3. **No defaults**: Rejected - requires config file

### Decision 8: Main Router Logic

**What**: The main `dotmarchy` script acts as a lightweight router

**Structure**:
```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# 1. Source core variable setup
mydir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${mydir}/helper/set_variable.sh"

# 2. Parse arguments and show welcome
source "${mydir}/helper/prompts.sh"
parse_args "$@"

# Exit early if --help or --verify
[[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] && usage && exit 0
[[ "$VERIFY_MODE" -eq 1 ]] && exec "${mydir}/scripts/fverify"

# 3. Initial checks
source "${mydir}/helper/checks.sh"
initial_checks

# 4. Show welcome
welcome

# 5. Execute core operations (always)
"${mydir}/scripts/core/fupdate"
"${mydir}/scripts/core/fchaotic"
"${mydir}/scripts/core/fdeps"
"${mydir}/scripts/core/fchaotic-deps"
"${mydir}/scripts/core/faur"
"${mydir}/scripts/core/fdotbare"

# 6. Execute extras (if --extras)
if [ "$INSTALL_EXTRAS" -eq 1 ]; then
    "${mydir}/scripts/extras/fnpm"
    "${mydir}/scripts/extras/fcargo"
    "${mydir}/scripts/extras/fpython"
    "${mydir}/scripts/extras/fruby"
    "${mydir}/scripts/extras/fgithub"
fi

# 7. Execute setup (if --setup-env)
if [ "$SETUP_ENVIRONMENT" -eq 1 ]; then
    "${mydir}/scripts/setup/fenv-dirs"
    "${mydir}/scripts/setup/fenv-repos"
    "${mydir}/scripts/setup/fenv-scripts"
    "${mydir}/scripts/setup/fenv-shell"
fi

# 8. Configure PATH (if extras or setup)
if [ "$INSTALL_EXTRAS" -eq 1 ] || [ "$SETUP_ENVIRONMENT" -eq 1 ]; then
    "${mydir}/scripts/extras/fpath"
fi

# 9. Show farewell
source "${mydir}/helper/logger.sh"
farewell
```

**Why**:
- Clear execution flow
- Easy to understand
- Easy to modify (add/remove operations)
- Each script can fail independently
- Exit codes propagate naturally

**Alternatives Considered**:
1. **Function calls**: Rejected - requires sourcing all scripts
2. **Parallel execution**: Rejected - order dependencies exist
3. **Conditional compilation**: Rejected - too complex

### Decision 9: Handling the Logo and Welcome Screen

**What**: Keep `logo()` and `welcome()` in `helper/prompts.sh`

**Why**:
- Logo is used by multiple scripts (main, individual operations)
- Welcome screen needs access to all configuration
- Prompts are part of user interaction layer

**Usage**:
```bash
# In any script
source "${mydir}/../helper/prompts.sh"
logo "Installing npm packages"
```

**Alternatives Considered**:
1. **Logo in colors.sh**: Rejected - not a color
2. **Logo in each script**: Rejected - duplication
3. **No logo in subscripts**: Considered - might do this

### Decision 10: Testing Strategy

**What**: Three-level testing approach

**1. Unit Testing** (Manual):
```bash
# Test helper
bash -c "source helper/logger.sh && info 'Test message'"

# Test script independently
./scripts/extras/fcargo
```

**2. Integration Testing** (Manual):
```bash
# Test full flow
./dotmarchy --extras

# Test with dry-run
DRY_RUN=1 ./dotmarchy --extras
```

**3. Shellcheck Validation** (Automated):
```bash
# Check all scripts
find . -name "*.sh" -exec shellcheck {} +
```

**Why**:
- Manual testing sufficient for bash scripts
- shellcheck catches common errors
- Integration testing verifies end-to-end flow

**Future Enhancement**: Add bats (Bash Automated Testing System) like dotbare uses

## Risks and Mitigations

### Risk 1: Breaking Changes

**Risk**: Refactoring introduces bugs or changes behavior

**Likelihood**: Medium  
**Impact**: High

**Mitigation**:
1. Comprehensive testing before deployment
2. Compare output with original script
3. Test all flag combinations
4. Keep original script as backup
5. Version as major release (v2.0.0)

### Risk 2: Performance Degradation

**Risk**: Multiple script executions slower than single script

**Likelihood**: Low  
**Impact**: Medium

**Analysis**:
- Bash script startup: ~5-10ms per script
- 15 scripts × 10ms = 150ms overhead
- Total installation time: 5-30 minutes
- Overhead: <0.5% of total time

**Mitigation**:
1. Measure performance before/after
2. Optimize if overhead >5%
3. Consider consolidating if necessary

### Risk 3: Complex Sourcing Chains

**Risk**: Helper dependencies create circular sourcing

**Likelihood**: Low  
**Impact**: Medium

**Mitigation**:
1. Clear dependency hierarchy (see diagram below)
2. No circular dependencies
3. Minimal cross-helper dependencies

**Dependency Hierarchy**:
```
set_variable.sh (no dependencies, exports variables)
    ↓
colors.sh (no dependencies, defines colors)
    ↓
logger.sh (requires colors.sh)
    ↓
utils.sh (requires colors.sh, logger.sh)
    ↓
checks.sh (requires logger.sh)
prompts.sh (requires all helpers)
```

### Risk 4: Variable Scope Issues

**Risk**: Environment variables not available in child scripts

**Likelihood**: Low  
**Impact**: Medium

**Mitigation**:
1. Explicit `export` for all shared variables
2. Test variable availability in subscripts
3. Document all exported variables

## Implementation Guidelines

### Code Style Standards

1. **Shebang**: `#!/usr/bin/env bash`
2. **Strict mode**: `set -Eeuo pipefail`
3. **Indentation**: 4 spaces (not tabs)
4. **Line length**: ~100 characters
5. **Function naming**: `snake_case`
6. **Variable naming**: 
   - Global: `UPPER_CASE`
   - Local: `snake_case`

### Script Template

```bash
#!/usr/bin/env bash
# shellcheck shell=bash
# shfmt: -ln=bash
#
# Brief description of what this script does
#
# @params
# Globals
#   ${VARIABLE_NAME}: description
# Arguments
#   $1: description
# Returns
#   0: success
#   1: failure

set -Eeuo pipefail

# Determine script directory
mydir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source required helpers
source "${mydir}/../helper/colors.sh"
source "${mydir}/../helper/logger.sh"
source "${mydir}/../helper/utils.sh"

# Display usage information
function usage() {
  echo -e "Usage: $(basename "$0") [-h] [OPTIONS]

Description of what this script does.

Optional arguments:
  -h, --help\t\tshow this help message and exit."
}

# Main function
function main() {
    clear 2>/dev/null || true
    logo "Descriptive Title"
    
    # Script logic here
}

# Execute only if invoked directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### Documentation Standards

Each file should have:
1. **Header comment**: What the file does
2. **Function documentation**: For each function
3. **Variable documentation**: For exported variables
4. **Usage function**: For executable scripts

## Open Questions

1. **Q**: Should individual scripts show the logo or just the main script?
   **A**: TBD - need to test UX with multiple logos

2. **Q**: Should we add a `--list` flag to show available commands like dotbare?
   **A**: TBD - not in current scope but good future enhancement

3. **Q**: Should core scripts be executable independently without main router?
   **A**: Yes - useful for testing and debugging

4. **Q**: Should we version helpers separately from main script?
   **A**: No - all components versioned together

## Migration Plan

### Phase 1: Development (3-4 days)
1. Create new branch: `refactor/modular-architecture`
2. Implement helpers
3. Implement scripts
4. Implement router
5. Test thoroughly

### Phase 2: Testing (1 day)
1. Test on clean Arch Linux VM
2. Compare with original script
3. Fix any issues

### Phase 3: Deployment (1 day)
1. Merge to master
2. Tag as v2.0.0
3. Update documentation
4. Announce changes

### Rollback Plan

If critical issues discovered:
1. Revert to v1.x branch
2. Tag as v1.x.y (patch release)
3. Fix issues in refactor branch
4. Re-deploy when stable

## Success Metrics

1. ✅ **Functionality**: 100% feature parity with original
2. ✅ **Compatibility**: All CLI flags work identically
3. ✅ **Performance**: Within 5% of original execution time
4. ✅ **Code Quality**: No shellcheck errors
5. ✅ **Maintainability**: Individual files <200 lines
6. ✅ **Testability**: Scripts can be tested independently
7. ✅ **Documentation**: All functions and variables documented

## References

- [dotbare repository](https://github.com/kazhala/dotbare) - Primary inspiration
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Bash Best Practices](https://bertvv.github.io/cheat-sheets/Bash.html)
- [ShellCheck Wiki](https://www.shellcheck.net/wiki/)

