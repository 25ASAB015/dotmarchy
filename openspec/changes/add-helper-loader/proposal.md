## Change: Unificar carga de helpers con un loader único

## Why
- Actualmente cada script carga helpers manualmente con bloques repetidos y variables distintas (`mydir`/`SCRIPT_DIR`), lo que provoca duplicación y riesgo de divergencia.
- Queremos centralizar la lógica de sourcing y validación de helpers en un solo archivo para reducir mantenimiento y asegurar orden/errores consistentes.

## What Changes
- Crear un nuevo helper (`helper/load_helpers.sh`) que encapsule la carga ordenada y validada de los helpers necesarios.
- Actualizar los scripts a usar este loader en lugar de repetir bloques de `source`.
- Alinear el uso de la variable de directorio de script (preferentemente `SCRIPT_DIR`) para calcular la ruta a `helper/`.

## Impact
- Afecta a todos los scripts core/extras/setup que hoy cargan helpers manualmente.
- Afecta al helper system (orden de carga y manejo de errores centralizados).
- Riesgo de ruptura si algún script dependía de rutas/variables previas; se mitigará con una API clara del loader y validación.*** End Patch
