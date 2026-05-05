# Guía de Testing

## Estrategia de Testing

El proyecto utiliza el framework de testing de Wollok para garantizar la correctitud del código. Los tests están organizados por módulo y cubren tanto casos normales como casos límite.

## Estructura de Tests

```
tests/
├── voluntarios.wtest   # Tests unitarios de Tito
└── bebidas.wtest       # Tests unitarios de bebidas
```

## Ejecutar Tests

### Todos los tests
```bash
# Desde VS Code: Abre la paleta de comandos
# Ctrl+Shift+P (Windows/Linux) o Cmd+Shift+P (Mac)
# Busca: "Wollok: Run All Tests"

# O desde la terminal con Wollok CLI (si está instalado):
wollok test
```

### Test individual
```bash
# Desde VS Code: 
# - Abre el archivo .wtest
# - Click en el ícono "Run Test" que aparece sobre cada test
# - O click derecho en el archivo → "Run Wollok File"

# Desde la terminal:
wollok test tests/voluntarios.wtest
```

## Cobertura de Tests

Los tests cubren:

**Voluntarios:**
- Consumo de diferentes bebidas
- Cálculo de velocidad con diferentes sustancias y dosis
- Verificación de que cada bebida reemplaza a la anterior
- Getters de sustancia y dosis

**Bebidas:**
- Rendimiento de whisky con diferentes dosis
- Rendimiento de tereré con diferentes dosis (incluyendo mínimo de 1)
- Rendimiento de cianuro (siempre 0)
- Casos límite (dosis muy altas, dosis muy bajas)

## Buenas Prácticas de Testing

### 1. Nombres Descriptivos
Los nombres de los tests deben describir claramente qué se está probando:

✓ **Bueno:**
```wollok
test "Tito consume 10cc de whisky y su velocidad es aproximadamente 2.44 m/s" {
    tito.consumir(10, whisky)
    assert.that(tito.velocidad() > 2.4 && tito.velocidad() < 2.5)
}
```

✗ **Malo:**
```wollok
test "test1" {
    assert.that(tito.velocidad() > 2.4)
}
```

### 2. Arrange-Act-Assert (AAA)
Organiza tus tests en tres secciones:

```wollok
test "Tito consume tereré y su velocidad aumenta" {
    // Arrange (preparar)
    const velocidadInicial = tito.velocidad()
    
    // Act (actuar)
    tito.consumir(20, terere)
    const velocidadFinal = tito.velocidad()
    
    // Assert (verificar)
    assert.that(velocidadFinal > velocidadInicial)
}
```

### 3. Tests Independientes
Cada test debe ser independiente y restaurar el estado si es necesario:

```wollok
test "Whisky con dosis 5 tiene rendimiento de 0.59" {
    const rendimiento = whisky.rendimiento(5)
    assert.that(rendimiento > 0.58 && rendimiento < 0.60)
}
```

### 4. Casos Límite
Siempre prueba casos límite:

```wollok
test "Tereré con dosis muy baja (1cc) tiene rendimiento mínimo de 1" {
    assert.equals(1, terere.rendimiento(1))
}

test "Cianuro con cualquier dosis tiene rendimiento 0" {
    assert.equals(0, cianuro.rendimiento(100))
}

test "Whisky con dosis 0 tiene rendimiento 1" {
    assert.equals(1, whisky.rendimiento(0))
}
```

## Debugging de Tests

### Test Falla Inesperadamente

1. **Lee el mensaje de error:**
   ```
   Expected: 2.44
   But was: 2.45
   ```

2. **Verifica el estado:**
   ```wollok
   test "debug ejemplo" {
       tito.consumir(10, whisky)
       console.println("Sustancia: " + tito.sustanciaEnSistema())
       console.println("Dosis: " + tito.dosisDeSustanciaEnSistema())
       console.println("Velocidad: " + tito.velocidad())
       assert.that(tito.velocidad() > 2.4)
   }
   ```

3. **Simplifica el test:**
   - Reduce el test al mínimo necesario
   - Verifica una cosa a la vez

### Test Pasa Pero No Debería

- Verifica que estás usando `assert.equals()` o `assert.that()` correctamente
- Asegúrate de que el test realmente ejecuta la lógica esperada
- Revisa que no haya typos en los nombres de métodos

## Agregar Nuevos Tests

Cuando agregues nueva funcionalidad, sigue estos pasos:

1. **Escribe el test primero (TDD):**
   ```wollok
   test "Nueva bebida tiene el rendimiento esperado" {
       // Test que falla porque la funcionalidad no existe
       assert.equals(1.5, nuevaBebida.rendimiento(10))
   }
   ```

2. **Implementa la funcionalidad mínima:**
   - Haz que el test pase

3. **Refactoriza:**
   - Mejora el código manteniendo los tests en verde

4. **Agrega más tests:**
   - Casos límite
   - Casos de error
   - Diferentes escenarios

## Ejemplos de Tests por Módulo

### Tests de Voluntarios

```wollok
describe "Tito" {
    test "consume whisky y su velocidad disminuye con mayor dosis" {
        tito.consumir(1, whisky)
        const velocidad1 = tito.velocidad()
        
        tito.consumir(10, whisky)
        const velocidad10 = tito.velocidad()
        
        assert.that(velocidad1 > velocidad10)
    }
    
    test "cada bebida reemplaza a la anterior" {
        tito.consumir(10, whisky)
        assert.equals(whisky, tito.sustanciaEnSistema())
        
        tito.consumir(20, terere)
        assert.equals(terere, tito.sustanciaEnSistema())
        assert.equals(20, tito.dosisDeSustanciaEnSistema())
    }
}
```

### Tests de Bebidas

```wollok
describe "Whisky" {
    test "rendimiento con dosis 1 es 0.9" {
        assert.equals(0.9, whisky.rendimiento(1))
    }
    
    test "rendimiento disminuye exponencialmente con la dosis" {
        const rend1 = whisky.rendimiento(1)
        const rend5 = whisky.rendimiento(5)
        const rend10 = whisky.rendimiento(10)
        
        assert.that(rend1 > rend5)
        assert.that(rend5 > rend10)
    }
}

describe "Tereré" {
    test "rendimiento con dosis baja (5cc) es 1 (mínimo)" {
        assert.equals(1, terere.rendimiento(5))
    }
    
    test "rendimiento con dosis alta (20cc) es 2" {
        assert.equals(2, terere.rendimiento(20))
    }
    
    test "nunca rinde menos que 1" {
        assert.equals(1, terere.rendimiento(1))
        assert.equals(1, terere.rendimiento(5))
        assert.equals(1, terere.rendimiento(9))
    }
}

describe "Cianuro" {
    test "rendimiento siempre es 0 independiente de la dosis" {
        assert.equals(0, cianuro.rendimiento(1))
        assert.equals(0, cianuro.rendimiento(10))
        assert.equals(0, cianuro.rendimiento(100))
    }
}
```

## Casos de Prueba Importantes

### Whisky - Efecto Exponencial Decreciente
```wollok
// A mayor dosis, menor rendimiento
tito.consumir(1, whisky)   // Rendimiento: 0.9
tito.consumir(5, whisky)   // Rendimiento: 0.59
tito.consumir(10, whisky)  // Rendimiento: 0.35
```

### Tereré - Mínimo de 1
```wollok
// Dosis bajas tienen rendimiento mínimo de 1
tito.consumir(5, terere)   // Rendimiento: 1 (0.5 → 1)
tito.consumir(10, terere)  // Rendimiento: 1 (1 → 1)
tito.consumir(20, terere)  // Rendimiento: 2 (2 → 2)
```

### Cianuro - Siempre 0
```wollok
// Cualquier dosis produce rendimiento 0
tito.consumir(1, cianuro)   // Rendimiento: 0
tito.consumir(100, cianuro) // Rendimiento: 0
```

### Reemplazo de Bebidas
```wollok
// Cada bebida reemplaza a la anterior
tito.consumir(10, whisky)
// Tito tiene whisky

tito.consumir(20, terere)
// Ahora tiene tereré (reemplazó al whisky)
```

## Verificación de Polimorfismo

Los tests deben verificar que todas las bebidas responden al mismo mensaje:

```wollok
test "todas las bebidas responden a rendimiento(cantidad)" {
    // Todas deben aceptar el mensaje sin error
    whisky.rendimiento(10)
    terere.rendimiento(10)
    cianuro.rendimiento(10)
    
    // Y Tito puede usarlas polimórficamente
    tito.consumir(10, whisky)
    tito.velocidad()
    
    tito.consumir(10, terere)
    tito.velocidad()
    
    tito.consumir(10, cianuro)
    tito.velocidad()
}
```

## Cálculos de Referencia

Para verificar tests, usa estos valores de referencia:

### Whisky
```
0.9 ** 1  = 0.9
0.9 ** 5  ≈ 0.59
0.9 ** 10 ≈ 0.35
```

### Tereré
```
0.1 × 5  = 0.5  → max(1) = 1
0.1 × 10 = 1    → max(1) = 1
0.1 × 20 = 2    → max(1) = 2
```

### Velocidad de Tito
```
Fórmula: rendimiento × 490 / 70 = rendimiento × 7

Whisky 10cc:  0.35 × 7 ≈ 2.45 m/s
Tereré 20cc:  2 × 7 = 14 m/s
Cianuro:      0 × 7 = 0 m/s
```

## Recursos Adicionales

- [Documentación oficial de Wollok Testing](https://www.wollok.org/documentacion/testing/)
- [Guía de TDD](https://www.wollok.org/documentacion/tdd/)
- Ver [architecture.md](architecture.md) para entender la estructura del código
- Ver [setup.md](setup.md) para instrucciones de instalación
