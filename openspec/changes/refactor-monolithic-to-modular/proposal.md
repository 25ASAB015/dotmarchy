# Change: Refactor Monolithic Bash Script to Modular Architecture

## Why

The current `dotmarchy` script is a monolithic 2465-line bash script that contains all functionality in a single file. This creates several maintenance and development challenges:

- **Difficult to maintain**: Changes require navigating through 2400+ lines of code
- **Hard to test**: Individual components cannot be tested in isolation
- **Poor reusability**: Helper functions are tightly coupled to the main script
- **Difficult to extend**: Adding new package managers or features requires modifying the monolithic file
- **No separation of concerns**: Core functionality, extras, and setup logic are intermingled
- **Collaboration challenges**: Multiple developers cannot easily work on different features simultaneously

## What Changes

Refactor the monolithic `dotmarchy` script into a modular architecture following the proven pattern of [kazhala/dotbare](https://github.com/kazhala/dotbare), which uses:

- A lightweight main entry script that routes commands
- Individual executable scripts for each major operation
- Shared helper libraries for common functionality
- Clear separation between core, extras, and setup operations

### High-Level Structure

```
dotmarchy/                      # Root directory
├── dotmarchy                   # Main entry point (router script, ~150 lines)
├── helper/                     # Shared helper libraries (sourceable, not executable)
│   ├── set_variable.sh         # Environment variables, constants, defaults
│   ├── colors.sh               # Color definitions and styling
│   ├── logger.sh               # Logging functions (log, info, warn, debug, etc.)
│   ├── utils.sh                # General utilities (run, require_cmd, etc.)
│   ├── checks.sh               # System checks (initial_checks, check_ssh_auth)
│   └── prompts.sh              # User interaction (welcome, usage, parse_args)
└── scripts/                    # Executable command scripts
    ├── core/                   # Core operations (always run)
    │   ├── fupdate             # System update (pacman -Syu)
    │   ├── fchaotic            # Chaotic-AUR setup
    │   ├── fdeps               # Install official repo dependencies
    │   ├── fchaotic-deps       # Install Chaotic-AUR packages
    │   ├── faur                # Install AUR packages
    │   └── fdotbare            # Configure dotbare
    ├── extras/                 # Optional operations (--extras flag)
    │   ├── fnpm                # Install npm packages
    │   ├── fcargo              # Install cargo packages
    │   ├── fpython             # Install Python packages (pip/pipx)
    │   ├── fruby               # Install Ruby gems
    │   ├── fgithub             # Install GitHub release tools
    │   └── fpath               # Configure PATH
    ├── setup/                  # Environment setup (--setup-env flag)
    │   ├── fenv-dirs           # Create directory structure
    │   ├── fenv-repos          # Clone git repositories
    │   ├── fenv-scripts        # Download scripts
    │   └── fenv-shell          # Configure shell
    └── fverify                 # Verification script (--verify flag)
```

### Specific Changes

**BREAKING**: None - the CLI interface remains identical

1. **Create modular structure**:
   - Extract 6 helper libraries from monolithic script
   - Create 15 independent operation scripts
   - Implement main router script

2. **Maintain all existing functionality**:
   - All CLI flags work identically (`--extras`, `--setup-env`, `--verify`, `--repo`, `--help`)
   - All environment variables respected (`DRY_RUN`, `VERBOSE`, `FORCE`, etc.)
   - Identical user experience and output

3. **Improve maintainability**:
   - Each script is self-contained and testable
   - Clear dependencies through explicit sourcing
   - Standard error handling in each module
   - Consistent structure across all scripts

4. **Enable extensibility**:
   - New package managers can be added as new scripts in `scripts/extras/`
   - New core operations can be added without modifying existing code
   - Helper functions can be reused across scripts

## Impact

### Affected Specs
- None (new codebase, no existing specifications)

### Affected Code
- **Modified**: `dotmarchy` (main script) - reduced from 2465 lines to ~150 lines
- **Added**: 6 helper libraries (~800 total lines)
- **Added**: 15 executable scripts (~1600 total lines)
- **Total**: ~2550 lines (slight increase due to headers/documentation in each file)

### Migration Path
- No user action required - the refactored version maintains 100% CLI compatibility
- Internal structure change only
- Can be deployed as a drop-in replacement

### Benefits
1. **Maintainability**: Each module is <200 lines, easy to understand
2. **Testability**: Individual scripts can be tested in isolation
3. **Extensibility**: New package managers or operations can be added easily
4. **Collaboration**: Multiple developers can work on different modules
5. **Debugging**: Easier to identify and fix issues in specific modules
6. **Documentation**: Each script has clear purpose and usage

### Risks
- Temporary: Learning curve for contributors unfamiliar with modular structure
- Mitigated: Clear documentation and consistent patterns across all modules
- Testing: Must ensure all execution paths work correctly after refactoring
- Mitigated: Comprehensive testing plan in tasks.md

### Timeline
- Estimated effort: 3-4 days
- Phase 1: Extract helpers (1 day)
- Phase 2: Create core scripts (1 day)
- Phase 3: Create extras/setup scripts (1 day)
- Phase 4: Testing and refinement (1 day)

