# KarateTesting

Automated API testing framework using **Karate** (with built-in Cucumber/BDD engine), **JUnit 5**, and **Maven**.

---

## Technologies

| Technology | Version | Role |
|---|---|---|
| Java | 25 | Base language |
| Maven | 3.x | Dependency management and build |
| Karate | 1.4.1 | BDD framework for API testing |
| JUnit 5 | 5.10.2 | Test runner |

> Karate includes the Cucumber engine internally — no additional Cucumber dependency is required.

---

## Design Pattern: Domain-Based Modular

The project follows a **modular architecture organized by business domain**, leveraging Karate's native capabilities for feature-to-feature calls and centralized configuration.

### Pattern advantages
- **No extra Java classes** — all logic lives in `.feature` and `.js` files
- **Native reusability** — common features are invoked with `call read()`
- **Environment-based config** — `karate-config.js` centralizes URLs and parameters
- **Decoupled test data** — JSON/CSV files separated from test flow
- **Scalable** — adding a new domain = new folder, no changes to existing code

---

## Project Structure

```
KarateTesting/
├── pom.xml
└── src/
    └── test/
        ├── java/
        │   └── runner/
        │       └── TestRunner.java          # JUnit 5 runner
        └── resources/
            ├── karate-config.js             # Environment configuration
            ├── common/
            │   ├── auth.feature             # Reusable authentication
            │   └── helpers.js               # Shared JS utility functions
            ├── users/
            │   ├── users.feature            # Users domain tests
            │   └── data/
            │       └── users-data.json      # Test data
            └── orders/
                ├── orders.feature           # Orders domain tests
                └── data/
                    └── orders-data.json     # Test data
```

---

## Environment Configuration

The environment is controlled with the `karate.env` variable. Defaults to `dev`.

| Environment | Base URL |
|---|---|
| `dev` | `https://jsonplaceholder.typicode.com` |
| `qa` | `https://qa.api.example.com` |
| `prod` | `https://api.example.com` |

---

## Running Tests

### All tests
```bash
mvn test
```

### By environment
```bash
mvn test -Dkarate.env=qa
mvn test -Dkarate.env=prod
```

### By tag
```bash
# Smoke tests only
mvn test -Dkarate.options="--tags @smoke"

# Regression tests only
mvn test -Dkarate.options="--tags @regression"
```

### By domain (from the runner)
Modify `TestRunner.java` to run `testUsers()` or `testOrders()` individually.

---

## Available Tags

| Tag | Description |
|---|---|
| `@smoke` | Critical fast-validation tests |
| `@regression` | Full regression suite |
| `@ignore` | Utility features (not executed directly) |

---

## Reports

Karate automatically generates HTML reports at:
```
target/karate-reports/karate-summary.html
```

---

## Adding a New Domain

1. Create folder `src/test/resources/<domain>/`
2. Create `<domain>.feature` with the scenarios
3. Create `data/<domain>-data.json` with the test data
4. Add the method in `TestRunner.java` if a specific runner is needed

---

## Reusing Authentication

```gherkin
Scenario: Protected endpoint
  * def auth = call read('../common/auth.feature') { username: 'user', password: 'pass' }
  Given url baseUrl + '/secure-endpoint'
  And header Authorization = 'Bearer ' + auth.authToken
  When method GET
  Then status 200
```
