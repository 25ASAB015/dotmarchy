## Context
- Los scripts cargan helpers uno por uno con bloques repetidos y manejos de error distintos.
- Existen dos convenciones de variable de directorio (`SCRIPT_DIR` y `mydir`), lo que dificulta mantener rutas coherentes.
- Queremos un punto único de carga que valide orden y existencia de helpers, reduciendo divergencias.

## Goals / Non-Goals
- Goals: Centralizar la carga de helpers y el manejo de errores; definir una API mínima y estable; reducir duplicación.
- Non-Goals: Reestructurar la lista de helpers existentes o su contenido; cambiar la semántica de funciones internas.

## Decisions
- Se creará `helper/load_helpers.sh` con una función pública `load_helpers()` que recibe la ruta del directorio `helper` y una lista de helpers a cargar en orden.
- Estandarizaremos el nombre `SCRIPT_DIR` como ruta base de cada script; si un script usa `mydir`, se migrará a `SCRIPT_DIR` antes de invocar el loader.
- El loader validará existencia y hará `source` con manejo uniforme de errores (`echo` a stderr para helpers base y `log_error` cuando ya exista logger).
- Orden recomendado por defecto: `set_variable.sh`, `colors.sh`, `logger.sh`, `prompts.sh`, `checks.sh`, `utils.sh` (permite omitir según necesidad).
- Se permitirán subsets: cada script indicará qué helpers requiere pasando la lista a `load_helpers`.

## Risks / Trade-offs
- Riesgo: scripts que dependan implícitamente de helpers cargados “de más” podrían fallar si no declaran su lista; mitigación: establecer presets (p. ej. `load_helpers "$HELPER_DIR" core`).
- Riesgo: cambio de variable (`mydir` → `SCRIPT_DIR`) en scripts legacy; mitigación: cambio mínimo y revisión manual.
- Trade-off: un paso adicional (source del loader) pero menos duplicación y mayor consistencia.

## Migration Plan
- Crear `helper/load_helpers.sh` con funciones: `load_helpers`, presets (`load_core_helpers`, `load_extras_helpers` si aplica).
- Actualizar scripts para definir `SCRIPT_DIR` y llamar `load_helpers "$SCRIPT_DIR/../.."` (ajustando niveles relativos).
- Mantener compatibilidad: no cambiar comportamiento de helpers internos.
- Verificar al menos un core, un extras y un setup para asegurar rutas correctas.*** End Patch***
