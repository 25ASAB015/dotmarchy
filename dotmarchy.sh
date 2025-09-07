#!/bin/bash

# Este script automatiza la instalación de dependencias y la configuración de dotfiles.
# Utiliza dotbare para gestionar los dotfiles de manera segura y eficiente.

#--- Colores para la salida de la consola ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#--- Función para manejar errores ---
handle_error() {
    echo -e "${RED}Error en la línea $1: ${NC}$2"
    exit 1
}

#--- Asegurarse de que el script se ejecute con privilegios de root cuando sea necesario ---
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}Advertencia: Algunas operaciones requieren sudo. Se te pedirá la contraseña.${NC}"
    fi
}

#--- Función para instalar paru si no está presente ---
install_paru() {
    if ! command -v paru &> /dev/null; then
        echo -e "${GREEN}paru no está instalado. Iniciando la instalación...${NC}"
        sudo pacman -S --needed base-devel git
        git clone https://aur.archlinux.org/paru.git /tmp/paru-install
        pushd /tmp/paru-install
        makepkg -si --noconfirm
        popd
        rm -rf /tmp/paru-install
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ paru instalado exitosamente.${NC}"
        else
            handle_error $LINENO "La instalación de paru falló."
        fi
    else
        echo -e "${GREEN}paru ya está instalado. Continuamos.${NC}"
    fi
}

#--- Función para instalar los paquetes necesarios ---
install_packages() {
    echo -e "${GREEN}Verificando e instalando dependencias con paru...${NC}"
    PACKAGES="dotbare tree bat highlight ruby-coderay git-delta diff-so-fancy"
    for package in $PACKAGES; do
        if ! pacman -Q $package &> /dev/null; then
            echo -e "${YELLOW}Instalando $package...${NC}"
            paru -S --noconfirm $package
            if [ $? -ne 0 ]; then
                handle_error $LINENO "La instalación de $package falló."
            fi
        else
            echo -e "${GREEN}✅ $package ya está instalado.${NC}"
        fi
    done
    echo -e "${GREEN}✅ Verificación de paquetes completada.${NC}"
}

#--- Función para configurar dotbare ---
configure_dotbare() {
    echo -e "${BLUE}Configurando dotbare para gestionar dotfiles...${NC}"
    export DOTBARE_DIR="$HOME/.cfg"
    export DOTBARE_TREE="$HOME"

    # Verificar si el repositorio ya ha sido inicializado
    if [ -d "$DOTBARE_DIR" ]; then
        echo -e "${YELLOW}El directorio de dotbare ya existe. Se omitirá la inicialización.${NC}"
    else
        dotbare finit -u https://github.com/25asab015/dotfiles.git
        if [ $? -ne 0 ]; then
            handle_error $LINENO "La inicialización de dotbare falló."
        fi
        echo -e "${GREEN}✅ dotbare inicializado y configurado. ¡Tus dotfiles están listos!${NC}"
    fi
}

#--- Lógica principal del script ---
main() {
    echo -e "${BLUE}--- Iniciando la automatización de dotfiles ---${NC}"
    check_root
    install_paru
    install_packages
    configure_dotbare
    echo -e "${GREEN}--- ✅ Proceso de automatización completado con éxito. ---${NC}"
    echo "¡Tus dotfiles han sido clonados y configurados!"
}

#--- Ejecutar la función principal ---
main
