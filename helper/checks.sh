#!/usr/bin/env bash
# shellcheck shell=bash
#
# checks.sh - System validation checks for dotmarchy
#
# This helper provides functions to verify system requirements and package
# installation status. It depends on logger.sh for error reporting.
#
# @params
# Functions:
#   initial_checks(): Verify system requirements before installation
#   is_installed(): Check if a package is installed via pacman
#
# Requirements:
#   - Must not be run as root
#   - Must be executed from $HOME directory
#   - Must have internet connection
#   - Must be running on Arch Linux (pacman available)

set -Eeuo pipefail

# Source dependencies if not already loaded
if [ -z "${CGR:-}" ]; then
    HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${HELPER_DIR}/colors.sh"
    source "${HELPER_DIR}/logger.sh"
fi

#######################################
# Perform initial system checks
# Verifies:
#   - Not running as root
#   - Internet connection available
#   - Running on Arch Linux (pacman present)
# Returns:
#   0 if all checks pass
#   1 and exits if any check fails
#######################################
initial_checks() {
    # Verify NOT running as root
    if [ "$(id -u)" = 0 ]; then
        log_error "This script MUST NOT be run as root user."
        exit 1
    fi
    
    # Verify internet connection (quick ping to 8.8.8.8)
    if ! ping -q -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
        log_error "No internet connection detected."
        exit 1
    fi
    
    # Verify running on Arch Linux (requires pacman)
    if ! command -v pacman >/dev/null 2>&1; then
        log_error "Este script está pensado para Arch/Manjaro (requiere pacman)."
        exit 1
    fi
}

#######################################
# Check if a package is installed
# Uses pacman to query installed packages
# Arguments:
#   $1: Package name to check
# Returns:
#   0 if package is installed
#   1 if package is not installed
#######################################
is_installed() {
    pacman -Qq "$1" >/dev/null 2>&1
}

