# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0] - 2026-04-29

### Agregado

#### Voluntario (Tito)
- Implementación del objeto `tito` con propiedades: peso (70 kg), inercia (490 kg*m/s)
- Atributos para rastrear sustancia en sistema y dosis consumida
- Método `consumir(cantidad, sustancia)`: permite que Tito consuma una bebida (reemplaza la anterior)
- Método `velocidad()`: calcula la velocidad en m/s según la fórmula: rendimiento * inercia / peso
- Getters para `sustanciaEnSistema()` y `dosisDeSustanciaEnSistema()`

#### Bebidas
- **Whisky**: provoca sueño, mareo y jaquecas
  - Rendimiento: 0.9 elevado a la dosis (en cc)
  - Método `rendimiento(cantidad)`: calcula 0.9 ** cantidad
- **Tereré**: diurético, laxante y estimulante
  - Rendimiento: 0.1 por cada cc de dosis, con mínimo de 1
  - Método `rendimiento(cantidad)`: calcula (0.1 * cantidad).max(1)
- **Cianuro**: produce abulia y marasmo
  - Rendimiento: siempre 0
  - Método `rendimiento(cantidad)`: retorna 0

#### Tests
- Suite de tests para bebidas (bebidas.wtest)
  - Verificación de cálculo de rendimiento para cada bebida
  - Tests con diferentes dosis
- Suite de tests para voluntarios (voluntarios.wtest)
  - Tests de consumo de sustancias
  - Verificación de cálculo de velocidad
  - Validación de reemplazo de sustancias

#### Documentación
- README.md con especificación completa del ejercicio
- Explicación del concepto de polimorfismo aplicado
- Pistas sobre operadores de potencia (`**`) y min/max
- LICENSE (ISC)
- CODE_OF_CONDUCT.md
- CONTRIBUTING.md
- CHANGELOG.md

### Configuración
- Proyecto configurado para Wollok
- Estructura de carpetas src/ y tests/
- Configuración de .gitignore para archivos de log
- Imports correctos entre módulos

### Polimorfismo
- **Bebidas**: whisky, terere y cianuro responden polimórficamente a `rendimiento(cantidad)`
- Todas las sustancias aceptan el parámetro `cantidad` aunque algunas no lo utilicen (como cianuro)
- Permite que Tito calcule su velocidad independientemente de la sustancia consumida
- Diseño que separa datos (atributos) de cálculos (métodos de consulta)

[1.0.0]: https://github.com/obj1-unahur-2026s1/bebidas-gpolverini-unahur/releases/tag/v1.0.0
