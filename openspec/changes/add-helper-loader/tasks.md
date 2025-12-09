## 1. Especificación y diseño
- [x] 1.1 Crear proposal.md para el loader de helpers
- [x] 1.2 Redactar design con API y riesgos
- [ ] 1.3 Definir delta de requisitos (specs/modular-architecture)

## 2. Implementación
- [ ] 2.1 Crear helper `helper/load_helpers.sh` con `load_helpers` y presets
- [ ] 2.2 Migrar scripts core a usar el loader y `SCRIPT_DIR`
- [ ] 2.3 Migrar scripts extras/legacy a usar el loader
- [ ] 2.4 Migrar scripts setup/otros a usar el loader

## 3. Validación
- [ ] 3.1 Validar `openspec validate add-helper-loader --strict`
- [ ] 3.2 Ejecutar comprobaciones básicas (shellcheck si disponible en scripts tocados)

## 4. Cierre
- [ ] 4.1 Actualizar tareas a completado y preparar PR/merge
