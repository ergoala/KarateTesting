# KarateTesting

Framework de pruebas de API automatizadas usando **Karate** (con motor Cucumber/BDD integrado), **JUnit 5** y **Maven**.

---

## Tecnologías

| Tecnología | Versión | Rol |
|---|---|---|
| Java | 25 | Lenguaje base |
| Maven | 3.x | Gestión de dependencias y build |
| Karate | 1.4.1 | Framework BDD para pruebas de API |
| JUnit 5 | 5.10.2 | Runner de pruebas |

> Karate incluye el motor de Cucumber internamente — no requiere dependencia adicional de Cucumber.

---

## Patrón de Diseño: Modular por Dominio

El proyecto sigue una arquitectura **modular organizada por dominio de negocio**, aprovechando las capacidades nativas de Karate para llamadas entre features y configuración centralizada.

### Ventajas del patrón
- **Sin clases Java extra** — toda la lógica vive en `.feature` y `.js`
- **Reutilización nativa** — los features comunes se invocan con `call read()`
- **Configuración por ambiente** — `karate-config.js` centraliza URLs y parámetros
- **Datos desacoplados** — archivos JSON/CSV separados del flujo de prueba
- **Escalable** — agregar un dominio nuevo = nueva carpeta, sin tocar lo existente

---

## Estructura del Proyecto

```
KarateTesting/
├── pom.xml
└── src/
    └── test/
        ├── java/
        │   └── runner/
        │       └── TestRunner.java          # JUnit 5 runner
        └── resources/
            ├── karate-config.js             # Configuración por ambiente
            ├── common/
            │   ├── auth.feature             # Autenticación reutilizable
            │   └── helpers.js               # Funciones utilitarias JS
            ├── users/
            │   ├── users.feature            # Tests del dominio Users
            │   └── data/
            │       └── users-data.json      # Datos de prueba
            └── orders/
                ├── orders.feature           # Tests del dominio Orders
                └── data/
                    └── orders-data.json     # Datos de prueba
```

---

## Configuración de Ambientes

El ambiente se controla con la variable `karate.env`. Por defecto usa `dev`.

| Ambiente | URL Base |
|---|---|
| `dev` | `https://jsonplaceholder.typicode.com` |
| `qa` | `https://qa.api.example.com` |
| `prod` | `https://api.example.com` |

---

## Ejecución de Pruebas

### Todos los tests
```bash
mvn test
```

### Por ambiente
```bash
mvn test -Dkarate.env=qa
mvn test -Dkarate.env=prod
```

### Por tag
```bash
# Solo pruebas de humo
mvn test -Dkarate.options="--tags @smoke"

# Solo pruebas de regresión
mvn test -Dkarate.options="--tags @regression"
```

### Por dominio (desde el runner)
Modificar `TestRunner.java` para ejecutar `testUsers()` o `testOrders()` individualmente.

---

## Tags disponibles

| Tag | Descripción |
|---|---|
| `@smoke` | Pruebas críticas de validación rápida |
| `@regression` | Suite completa de regresión |
| `@ignore` | Features utilitarios (no se ejecutan directamente) |

---

## Reportes

Karate genera reportes HTML automáticamente en:
```
target/karate-reports/karate-summary.html
```

---

## Agregar un nuevo dominio

1. Crear carpeta `src/test/resources/<dominio>/`
2. Crear `<dominio>.feature` con los escenarios
3. Crear `data/<dominio>-data.json` con los datos de prueba
4. Agregar el método en `TestRunner.java` si se necesita runner específico

---

## Reutilizar autenticación

```gherkin
Scenario: Endpoint protegido
  * def auth = call read('../common/auth.feature') { username: 'user', password: 'pass' }
  Given url baseUrl + '/secure-endpoint'
  And header Authorization = 'Bearer ' + auth.authToken
  When method GET
  Then status 200
```
