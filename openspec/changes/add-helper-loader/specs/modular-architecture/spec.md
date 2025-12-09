## MODIFIED Requirements
### Requirement: Helper Library System

The system SHALL provide reusable helper libraries that can be sourced by any script and SHALL include a centralized loader to ensure deterministic ordering and consistent error handling.

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

#### Scenario: Centralized helper loader
- **GIVEN** scripts need a standard set of helpers
- **WHEN** a script invokes the centralized helper loader
- **THEN** required helpers are sourced in a single call in deterministic order
- **AND** missing helper files trigger a consistent error and exit
- **AND** scripts consistently use the same directory variable to locate the helper folder
