#!/usr/bin/env bash
# shellcheck shell=bash
#
# prompts.sh - User interaction and CLI parsing for dotmarchy
#
# This helper provides functions for displaying the logo, usage information,
# parsing command-line arguments, and showing the welcome screen with
# confirmation prompts. It's the main user-facing interface for dotmarchy.
#
# @params
# Globals:
#   ${REPO_URL}: Repository URL (from set_variable.sh, can be modified by parse_args)
#   ${INSTALL_EXTRAS}: Flag for extras installation (modified by parse_args)
#   ${SETUP_ENVIRONMENT}: Flag for environment setup (modified by parse_args)
#   ${VERIFY_MODE}: Flag for verification mode (modified by parse_args)
#   ${SETUP_CONFIG}: Path to setup configuration file
#   ${CORE_DEPENDENCIES}: Core package list
#   ${ERROR_LOG}: Path to error log file
#
# Functions:
#   logo(): Display ASCII logo with message
#   usage(): Display help information
#   parse_args(): Parse command-line arguments
#   welcome(): Display welcome screen and get user confirmation

set -Eeuo pipefail

# Source dependencies if not already loaded
if [ -z "${CGR:-}" ]; then
    HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "${HELPER_DIR}/colors.sh"
    source "${HELPER_DIR}/logger.sh"
fi

#######################################
# Display ASCII logo with message
# Arguments:
#   $1: Message text to display below logo
# Outputs:
#   ASCII art logo with colored message
#######################################
logo() {
    local text="$1"
    printf "%b" "
   ▗▖                              ▗▖        
   ▐▌      ▐▌                      ▐▌        
 ▟█▟▌ ▟█▙ ▐███ ▐█▙█▖ ▟██▖ █▟█▌ ▟██▖▐▙██▖▝█ █▌
▐▛ ▜▌▐▛ ▜▌ ▐▌  ▐▌█▐▌ ▘▄▟▌ █▘  ▐▛  ▘▐▛ ▐▌ █▖█ 
▐▌ ▐▌▐▌ ▐▌ ▐▌  ▐▌█▐▌▗█▀▜▌ █   ▐▌   ▐▌ ▐▌ ▐█▛ 
▝█▄█▌▝█▄█▘ ▐▙▄ ▐▌█▐▌▐▙▄█▌ █   ▝█▄▄▌▐▌ ▐▌  █▌ 
 ▝▀▝▘ ▝▀▘   ▀▀ ▝▘▀▝▘ ▀▀▝▘ ▀    ▝▀▀ ▝▘ ▝▘  █  
                                         █▌  

   ${BLD}${CRE}[ ${CYE}${text} ${CRE}]${CNC}\n\n"
}

#######################################
# Display usage information
# Outputs:
#   Help text with all available options and examples
#######################################
usage() {
    cat << EOF
Uso: dotmarchy [opciones] [REPO_URL]

Opciones:
  --repo URL      Especifica el repositorio de dotfiles a usar
  --extras        Instala paquetes adicionales opcionales además de los core
  --setup-env     Configura entorno de desarrollo (directorios, repos, scripts)
  --verify        Verifica la instalación de herramientas sin instalar nada
  -h, --help      Muestra esta ayuda y sale

Posicional:
  REPO_URL        Alternativamente puedes pasar la URL del repo como primer argumento

Archivo de configuración:
  ~/.config/dotmarchy/setup.conf   Define configuración para --setup-env

Ejemplos:
  dotmarchy --repo https://github.com/yo/mis-dotfiles.git
  dotmarchy git@github.com:yo/mis-dotfiles.git
  dotmarchy --extras
  dotmarchy --extras --setup-env
  dotmarchy --verify
EOF
}

#######################################
# Parse command-line arguments
# Modifies global variables based on flags
# Arguments:
#   $@: Command-line arguments
# Globals modified:
#   ${REPO_URL}: Set by --repo flag or positional argument
#   ${INSTALL_EXTRAS}: Set to 1 by --extras flag
#   ${SETUP_ENVIRONMENT}: Set to 1 by --setup-env flag
#   ${VERIFY_MODE}: Set to 1 by --verify flag
# Returns:
#   0 on success
#   Exits with 2 on unknown option
#######################################
parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --repo)
                shift || true
                REPO_URL="${1:-$REPO_URL}"
                ;;
            --extras)
                INSTALL_EXTRAS=1
                ;;
            --setup-env)
                SETUP_ENVIRONMENT=1
                ;;
            --verify)
                VERIFY_MODE=1
                ;;
            -h | --help)
                usage
                return 0
                ;;
            -*)
                log_error "Opción desconocida: $1"
                usage
                exit 2
                ;;
            *)
                # Positional argument: repository URL
                REPO_URL="$1"
                ;;
        esac
        shift || true
    done
}

#######################################
# Display welcome screen and get user confirmation
# Shows different information based on active flags
# Prompts user to confirm before proceeding
# Globals:
#   ${INSTALL_EXTRAS}: Controls extras section display
#   ${SETUP_ENVIRONMENT}: Controls setup section display
#   ${REPO_URL}: Repository to clone
#   ${CORE_DEPENDENCIES}: Core packages to install
#   ${SETUP_CONFIG}: Configuration file path
#   ${ERROR_LOG}: Error log path
# Returns:
#   0 if user confirms
#   Exits with 0 if user cancels
#######################################
welcome() {
    clear 2>/dev/null || true
    logo "Bienvenido a dotmarchy, $USER"
    
    # Main header
    printf "%b" "${BLD}${CGR}Este script instalará y configurará tus dotfiles de forma segura y automatizada.${CNC}

"
    
    # ===== SECTION 1: BASIC OPERATIONS (always executed) =====
    local core_count
    core_count=$(echo "$CORE_DEPENDENCIES" | wc -w)
    
    printf "%b" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}
${BLD}${CBL}  OPERACIONES BÁSICAS ${CGR}(se ejecutarán siempre)${CNC}
${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}

  ${CGR}✓${CNC} Actualización del sistema con ${BLD}pacman -Syu${CNC}
  ${CGR}✓${CNC} Configuración del repositorio ${BLD}Chaotic-AUR${CNC}
  ${CGR}✓${CNC} Instalación de paquetes CORE (${CYE}${core_count}${CNC} paquetes):
      ${BLD}→${CNC} ${CYE}${CORE_DEPENDENCIES}${CNC}
  ${CGR}✓${CNC} Configuración de ${BLD}dotbare${CNC} para gestión de dotfiles
  ${CGR}✓${CNC} Clonado de repositorio: ${BLD}${CBL}$(basename "$REPO_URL" .git)${CNC}
  ${CGR}✓${CNC} Respaldos automáticos de configuraciones existentes

"
    
    # ===== SECTION 2: EXTRA PACKAGES (optional) =====
    if [ "$INSTALL_EXTRAS" -eq 1 ]; then
        # Load configuration to get real package counts
        local dev_count=0 chaotic_count=0 aur_count=0 npm_count=0
        local cargo_count=0 pipx_count=0 gem_count=0
        
        if [ -f "$SETUP_CONFIG" ]; then
            # shellcheck source=/dev/null
            source "$SETUP_CONFIG" 2>/dev/null || true
            
            dev_count=${#EXTRA_DEPENDENCIES[@]}
            chaotic_count=${#EXTRA_CHAOTIC_DEPENDENCIES[@]}
            aur_count=${#EXTRA_AUR_APPS[@]}
            npm_count=${#EXTRA_NPM_PACKAGES[@]}
            cargo_count=${#CARGO_PACKAGES[@]}
            pipx_count=${#PIPX_PACKAGES[@]}
            gem_count=${#GEM_PACKAGES[@]}
        else
            # Use defaults if no config
            dev_count=$(echo "$DEFAULT_EXTRA_DEPENDENCIES" | wc -w)
            chaotic_count=$(echo "$DEFAULT_EXTRA_CHAOTIC_DEPENDENCIES" | wc -w)
            aur_count=$(echo "$DEFAULT_EXTRA_AUR_APPS" | wc -w)
            npm_count=$(echo "$DEFAULT_EXTRA_NPM_PACKAGES" | wc -w)
            cargo_count=3  # bob-nvim tree-sitter-cli stylua
            pipx_count=11  # doq beautysh black ruff neovim-remote flake8 python-lsp-server pyright rich-cli trash-cli codespell
            gem_count=1    # neovim
        fi
        
        local github_count=7  # NVM, Lua-LS, lazygit, gh, zoxide, tldr, deno
        local total_extras=$((dev_count + chaotic_count + aur_count + npm_count + cargo_count + pipx_count + gem_count + github_count))
        
        printf "%b" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}
${BLD}${CBL}  PAQUETES EXTRAS ${CGR}(--extras ACTIVADO ✓)${CNC}
${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}

  ${CGR}✓${CNC} ${BLD}Total de paquetes extras a instalar: ${CYE}$total_extras${CNC}
  ${CBL}ℹ${CNC}  Incluyendo paquetes del sistema, npm, cargo, python, ruby, y GitHub

"
        
        [ "$dev_count" -gt 0 ] && printf "%b" "  ${CGR}✓${CNC} Paquetes desde repositorios oficiales (${CYE}$dev_count${CNC} paquetes)\n"
        [ "$chaotic_count" -gt 0 ] && printf "%b" "  ${CGR}✓${CNC} Paquetes desde Chaotic-AUR (${CYE}$chaotic_count${CNC} paquetes)\n"
        [ "$aur_count" -gt 0 ] && printf "%b" "  ${CGR}✓${CNC} Paquetes desde AUR (${CYE}$aur_count${CNC} paquetes)\n"
        [ "$npm_count" -gt 0 ] && printf "%b" "  ${CGR}✓${CNC} Paquetes globales de npm (${CYE}$npm_count${CNC} paquetes)\n"
        [ "$cargo_count" -gt 0 ] && printf "%b" "  ${CGR}✓${CNC} Paquetes de Rust/Cargo (${CYE}$cargo_count${CNC} paquetes)\n"
        [ "$pipx_count" -gt 0 ] && printf "%b" "  ${CGR}✓${CNC} Aplicaciones Python/pipx (${CYE}$pipx_count${CNC} paquetes)\n"
        [ "$gem_count" -gt 0 ] && printf "%b" "  ${CGR}✓${CNC} Gemas de Ruby (${CYE}$gem_count${CNC} paquete(s))\n"
        
        printf "%b" "  ${CGR}✓${CNC} Herramientas desde GitHub (${CYE}7${CNC} herramientas):
      ${BLD}→${CNC} ${CYE}NVM, Lua-LS, lazygit, gh, zoxide, tldr, deno${CNC}

  ${CBL}ℹ${CNC}  Personaliza estos paquetes en: ${CBL}${SETUP_CONFIG}${CNC}

"
    else
        printf "%b" "${BLD}${CYE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}
${BLD}${CYE}  PAQUETES EXTRAS ${CRE}(--extras NO activado ✗)${CNC}
${BLD}${CYE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}

  ${CYE}⚠${CNC}  Solo se instalarán los ${core_count} paquetes CORE básicos.
  
  ${CGR}💡 Activa --extras para instalar ~100+ paquetes adicionales desde:${CNC}
      ${BLD}→${CNC} Repositorios oficiales (pacman) - herramientas del sistema
      ${BLD}→${CNC} Chaotic-AUR (binarios precompilados) - apps populares
      ${BLD}→${CNC} AUR (compilación local) - temas y plugins
      ${BLD}→${CNC} npm (paquetes globales) - Language Servers y herramientas JS
      ${BLD}→${CNC} cargo (Rust) - herramientas modernas (bob, tree-sitter, stylua)
      ${BLD}→${CNC} pipx (Python) - formatters, linters, LSPs
      ${BLD}→${CNC} gem (Ruby) - cliente Neovim
      ${BLD}→${CNC} GitHub releases - lazygit, gh, zoxide, tldr, deno, etc.

  ${BLD}Uso:${CNC} ${CYE}dotmarchy --extras${CNC}
  ${BLD}Personaliza:${CNC} ${CBL}${SETUP_CONFIG}${CNC}

"
    fi
    
    # ===== SECTION 3: ENVIRONMENT SETUP (optional) =====
    if [ "$SETUP_ENVIRONMENT" -eq 1 ]; then
        local dir_count=0 repo_count=0 script_count=0 shell_count=0
        
        if [ -f "$SETUP_CONFIG" ]; then
            # shellcheck source=/dev/null
            source "$SETUP_CONFIG" 2>/dev/null || true
            dir_count=${#DIRECTORIES[@]}
            repo_count=${#GIT_REPOS[@]}
            script_count=${#SCRIPTS[@]}
            shell_count=${#SHELL_LINES[@]}
        fi
        
        printf "%b" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}
${BLD}${CBL}  CONFIGURACIÓN DE ENTORNO ${CGR}(--setup-env ACTIVADO ✓)${CNC}
${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}

"
        
        if [ -f "$SETUP_CONFIG" ] && [ $((dir_count + repo_count + script_count + shell_count)) -gt 0 ]; then
            printf "%b" "  ${CGR}✓${CNC} Configuración cargada desde: ${CBL}$SETUP_CONFIG${CNC}
      ${BLD}→${CNC} ${CYE}$dir_count${CNC} directorios a crear
      ${BLD}→${CNC} ${CYE}$repo_count${CNC} repositorios Git a clonar
      ${BLD}→${CNC} ${CYE}$script_count${CNC} scripts a descargar
      ${BLD}→${CNC} ${CYE}$shell_count${CNC} líneas a agregar a la shell config

"
        else
            printf "%b" "  ${CYE}⚠${CNC}  Archivo de configuración no encontrado o vacío
  ${CBL}ℹ${CNC}  Crea el archivo: ${CBL}${SETUP_CONFIG}${CNC}
  ${CBL}ℹ${CNC}  Usa como plantilla: ${CBL}setup.conf.example${CNC}

"
        fi
    else
        printf "%b" "${BLD}${CYE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}
${BLD}${CYE}  CONFIGURACIÓN DE ENTORNO ${CRE}(--setup-env NO activado ✗)${CNC}
${BLD}${CYE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}

  ${CYE}⚠${CNC}  No se configurará el entorno de desarrollo.
  
  ${CGR}💡 Activa --setup-env para:${CNC}
      ${BLD}→${CNC} Crear directorios de trabajo automáticamente
      ${BLD}→${CNC} Clonar repositorios Git necesarios
      ${BLD}→${CNC} Descargar scripts y herramientas
      ${BLD}→${CNC} Configurar tu shell (.zshrc/.bashrc)

  ${BLD}Uso:${CNC} ${CYE}dotmarchy --setup-env${CNC}
  ${BLD}Config:${CNC} ${CBL}${SETUP_CONFIG}${CNC}

"
    fi
    
    # ===== SECTION 4: SAFETY GUARANTEES =====
    printf "%b" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}
${BLD}${CBL}  GARANTÍAS DE SEGURIDAD${CNC}
${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}

  ${CGR}✓${CNC} NO requiere ni permite ejecución como root
  ${CGR}✓${CNC} NO modifica configuraciones críticas del sistema
  ${CGR}✓${CNC} Todos los cambios son reversibles (backups automáticos)
  ${CGR}✓${CNC} Logging completo en: ${CBL}${ERROR_LOG}${CNC}

"
    
    # ===== CONFIRMATION PROMPT =====
    while :; do
        printf " %b" "${BLD}${CGR}¿Deseas continuar con esta configuración?${CNC} [s/N]: "
        read -r yn
        case "$yn" in
            [SsYy])
                break
                ;;
            [Nn] | "")
                printf "\n%b\n" "${BLD}${CYE}Operación cancelada${CNC}"
                exit 0
                ;;
            *)
                printf "\n%b\n" "${BLD}${CRE}Error:${CNC} Digita '${BLD}${CYE}s/y${CNC}' para sí o '${BLD}${CYE}n${CNC}' para no"
                ;;
        esac
    done
}

#######################################
# Farewell message with installation summary
# Displays completion message, statistics, and next steps
#######################################
farewell() {
	local end_time
	local duration
	local minutes
	local seconds

	end_time=$(date +%s)
	duration=$((end_time - INSTALL_START_TIME))
	minutes=$((duration / 60))
	seconds=$((duration % 60))

	clear 2>/dev/null || true

	printf "%b" "${BLD}${CGR}
╔══════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║   ▗▖                              ▗▖                                 ║
║   ▐▌      ▐▌                      ▐▌                                 ║
║ ▟█▟▌ ▟█▙ ▐███ ▐█▙█▖ ▟██▖ █▟█▌ ▟██▖▐▙██▖▝█ █▌                         ║
║▐▛ ▜▌▐▛ ▜▌ ▐▌  ▐▌█▐▌ ▘▄▟▌ █▘  ▐▛  ▘▐▛ ▐▌ █▖█                          ║
║▐▌ ▐▌▐▌ ▐▌ ▐▌  ▐▌█▐▌▗█▀▜▌ █   ▐▌   ▐▌ ▐▌ ▐█▛                          ║
║▝█▄█▌▝█▄█▘ ▐▙▄ ▐▌█▐▌▐▙▄█▌ █   ▝█▄▄▌▐▌ ▐▌  █▌                          ║
║ ▝▀▝▘ ▝▀▘   ▀▀ ▝▘▀▝▘ ▀▀▝▘ ▀    ▝▀▀ ▝▘ ▝▘  █                           ║
║                                         █▌                           ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
${CNC}\n"

	printf "%b" "${BLD}${CBL}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    🎉 INSTALACIÓN COMPLETADA 🎉
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
${CNC}\n"

	printf "\n%b" "${BLD}${CYE}⏱  Tiempo total: ${CGR}${minutes}m ${seconds}s${CNC}\n\n"
	printf "%b" "${BLD}${CBL}═══ RESUMEN DE OPERACIONES ═══${CNC}\n\n"

	printf "%b" "${CGR}✓${CNC} ${BLD}Operaciones completadas:${CNC}\n"
	printf "%b" "  ${CGR}→${CNC} Sistema actualizado con ${BLD}pacman -Syu${CNC}\n"
	printf "%b" "  ${CGR}→${CNC} Repositorio ${BLD}Chaotic-AUR${CNC} configurado\n"
	printf "%b" "  ${CGR}→${CNC} Paquetes ${BLD}CORE${CNC} instalados\n"
	if [ "$INSTALL_EXTRAS" -eq 1 ]; then
		printf "%b" "  ${CGR}→${CNC} Paquetes ${BLD}EXTRAS${CNC} instalados (pacman, AUR, npm, cargo, pipx, gem, GitHub)\n"
		if [ "$PACKAGES_INSTALLED" -gt 0 ]; then
			printf "%b" "  ${CGR}→${CNC} ${BLD}${PACKAGES_INSTALLED}${CNC} paquete(s) nuevo(s) instalado(s)\n"
		fi
		if [ "$PACKAGES_SKIPPED" -gt 0 ]; then
			printf "%b" "  ${CGR}→${CNC} ${BLD}${PACKAGES_SKIPPED}${CNC} paquete(s) ya instalado(s) ${CBL}(omitidos)${CNC}\n"
		fi
		if [ "$PACKAGES_INSTALLED" -eq 0 ] && [ "$PACKAGES_SKIPPED" -eq 0 ]; then
			printf "%b" "  ${CGR}→${CNC} Todos los paquetes extras procesados correctamente\n"
		fi
	fi

	if [ "$SETUP_ENVIRONMENT" -eq 1 ]; then
		printf "%b" "  ${CGR}→${CNC} Entorno de desarrollo ${BLD}configurado${CNC}\n"
	fi

	printf "%b" "  ${CGR}→${CNC} Configuración de ${BLD}dotbare${CNC} completada\n"
	printf "%b" "  ${CGR}→${CNC} Variables de entorno ${BLD}PATH${CNC} configuradas\n"
	printf "%b" "  ${CGR}→${CNC} Dotfiles clonados desde ${BLD}$(basename "$REPO_URL" .git)${CNC}\n"

	echo ""

	if [ -f "$ERROR_LOG" ] && [ -s "$ERROR_LOG" ]; then
		local error_count
		error_count=$(wc -l <"$ERROR_LOG" 2>/dev/null || echo 0)
		if [ "$error_count" -gt 0 ]; then
			printf "%b" "${CYE}⚠${CNC} ${BLD}Advertencias encontradas: ${CYE}$error_count${CNC}\n"
			printf "%b" "  ${CBL}→${CNC} Ver detalles en: ${CBL}$ERROR_LOG${CNC}\n\n"
		fi
	fi

	printf "%b" "${BLD}${CBL}═══ PRÓXIMOS PASOS ═══${CNC}\n\n"
	printf "%b" "${BLD}${CGR}1.${CNC} ${BLD}Aplica la configuración de PATH:${CNC}\n"
	if [ -f "$HOME/.zshrc" ]; then
		printf "%b" "   ${CGR}\$ ${CYE}source ~/.zshrc${CNC}\n"
	elif [ -f "$HOME/.bashrc" ]; then
		printf "%b" "   ${CGR}\$ ${CYE}source ~/.bashrc${CNC}\n"
	fi
	printf "%b" "   ${CBL}(o cierra y vuelve a abrir tu terminal)${CNC}\n\n"

	printf "%b" "${BLD}${CGR}2.${CNC} ${BLD}Verifica que las herramientas estén disponibles:${CNC}\n"
	printf "%b" "   ${CGR}\$ ${CYE}dotmarchy --verify${CNC}\n\n"

	if [ "$INSTALL_EXTRAS" -eq 1 ]; then
		printf "%b" "${BLD}${CGR}3.${CNC} ${BLD}Instala Neovim con bob (si aún no lo tienes):${CNC}\n"
		printf "%b" "   ${CGR}\$ ${CYE}bob install stable${CNC}\n"
		printf "%b" "   ${CGR}\$ ${CYE}bob use stable${CNC}\n\n"
	fi

	printf "%b" "${BLD}${CBL}═══ RECURSOS ÚTILES ═══${CNC}\n\n"
	printf "%b" "  ${CBL}📖${CNC} Documentación: ${CBL}https://github.com/25ASAB015/dotmarchy${CNC}\n"
	printf "%b" "  ${CBL}🔍${CNC} Verificación:  ${CYE}dotmarchy --verify${CNC}\n"
	printf "%b" "  ${CBL}📝${CNC} Log de errores: ${CBL}$ERROR_LOG${CNC}\n"
	printf "%b" "  ${CBL}⚙️${CNC}  Configuración:  ${CBL}~/.config/dotmarchy/setup.conf${CNC}\n\n"

	printf "%b" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}\n"
	printf "%b" "
${BLD}${CGR}    ¡Gracias por usar dotmarchy!${CNC} ${CBL}Tu entorno está listo.${CNC} ${CYE}✨🚀${CNC}
    
    ${CBL}Personaliza tu configuración en ${CYE}~/.config/dotmarchy/setup.conf${CNC}
    ${CBL}y vuelve a ejecutar ${CYE}dotmarchy --extras${CBL} para actualizar.${CNC}
    
${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}
\n"

	sleep 2
}

