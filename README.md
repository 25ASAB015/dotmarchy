<div align = "center">

<h1>dotmarchy — Automatizador de dotfiles (Arch/Manjaro)</h1>

<a href="https://github.com/25ASAB015/dotmarchy/blob/main/LICENSE">
<img alt="License" src="https://img.shields.io/github/license/25ASAB015/dotmarchy?style=flat&color=eee&label="> </a>

<a href="https://github.com/25ASAB015/dotmarchy/stargazers">
<img alt="Stars" src="https://img.shields.io/github/stars/25ASAB015/dotmarchy?style=flat&color=98c379&label=Stars"></a>

<a href="https://github.com/25ASAB015/dotmarchy/network/members">
<img alt="Forks" src="https://img.shields.io/github/forks/25ASAB015/dotmarchy?style=flat&color=66a8e0&label=Forks"> </a>

<a href="https://github.com/25ASAB015/dotmarchy/watchers">
<img alt="Watches" src="https://img.shields.io/github/watchers/25ASAB015/dotmarchy?style=flat&color=f5d08b&label=Watches"> </a>

<a href="https://github.com/25ASAB015/dotmarchy/pulse">
<img alt="Last Updated" src="https://img.shields.io/github/last-commit/25ASAB015/dotmarchy?style=flat&color=e06c75&label="> </a>

<br/>
<br/>

<img src="images/screenshot.png" alt="Mis Dotfiles en acción" width="720" />

</div>

### ¿Qué es dotmarchy?

`dotmarchy` es un único script que instala lo necesario y configura tus dotfiles de forma segura y guiada usando `dotbare`. Está pensado para Arch vainilla y Omarchy

- **Seguro**: validaciones antes de actuar (conexión, sistema compatible, no ejecuta como root).
- **Claro**: mensajes explicativos y pasos ordenados.
- **Sencillo**: puedes indicar la URL de tu repositorio de dotfiles como parámetro.

---

### Tabla de contenidos

- [Requisitos](#requisitos)
- [Instalación rápida](#instalación-rápida)
- [Uso básico](#uso-básico)
- [Opciones disponibles](#opciones-disponibles)
- [Paso a paso: ¿Qué hace exactamente?](#qué-hace-exactamente)
- [Qué cambia y qué NO cambia](#qué-cambia-y-qué-no-cambia)
- [Ejemplos prácticos](#ejemplos-prácticos)
- [Variables de entorno útiles](#variables-de-entorno-útiles)
- [Solución de problemas (en lenguaje claro)](#solución-de-problemas-en-lenguaje-claro)
- [FAQ](#faq)
- [Desinstalación (manual)](#desinstalación-manual)
- [Créditos](#créditos)

### Requisitos

- Un sistema basado en Arch (con `pacman`).
- Acceso a `sudo` para instalar paquetes.

### Instalación rápida

```bash
# Descarga el instalador en tu $HOME
curl -LO http://25ASAB015/github/io/dotmarchy/dotmarchy

# Dale permisos de ejecución
chmod +x dotmarchy

# Ejecuta el instalador
./dotmarchy

```

Sugerencia: este script debe ejecutarse desde tu carpeta personal. Si no estás en `~`, ejecuta primero:

```bash
cd ~
```

### Uso básico

```bash
# Ejecutar con el repositorio por defecto incluido en el script
./dotmarchy

# o
bash dotmarchy

# O indicando tu repositorio (HTTPS o SSH)
bash dotmarchy https://github.com/usuario/mis-dotfiles.git
bash dotmarchy git@github.com:usuario/mis-dotfiles.git
```

El script instalará lo necesario y configurará `dotbare` apuntando al repositorio que indiques (o al predeterminado del script si no pasas ninguno).

### Opciones disponibles

- **--repo URL**: URL del repo de dotfiles para `dotbare` (equivalente a pasarlo como argumento posicional).
- **-h, --help**: muestra ayuda y ejemplos de uso.

Notas:
- Si indicas tanto `--repo URL` como un argumento posicional, el último leído tiene prioridad.
- El script puede solicitar tu contraseña de `sudo` para instalar paquetes.

### Ejemplos prácticos

```bash
# Ejecutar con el repo por defecto
bash dotmarchy

# Elegir un repositorio distinto
bash dotmarchy --repo https://github.com/usuario/mis-dotfiles.git
bash dotmarchy git@github.com:usuario/mis-dotfiles.git
```

### ¿Qué hace exactamente?

1. Verifica que estés en Arch/Omarchy (requiere `pacman`).
2. Comprueba que no lo ejecutes como `root` y que estés en tu carpeta personal (`$HOME`).
3. Comprueba conexión a internet.
4. Añade el repositorio `chaotic-aur` si falta (keyring + mirrorlist) y lo habilita en `pacman.conf`.
5. Instala paquetes desde repos oficiales (ej.: `tree`, `bat`, `highlight`, `ruby-coderay`, `git-delta`, `diff-so-fancy`).
6. Instala desde `chaotic-aur` el helper `paru` si falta.
7. Instala desde AUR el paquete `dotbare`.
8. Configura `dotbare` de forma segura e idempotente:
   - Usa `DOTBARE_DIR` (por defecto `~/.cfg`) y `DOTBARE_TREE` (por defecto `~`).
   - Si `~/.cfg` ya existe como repo bare, respeta el remoto actual (no lo sobrescribe automáticamente).
   - Si `~/.cfg` existe pero no es un repo bare, se detiene con un mensaje claro para que decidas cómo proceder.
Tiempo estimado: 2-10 minutos (depende de tu conexión y paquetes ya instalados).

Al finalizar, verás un mensaje de resumen indicando que todo salió bien.

---

### Qué cambia y qué NO cambia

- **Sí cambia**
  - Instala paquetes del sistema (con `pacman`/`paru`).
  - Configura `dotbare` para gestionar tu repo de dotfiles.
  - Añade `chaotic-aur` si no existía.
- **No cambia**
  - No modifica archivos críticos del sistema.
  - No toca tu gestor de ventanas/entorno si no está en tus dotfiles.
  - No reemplaza un remoto existente de `dotbare` si ya apunta a otro repo.

### Variables de entorno útiles

- `DOTBARE_DIR`: ruta al repositorio bare de dotbare (defecto: `~/.cfg`).
- `DOTBARE_TREE`: directorio de trabajo para dotfiles (defecto: `~`).

Ejemplo:

```bash
DOTBARE_DIR="$HOME/.dotfiles.git" DOTBARE_TREE="$HOME" bash dotmarchy --repo https://github.com/usuario/mis-dotfiles.git
```

### Solución de problemas 

- «Este script está pensado para Arch/Manjaro»: tu sistema no tiene `pacman`. dotmarchy necesita Arch/Manjaro.
- Error al instalar paquetes: revisa tu conexión a internet. Si el error es de `chaotic-aur`, vuelve a ejecutar el script más tarde o verifica los mirrors.
- Ya tengo `~/.cfg` con mis dotfiles: dotmarchy respetará tu configuración actual y no la sobrescribirá.
- Permisos de `sudo`: puede pedir tu contraseña para instalar paquetes; es normal.

Si algo falla, revisa el archivo de registro:

```bash
cat "$HOME/.local/share/dotmarchy/install_errors.log"
```

---

### FAQ

---

### Diagrama de flujo (simple)

```text
Inicio
  │
  ├─→ Comprobar sistema (pacman) y no-root
  │      └─ Si falla → salir con mensaje claro
  │
  ├─→ Comprobar conexión a internet
  │      └─ Si falla → salir con mensaje claro
  │
  ├─→ (Opcional) Añadir chaotic-aur (keyring + mirrorlist)
  │
  ├─→ Instalar paquetes de repos oficiales
  │
  ├─→ Instalar paru desde chaotic-aur (si falta)
  │
  ├─→ Instalar dotbare desde AUR (si falta)
  │
  ├─→ Configurar dotbare
  │      ├─ Si ~/.cfg es repo bare
  │      │     ├─ Remoto igual → continuar
  │      │     └─ Remoto distinto → avisar (no cambia automáticamente)
  │      └─ Si ~/.cfg no es repo bare → salir con mensaje claro
  │
  └─→ Mostrar resumen y finalizar
```

**¿Dónde se guardan mis dotfiles?**  
En un repo bare (sin working tree propio) en `~/.cfg`, gestionado por `dotbare`. Tu `$HOME` es el working tree.

**¿Puedo cambiar el repositorio de dotfiles más tarde?**  
Sí. Ejecuta de nuevo el script con otra URL. Si ya tenías un remoto distinto configurado, el script te avisará y no lo cambiará automáticamente.

**¿Necesito usar Git/SSH?**  
No. Puedes usar una URL HTTPS. Si eliges SSH (`git@github.com:...`), necesitarás tener tus llaves configuradas.

**¿Debo ejecutar el script como root?**  
No. El script te lo impedirá. Usa tu usuario normal y proporciona `sudo` cuando se requiera.

### Desinstalación (manual)

dotmarchy instala paquetes del sistema y configura `dotbare`. Para revertir cambios:

```bash
# Quitar dotbare (opcional)
sudo pacman -Rns dotbare

# Respaldar/eliminar el repositorio bare (¡cuidado!)
mv "$HOME/.cfg" "$HOME/.cfg.backup"
```

### Créditos

- Basado en `kazhala/dotbare` para la gestión de dotfiles.
- Basado en el script RiceInstaller de `gh0stzk/dotfiles`

