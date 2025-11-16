#!/usr/bin/env bash
# shellcheck shell=bash
#
# logger.sh - Logging functions and utilities for dotmarchy
#
# This helper provides standardized logging functions for all output levels,
# timing utilities, and error handling. It depends on colors.sh for color
# definitions and set_variable.sh for configuration variables.
#
# @params
# Globals:
#   ${VERBOSE}: Controls debug output (from set_variable.sh)
#   ${ERROR_LOG}: Path to error log file (from set_variable.sh)
#   ${CRE}, ${CYE}, ${CGR}, ${CBL}, ${BLD}, ${CNC}: Color variables (from colors.sh)
#
# Functions:
#   log(): Simple output with no formatting
#   info(): Blue informational message
#   print_info(): Alias for info() (compatibility)
#   warn(): Bold yellow warning message
#   step(): Blue bullet point for step indication
#   debug(): Conditional debug message (only if VERBOSE=1)
#   now_ms(): Get current time in milliseconds
#   fmt_ms(): Format milliseconds to human-readable duration
#   log_error(): Log error to file and display to stderr
#   on_error(): Error trap handler

set -Eeuo pipefail

# Source colors if not already loaded
if [ -z "${CGR:-}" ]; then
    # Determine helper directory
    HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${HELPER_DIR}/colors.sh"
fi

#######################################
# Simple output with no formatting
# Arguments:
#   $*: Message to output
# Outputs:
#   Message to stdout
#######################################
log() {
    printf "%s\n" "$*"
}

#######################################
# Informational message in blue
# Arguments:
#   $*: Message to output
# Outputs:
#   Blue colored message to stdout
#######################################
info() {
    printf "%b%s%b\n" "${CBL}" "$*" "${CNC}"
}

#######################################
# Alias for info() for compatibility
# Arguments:
#   $*: Message to output
# Outputs:
#   Blue colored message to stdout
#######################################
print_info() {
    info "$@"
}

#######################################
# Warning message in bold yellow
# Arguments:
#   $*: Warning message
# Outputs:
#   Bold yellow message to stdout
#######################################
warn() {
    printf "%b%s%b\n" "${CYE}${BLD}" "$*" "${CNC}"
}

#######################################
# Step indicator with blue bullet
# Arguments:
#   $*: Step description
# Outputs:
#   Bold blue » followed by description
#######################################
step() {
    printf "%b»%b %s\n" "${BLD}${CBL}" "${CNC}" "$*"
}

#######################################
# Debug message (only output if VERBOSE=1)
# Arguments:
#   $*: Debug message
# Outputs:
#   Bold message if VERBOSE=1, nothing otherwise
#######################################
debug() {
    [ "${VERBOSE:-0}" -eq 1 ] && printf "%b… %s%b\n" "${BLD}" "$*" "${CNC}" || true
}

#######################################
# Get current time in milliseconds
# Outputs:
#   Current timestamp in milliseconds
#######################################
now_ms() {
    date +%s%3N 2>/dev/null || echo $(($(date +%s) * 1000))
}

#######################################
# Format milliseconds to human-readable duration
# Arguments:
#   $1: Duration in milliseconds
# Outputs:
#   Formatted duration (e.g., "1.5s" or "250ms")
#######################################
fmt_ms() {
    local ms=${1:-0}
    if [ "$ms" -ge 1000 ]; then
        local s=$((ms / 1000))
        local t=$(((ms % 1000) / 100))
        printf "%d.%ds" "$s" "$t"
    else
        printf "%dms" "$ms"
    fi
}

#######################################
# Log error message to file and display to stderr
# Arguments:
#   $1: Error message
# Outputs:
#   Timestamped error to ERROR_LOG file
#   Colored error to stderr
#######################################
log_error() {
    local error_msg=$1
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Log to file
    printf "%s" "[${timestamp}] ERROR: ${error_msg}\n" >> "${ERROR_LOG:-/tmp/dotmarchy-error.log}"
    
    # Display to stderr
    printf "%s%sERROR:%s %s\n" "${CRE}" "${BLD}" "${CNC}" "${error_msg}" >&2
}

#######################################
# Error trap handler (call on ERR signal)
# Globals:
#   BASH_LINENO: Array of line numbers (bash built-in)
# Outputs:
#   Error message with line number
# Returns:
#   Exits with the error code
#######################################
on_error() {
    local exit_code=$?
    local line=${BASH_LINENO[0]:-UNKNOWN}
    log_error "Fallo en la línea ${line}. Código: ${exit_code}"
    exit "$exit_code"
}

# Note: Scripts that want to use on_error should set up the trap themselves:
# trap on_error ERR

