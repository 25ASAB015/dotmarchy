# Modular Architecture Specification

## ADDED Requirements

### Requirement: Script Router Architecture

The system SHALL implement a main router script that orchestrates execution of modular components.

#### Scenario: Main router executes core operations
- **GIVEN** dotmarchy is invoked without flags
- **WHEN** the main script runs
- **THEN** all core operation scripts are executed in sequence
- **AND** each script receives exported environment variables
- **AND** execution stops if any core script fails

#### Scenario: Main router handles help flag
- **GIVEN** dotmarchy is invoked with --help flag
- **WHEN** argument parsing occurs
- **THEN** usage information is displayed
- **AND** no installation scripts are executed
- **AND** exit code is 0

#### Scenario: Main router handles conditional extras
- **GIVEN** dotmarchy is invoked with --extras flag
- **WHEN** core operations complete successfully
- **THEN** all extras scripts are executed
- **AND** extras scripts respect the INSTALL_EXTRAS environment variable

### Requirement: Helper Library System

The system SHALL provide reusable helper libraries that can be sourced by any script.

#### Scenario: Helper sourcing with relative paths
- **GIVEN** a script needs helper functionality
- **WHEN** the script sources a helper using relative paths
- **THEN** the helper is loaded successfully regardless of current working directory
- **AND** all helper functions become available to the script

#### Scenario: Helper dependency chain
- **GIVEN** helpers have dependencies on other helpers
- **WHEN** a helper is sourced
- **THEN** all required dependencies are available
- **AND** no circular dependencies exist
- **AND** sourcing order is deterministic

#### Scenario: Variable export from set_variable.sh
- **GIVEN** set_variable.sh is sourced
- **WHEN** child scripts are executed
- **THEN** all exported variables are available in child processes
- **AND** default values are set for undefined variables

### Requirement: Independent Executable Scripts

The system SHALL organize operations as independent executable scripts in categorized directories.

#### Scenario: Core script execution
- **GIVEN** a core operation script in scripts/core/
- **WHEN** the script is executed
- **THEN** it runs as a standalone process
- **AND** it sources only required helpers
- **AND** it performs a single well-defined operation
- **AND** it exits with 0 on success or non-zero on failure

#### Scenario: Script with usage information
- **GIVEN** any executable script
- **WHEN** invoked with --help flag
- **THEN** usage information is displayed
- **AND** the script exits without performing operations

#### Scenario: Script error handling
- **GIVEN** any executable script encounters an error
- **WHEN** the error occurs
- **THEN** the error is logged to ERROR_LOG
- **AND** the script exits with non-zero code
- **AND** the error message indicates the failure point

### Requirement: Color and Styling System

The system SHALL provide consistent color and styling definitions across all scripts.

#### Scenario: Color variables loaded
- **GIVEN** colors.sh is sourced
- **WHEN** a script uses color variables
- **THEN** terminal output is colorized correctly
- **AND** colors work in both tty and non-tty environments

#### Scenario: Color fallback for non-tty
- **GIVEN** output is redirected to a file
- **WHEN** tput commands fail
- **THEN** empty string fallbacks are used
- **AND** no errors are generated

### Requirement: Logging System

The system SHALL provide standardized logging functions for all output levels.

#### Scenario: Logging with different levels
- **GIVEN** logger.sh is sourced
- **WHEN** log(), info(), warn(), debug() are called
- **THEN** each produces appropriately formatted output
- **AND** debug() only outputs when VERBOSE=1
- **AND** colors are applied per log level

#### Scenario: Error logging to file
- **GIVEN** log_error() is called with an error message
- **WHEN** the function executes
- **THEN** the error is written to ERROR_LOG with timestamp
- **AND** the error is displayed to stderr
- **AND** the format includes timestamp and ERROR: prefix

#### Scenario: Execution timing
- **GIVEN** run() function is used to execute a command
- **WHEN** the command completes
- **THEN** execution time is displayed in human-readable format
- **AND** milliseconds are shown for fast operations
- **AND** seconds are shown for longer operations

### Requirement: Utility Functions Library

The system SHALL provide common utility functions for file operations and system checks.

#### Scenario: Command requirement check
- **GIVEN** require_cmd() is called with a command name
- **WHEN** the command is not available
- **THEN** an error is logged
- **AND** the script exits with code 127

#### Scenario: Repository URL normalization
- **GIVEN** normalize_repo_url() receives a git URL
- **WHEN** the URL is SSH format (git@github.com:user/repo)
- **THEN** it returns normalized form (github.com/user/repo)
- **AND** when the URL is HTTPS format
- **THEN** it returns the same normalized form

#### Scenario: SSH authentication check
- **GIVEN** check_ssh_auth() is called
- **WHEN** SSH keys are configured for GitHub
- **THEN** the function returns 0
- **AND** when SSH keys are not configured
- **THEN** the function returns 1

#### Scenario: Dry-run mode execution
- **GIVEN** DRY_RUN=1 environment variable is set
- **WHEN** run() is called with a command
- **THEN** the command description is displayed
- **AND** the command is NOT actually executed
- **AND** a dry-run indicator is shown

### Requirement: System Checks Module

The system SHALL perform validation checks before executing operations.

#### Scenario: Root user prevention
- **GIVEN** initial_checks() is called
- **WHEN** the script is run as root user
- **THEN** an error is displayed
- **AND** the script exits with code 1

#### Scenario: Home directory requirement
- **GIVEN** initial_checks() is called
- **WHEN** the current directory is not $HOME
- **THEN** an error is displayed
- **AND** the script exits with code 1

#### Scenario: Internet connectivity check
- **GIVEN** initial_checks() is called
- **WHEN** no internet connection is available
- **THEN** an error is displayed
- **AND** the script exits with code 1

#### Scenario: Arch Linux detection
- **GIVEN** initial_checks() is called
- **WHEN** pacman command is not available
- **THEN** an error indicating non-Arch system is displayed
- **AND** the script exits with code 1

### Requirement: User Interaction Module

The system SHALL provide consistent user prompts and argument parsing.

#### Scenario: CLI argument parsing
- **GIVEN** parse_args() is called with command line arguments
- **WHEN** arguments include --extras flag
- **THEN** INSTALL_EXTRAS is set to 1
- **AND** when arguments include --setup-env
- **THEN** SETUP_ENVIRONMENT is set to 1
- **AND** when arguments include --repo URL
- **THEN** REPO_URL is set to the provided URL

#### Scenario: Welcome screen display
- **GIVEN** welcome() is called
- **WHEN** user views the output
- **THEN** a clear summary of operations is shown
- **AND** core operations are always listed
- **AND** extras operations shown only if --extras flag present
- **AND** setup operations shown only if --setup-env flag present
- **AND** user is prompted to confirm before proceeding

#### Scenario: User confirmation prompt
- **GIVEN** welcome screen is displayed
- **WHEN** user responds with 'n' or empty input
- **THEN** the script exits with code 0
- **AND** no operations are performed
- **AND** when user responds with 'y' or 's'
- **THEN** operations proceed normally

### Requirement: Package Installation Scripts

The system SHALL provide dedicated scripts for each package manager source.

#### Scenario: NPM package installation
- **GIVEN** scripts/extras/fnpm is executed
- **WHEN** INSTALL_EXTRAS is set
- **THEN** NPM packages from config are installed globally
- **AND** already installed packages are skipped
- **AND** installation status is logged

#### Scenario: Cargo package installation
- **GIVEN** scripts/extras/fcargo is executed
- **WHEN** INSTALL_EXTRAS is set
- **THEN** Rust packages are installed via cargo
- **AND** binary name mapping is applied (bob-nvim → bob)
- **AND** rustup is installed if cargo is missing

#### Scenario: Python package installation on Arch
- **GIVEN** scripts/extras/fpython is executed on Arch Linux
- **WHEN** PEP 668 is detected
- **THEN** only pipx is used for installations
- **AND** system packages (python-*) are recommended
- **AND** no pip --user installations are attempted

### Requirement: Development Environment Setup Scripts

The system SHALL provide scripts for automated environment configuration.

#### Scenario: Directory structure creation
- **GIVEN** scripts/setup/fenv-dirs is executed
- **WHEN** SETUP_ENVIRONMENT is set
- **THEN** directories from DIRECTORIES array are created
- **AND** tilde (~) expansion works correctly
- **AND** already existing directories are skipped

#### Scenario: Git repository cloning
- **GIVEN** scripts/setup/fenv-repos is executed
- **WHEN** SETUP_ENVIRONMENT is set
- **THEN** repositories from GIT_REPOS array are cloned
- **AND** URL:DESTINATION format is parsed correctly
- **AND** already cloned repositories are skipped

#### Scenario: Script downloads
- **GIVEN** scripts/setup/fenv-scripts is executed
- **WHEN** SETUP_ENVIRONMENT is set
- **THEN** scripts from SCRIPTS array are downloaded
- **AND** downloaded scripts are made executable
- **AND** already downloaded scripts are skipped

#### Scenario: Shell configuration
- **GIVEN** scripts/setup/fenv-shell is executed
- **WHEN** SETUP_ENVIRONMENT is set
- **THEN** lines from SHELL_LINES array are added to shell config
- **AND** duplicate lines are prevented (idempotent)
- **AND** appropriate shell config file is detected (.zshrc or .bashrc)

### Requirement: Installation Verification

The system SHALL provide comprehensive verification of installed tools and configurations.

#### Scenario: Tool verification
- **GIVEN** scripts/fverify is executed
- **WHEN** checking installed tools
- **THEN** each tool's presence is verified
- **AND** version information is displayed when available
- **AND** optional tools show warnings instead of errors

#### Scenario: PATH verification
- **GIVEN** scripts/fverify is executed
- **WHEN** checking PATH configuration
- **THEN** essential paths are verified to be in PATH
- **AND** missing paths show remediation instructions

#### Scenario: Verification summary
- **GIVEN** verification completes
- **WHEN** results are displayed
- **THEN** total counts are shown (success, warnings, failures)
- **AND** failed tools are listed with names
- **AND** exit code is 0 if all required tools present
- **AND** exit code is 1 if required tools missing

### Requirement: Error Handling and Recovery

The system SHALL implement consistent error handling across all components.

#### Scenario: Script failure propagation
- **GIVEN** a core script fails
- **WHEN** executed by the main router
- **THEN** the router stops execution
- **AND** subsequent scripts are not executed
- **AND** the error code is propagated to the caller

#### Scenario: Error trap activation
- **GIVEN** set -Eeuo pipefail is configured
- **WHEN** any command fails in a script
- **THEN** the ERR trap is triggered
- **AND** error line number is logged
- **AND** script exits immediately

#### Scenario: Graceful error messages
- **GIVEN** an error occurs
- **WHEN** log_error() is called
- **THEN** a human-readable error message is displayed
- **AND** the message includes context about the failure
- **AND** the error is logged to ERROR_LOG file

### Requirement: Backward Compatibility

The system SHALL maintain 100% CLI compatibility with the monolithic version.

#### Scenario: Identical CLI interface
- **GIVEN** any CLI command from monolithic version
- **WHEN** the same command is run with modular version
- **THEN** the behavior is identical
- **AND** output format is the same
- **AND** exit codes are the same

#### Scenario: Environment variable compatibility
- **GIVEN** environment variables used with monolithic version
- **WHEN** the same variables are used with modular version
- **THEN** they have the same effect
- **AND** DRY_RUN, VERBOSE, FORCE all work identically

#### Scenario: Configuration file compatibility
- **GIVEN** existing setup.conf file
- **WHEN** modular version is executed
- **THEN** the config file is read correctly
- **AND** all arrays and variables are respected
- **AND** no changes to config format required

