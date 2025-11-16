#!/usr/bin/env bash
# shellcheck shell=bash
#
# utils.sh - General utility functions for dotmarchy
#
# This helper provides utility functions for command execution, repository URL
# handling, system checks, and Node.js/npm management. It depends on colors.sh
# and logger.sh for output formatting.
#
# @params
# Globals:
#   ${DRY_RUN}: Flag for dry-run mode (from set_variable.sh)
#   ${SKIP_SYSTEM}: Flag for skipping system checks (from set_variable.sh)
#
# Functions:
#   run(): Execute command with description and timing
#   require_cmd(): Verify command exists or exit
#   normalize_repo_url(): Normalize git URL for comparison
#   ssh_to_https(): Convert SSH URL to HTTPS
#   check_ssh_auth(): Check if SSH authentication is available
#   get_nvm_dir(): Get NVM directory (XDG first, then ~/.nvm)
#   preflight_utils(): Check required utilities for GitHub downloads
#   ensure_node_available(): Ensure Node.js >= 18 is available

set -Eeuo pipefail

# Source dependencies if not already loaded
if [ -z "${CGR:-}" ]; then
    HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${HELPER_DIR}/colors.sh"
    source "${HELPER_DIR}/logger.sh"
fi

#######################################
# Execute command with description and timing
# Respects DRY_RUN flag
# Arguments:
#   $1: Description of the command
#   $@: Command to execute
# Outputs:
#   Step description, command (if DRY_RUN), timing
#######################################
run() {
    local desc="$1"
    shift
    step "$desc"
    debug "Comando: $*"
    
    if [ "${DRY_RUN:-0}" -eq 1 ]; then
        log "   ↳ (dry-run) $*"
        return 0
    fi
    
    local start end dur
    start=$(now_ms)
    "$@"
    end=$(now_ms)
    dur=$((end - start))
    log "   ↳ ✔ Hecho en $(fmt_ms "$dur")"
}

#######################################
# Verify that a command exists
# Exits with code 127 if command not found
# Arguments:
#   $1: Command name to check
# Returns:
#   0 if command exists
#   127 if command not found (exits)
#######################################
require_cmd() {
    local name="$1"
    command -v "$name" >/dev/null 2>&1 || {
        log_error "No se encontró el comando requerido: $name"
        exit 127
    }
}

#######################################
# Normalize repository URL for comparison
# Converts URLs to host/owner/repo format in lowercase
# Arguments:
#   $1: Git repository URL (SSH or HTTPS)
# Outputs:
#   Normalized URL (e.g., github.com/owner/repo)
#######################################
normalize_repo_url() {
    local url="$1"
    url=${url%%.git}
    
    # SSH format: git@github.com:owner/repo
    if [[ $url =~ ^git@([^:]+):(.+)$ ]]; then
        echo "${BASH_REMATCH[1]}/${BASH_REMATCH[2]}" | tr '[:upper:]' '[:lower:]'
        return 0
    fi
    
    # HTTPS format: https://github.com/owner/repo
    if [[ $url =~ ^https?://([^/]+)/(.+)$ ]]; then
        echo "${BASH_REMATCH[1]}/${BASH_REMATCH[2]}" | tr '[:upper:]' '[:lower:]'
        return 0
    fi
    
    # Already normalized: host/owner/repo
    echo "$url" | tr '[:upper:]' '[:lower:]'
}

#######################################
# Convert SSH URL to HTTPS format
# Arguments:
#   $1: Git repository URL
# Outputs:
#   HTTPS URL
#######################################
ssh_to_https() {
    local url="$1"
    
    # SSH format: git@github.com:owner/repo -> https://github.com/owner/repo
    if [[ $url =~ ^git@([^:]+):(.+)$ ]]; then
        local host="${BASH_REMATCH[1]}"
        local path="${BASH_REMATCH[2]}"
        # Add .git if not present
        [[ $path =~ \.git$ ]] || path="${path}.git"
        echo "https://${host}/${path}"
        return 0
    fi
    
    # Already HTTPS, return as-is
    echo "$url"
}

#######################################
# Check if SSH authentication is available for GitHub
# Tests SSH connection to git@github.com
# Returns:
#   0 if SSH is configured and working
#   1 if SSH is not configured or fails
#######################################
check_ssh_auth() {
    # Attempt SSH connection to GitHub (short timeout)
    local ssh_output ssh_exit
    ssh_output=$(ssh -T -o ConnectTimeout=5 -o StrictHostKeyChecking=no git@github.com 2>&1)
    ssh_exit=$?
    
    # Check for successful authentication message
    if echo "$ssh_output" | grep -qi "successfully authenticated"; then
        return 0
    fi
    
    # Check for permission denied
    if [ "$ssh_exit" -eq 1 ] && echo "$ssh_output" | grep -qi "permission denied\|publickey"; then
        return 1
    fi
    
    # Other errors (timeout, network, etc.)
    return 1
}

#######################################
# Get NVM directory
# Prefers XDG config location, falls back to ~/.nvm
# Outputs:
#   Path to NVM directory
#######################################
get_nvm_dir() {
    local xdg="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
    
    if [ -d "$xdg" ]; then
        echo "$xdg"
        return
    fi
    
    if [ -d "$HOME/.nvm" ]; then
        echo "$HOME/.nvm"
        return
    fi
    
    # Prefer XDG if neither exists
    echo "$xdg"
}

#######################################
# Check for required utilities for GitHub downloads
# Verifies: curl, wget, jq, tar, unzip
# Globals:
#   ${SKIP_SYSTEM}: If set and utilities missing, exits with error
# Returns:
#   0 if all utilities present
#   1 if utilities missing and SKIP_SYSTEM=1
#######################################
preflight_utils() {
    local req=(curl wget jq tar unzip)
    local missing=()
    
    for c in "${req[@]}"; do
        command -v "$c" >/dev/null 2>&1 || missing+=("$c")
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        if [ "${SKIP_SYSTEM:-0}" -eq 1 ]; then
            log_error "Faltan utilidades requeridas: ${missing[*]}"
            log_error "Ejecuta el instalador completo sin -s para instalarlas automáticamente."
            exit 1
        fi
    fi
}

#######################################
# Ensure Node.js >= 18 is available
# If not available or version < 18, attempts to install via NVM
# Globals:
#   ${NVM_DIR}: NVM directory path (exported)
#   ${PATH}: Updated with npm prefix if needed
# Returns:
#   0 if npm is available
#   1 if npm cannot be made available
#######################################
ensure_node_available() {
    local need_install=
    
    # Check if Node.js is installed and version is sufficient
    if command -v node >/dev/null 2>&1; then
        local ver
        ver=$(node -v 2>/dev/null | sed -E 's/^v([0-9]+).*/\1/')
        if [ -z "${ver:-}" ] || [ "$ver" -lt 18 ]; then
            print_info "Node.js < 18 detectado. Intentando usar NVM para instalar LTS ..."
            need_install=1
        fi
    else
        print_info "Node.js no detectado. Intentando instalar con NVM (LTS) ..."
        need_install=1
    fi
    
    # Install or load NVM if needed
    if [ "${need_install:-}" ]; then
        local NVM_DIR
        NVM_DIR="$(get_nvm_dir)"
        export NVM_DIR
        
        if [ -s "$NVM_DIR/nvm.sh" ]; then
            # shellcheck disable=SC1090,SC1091
            . "$NVM_DIR/nvm.sh"
        else
            # Install NVM
            mkdir -p "$(dirname "$NVM_DIR")"
            export NVM_DIR
            curl -sS --connect-timeout 5 --max-time 30 --retry 3 --retry-delay 2 \
                https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
            # shellcheck disable=SC1090,SC1091
            [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        fi
        
        # Install and use LTS version
        if command -v nvm >/dev/null 2>&1; then
            nvm install --lts >/dev/null 2>&1 || nvm install --lts
            nvm use --lts >/dev/null 2>&1 || nvm use --lts
        else
            warn "No se pudo instalar/cargar NVM. Continuando con Node.js existente si lo hay."
        fi
    fi
    
    # Configure npm prefix if not using NVM
    if ! command -v nvm >/dev/null 2>&1; then
        export PATH="$HOME/.local/bin:$PATH"
        
        if command -v npm >/dev/null 2>&1; then
            local prefix
            prefix=$(npm config get prefix 2>/dev/null || echo "")
            if [ -z "$prefix" ] || [ "$prefix" = "/usr" ] || [ "$prefix" = "/usr/local" ]; then
                npm config set prefix "$HOME/.local" >/dev/null 2>&1 || true
            fi
        fi
    fi
    
    # Final verification
    if ! command -v npm >/dev/null 2>&1; then
        log_error "npm no está disponible tras intentar instalar Node.js."
        return 1
    fi
    
    return 0
}

