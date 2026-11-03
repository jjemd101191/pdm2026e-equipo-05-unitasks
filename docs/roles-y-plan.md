# Roles y plan de trabajo · TaskU (Equipo 05)

**Curso:** Programación de Dispositivos Móviles · 8.º semestre · Sección E  
**Versión 3 de este documento:** 2026-10-31 (corrige la asignación de roles) · **Estado actualizado:** 2026-11-03  
**Repositorio:** <https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks>

> **Roles definitivos:** Juan José = **Arquitectura** · Marco = **QA** · Pablo = **UX / Investigación** · Demy = **Programador extra**. No hay rol de PM. Yordy Cabrera no forma parte del equipo de PDM.
>
> **Actualización 2026-11-03:** el estado vigente está en la sección 7. La sección 6 se conserva como registro del 1 de noviembre.

---

## 1. Equipo de PDM (4 integrantes)

| Integrante | GitHub | Rol en PDM |
|---|---|---|
| Juan José Martínez Delgado | `@jjemd101191` | **Arquitectura** |
| Marco Pablo Sigüenza Orozco | `@MarcoSiguenza` | **QA** |
| Adrián Pablo Girón Franco («Pablo») | `@PabloFranco777` | **UX / Investigación** |
| Demy Brictany De León Figueroa | `@Demybrictany` | **Programador extra** |

---

## 2. Roles: qué hace y qué no hace cada uno

### 2.1 Juan José — Arquitectura

**Qué hace:**
- Diseña y mantiene el esquema de datos (Drift/SQLite): tablas, claves foráneas, índices y migraciones.
- Mantiene la capa de repositorios y los providers de Riverpod.
- Garantiza la separación **datos → repositorio → estado → pantallas**.
- Documenta las decisiones de arquitectura en `docs/adr/`.
- Explica en la demo cómo viaja un dato desde la pantalla hasta la base y de vuelta.

**Qué NO hace:** no es PM, no maneja el backlog, no crea los issues del equipo, no escribe el changelog, no cierra la versión y no hace QA.

### 2.2 Marco — QA

**Qué hace:**
- Diseña y ejecuta la matriz de pruebas.
- Prueba en dispositivo o emulador y levanta evidencia de fallos.
- Verifica la migración v2 y la persistencia (cerrar y reabrir).
- Vigila el CI y las puertas de calidad (ruleset, aprobaciones y checks obligatorios).
- Compila y verifica el APK/bundle para la demo.
- Hace el cierre de calidad: versión, changelog y etiqueta cuando todo está en verde.

**Qué NO hace:** no diseña el esquema de datos, no implementa repositorios ni providers y no desarrolla funcionalidades.

### 2.3 Pablo — UX / Investigación

**Qué hace:**
- Diseña los flujos y la usabilidad de las pantallas.
- Valida la app con **personas reales** y documenta hallazgos en `docs/usuarios.md`.
- Propone y aplica mejoras de interacción a partir de esa validación.
- Cuida los estados de carga, vacío y error, y la consistencia visual.
- Prepara capturas y evidencia visual.

**Qué NO hace:** no diseña el esquema de datos, no hace QA formal y no implementa la capa de datos.

### 2.4 Demy — Programador extra

**Qué hace:**
- Implementa funcionalidades asignadas y sus pruebas.
- En este sprint: **búsqueda de tareas en Inicio**.
- Apoya la integración de la app y verifica sus propios cambios.
- Apoya en los assets de la web.

**Qué NO hace:** no es QA, no diseña la arquitectura y no se encarga del proceso del equipo.

---

## 3. Plan detallado por integrante

### 3.1 Juan José — Arquitectura

**Objetivo:** cerrar el requisito de «migraciones probadas» y dejar documentado el recorrido de un dato.

- [x] **Implementar una migración v2 real en la app.** Se agregó `courses.archivado`, `schemaVersion = 2` y el paso en `onUpgrade`.
- [x] **Agregar una prueba de migración** en `test/data/migracion_test.dart`: crea una base v1, la abre con v2 y comprueba que los datos sobreviven y que la columna nueva existe.
- [x] **Documentar el flujo de un dato** en `docs/adr/0003-flujo-de-datos-y-migraciones.md`.
- [x] **Resolver o documentar la brecha de Riverpod.** Quedó documentada en la ADR 0003: las pantallas reciben repositorios por constructor y la migración a `ref.watch` es deuda técnica.
- [x] **Escribir la sección técnica del README:** arquitectura por capas, Drift y árbol de archivos correcto.
- [x] **Preparar tu explicación de arquitectura:** ver `docs/explicacion-arquitectura.md`.
- [x] **Revisar al menos 2 PRs** con comentarios concretos: [#15](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/pull/15#issuecomment-6552596209) y [#16](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/pull/16#issuecomment-6552596370).
- [x] **Verificar** `dart format`, `dart analyze`, `flutter test` (58 en verde) y `flutter build web`.
- [x] **Abrir y fusionar el PR de la migración:** [#18](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/pull/18), con el issue [#17](https://github.com/jjemd101191/pdm2026e-equipo-05-unitasks/issues/17), el CI en verde y el squash merge en `main`.

### 3.2 Marco — QA

**Objetivo:** demostrar con evidencia que la app funciona en un dispositivo y que el CI sostiene `main`.

- [ ] **Crear `docs/qa-matriz.md`** con los casos: crear/editar/eliminar tarea, CRUD de cursos, filtros, calendario, estados vacío/error, persistencia al cerrar y reabrir, uso sin conexión, curso con tareas (RESTRICT), Deshacer y búsqueda de tareas. Columnas: caso, pasos, esperado, resultado y evidencia.
- [ ] **Ejecutar la matriz en un emulador o teléfono Android** y registrar el resultado. Incluir cerrar por completo y reabrir para probar la persistencia.
- [ ] **Verificar la migración v2 de Juan:** ejecutar la prueba de migración y probar el camino de actualización desde una base v1 con datos reales.
- [ ] **Verificar el CI:** los 3 jobs (Proyecto final, S15, S16) en verde.
- [ ] **Compilar y verificar el APK** (`flutter build apk --release`) e instalarlo en el teléfono de la demo.
- [ ] **Agregar pruebas de app que falten:** por ejemplo, una prueba de widget para Perfil o Calendario, o para el estado de error con reintento.
- [ ] **Agregar tu usuario a la bitácora:** la entrada del 29 de octubre dice solo «Integrante 1»; debe decir `@MarcoSiguenza`.
- [ ] **Revisar al menos 2 PRs** con comentarios concretos (hoy tienes 0 revisiones hechas).
- [ ] **Preparar tu explicación de QA:** qué probaste, qué falló, qué se corrigió y qué pasa si la base no abre o si no hay red.

### 3.3 Pablo — UX / Investigación

**Objetivo:** demostrar que la app se probó con personas reales y que esa prueba cambió algo.

- [ ] **Crear `docs/usuarios.md`** con **3 personas reales** (no perfiles sintéticos): quién probó, qué intentó, qué falló y qué PR lo arregló. Es requisito explícito de la rúbrica. **Estado: creado con protocolo, 0/3 sesiones.**
- [ ] **Implementar al menos una mejora** que salga de esas pruebas, en su propio PR. Puede ser pequeña: un texto, un botón, un estado vacío o un mensaje de error. **Bloqueado hasta ejecutar las sesiones.**
- [x] **Quitar los datos fijos del Perfil:** hecho en el PR #25; ahora muestra «Perfil local» y un icono neutro.
- [x] **Agregar estado de error con reintento en Perfil:** hecho en el PR #25 con `EstadoVista`.
- [x] **Agregar botón «Reintentar» en la pantalla de arranque fallido:** hecho en el PR #25 (`TaskUStartup`).
- [x] **Revisar que todas las pantallas tengan carga, vacío y error con reintento:** Inicio, Calendario, Cursos y Perfil (PR #25).
- [x] **Tomar las capturas** a 390 × 844 y guardarlas en `docs/capturas/`: cuatro capturas integradas en el PR #25.
- [ ] **Revisar al menos 1 PR** de un compañero: pendiente (0 revisiones publicadas).
- [x] **Preparar tu explicación de UX:** ver `docs/guion-ux-pablo.md`.

### 3.4 Demy — Programador extra

**Objetivo:** sumar una funcionalidad real y probada a la app.

- [ ] **Implementar la búsqueda de tareas en Inicio.** Agregar un campo de búsqueda en `lib/screens/task_list_screen.dart` que filtre por título, descripción o nombre del curso, manteniendo los filtros existentes (Pendientes / Todas / Completadas). Mostrar un estado vacío claro: «No hay tareas con ese texto».
- [ ] **Agregar pruebas de la búsqueda** en `test/task_list_search_test.dart`: que filtre por título, que encuentre por curso, que ignore mayúsculas y que muestre el estado vacío cuando no hay coincidencias.
- [ ] **Probar la búsqueda en la app** (emulador o teléfono) y adjuntar la evidencia en el PR.
- [ ] **Apoyar en los assets de la web:** copiar `sqlite3.wasm` y `drift_worker.js` a `web/` y verificar `flutter run -d chrome`. Si no se va a soportar web, avisar para quitarlo del README.
- [ ] **Agregar una entrada en `docs/bitacora-ia.md`** por el CI, el scaffolding y la búsqueda de tareas (hoy tienes 0 entradas en la bitácora principal).
- [ ] **Revisar al menos 1 PR** de un compañero con comentarios concretos.
- [ ] **Preparar tu explicación individual:** qué hace tu PR de búsqueda, por qué lo hiciste así y qué pasaría si se cambiara.

---

## 3.5 Tareas de proceso (repartidas, sin rol de PM)

Estas tareas no pertenecen a ningún rol técnico. Se reparten así para que no queden sin dueño:

| Tarea | Quién | Cuándo |
|---|---|---|
| Crear un issue por cada tarea de este documento | **Cada integrante crea los issues de sus propias tareas** | Antes del 2 nov |
| Configurar el ruleset: 1 aprobación, Code Owners y checks obligatorios | **Marco** (puerta de calidad) | Antes del 3 nov |
| Actualizar `CODEOWNERS` con los 4 integrantes | **Marco** | Antes del 3 nov |
| README: sección de arquitectura | **Juan** | Antes del 3 nov |
| README: capturas | **Pablo** | Antes del 3 nov |
| README: estado de pruebas y CI | **Marco** | Antes del 3 nov |
| README: cómo correr la app | **Demy** | Antes del 3 nov |
| Versión, changelog y etiqueta | **Marco** (cierre de calidad) | 4 nov |
| Guion de la demo | **Cada uno prepara su parte; Pablo arma el recorrido** | 4 nov |
| Enlace del repositorio en Moodle | **Juan** (trámite del repo) | 4 nov · 23:59 |

---

## 4. Acuerdos del equipo

- [ ] Cada cambio entra por un PR con descripción y un issue enlazado.
- [ ] Cada PR necesita **1 aprobación de otra persona** antes de fusionarse.
- [ ] Nadie fusiona su propio PR sin revisión.
- [ ] Si se usó IA, se registra en `docs/bitacora-ia.md` (qué se pidió, qué se aceptó, qué se rechazó).
- [ ] Todo lo que se va a mostrar debe estar en `main` antes del **4 de noviembre a las 23:59**.
- [ ] El **5 de noviembre** la app debe estar instalada en un teléfono o emulador, con datos de prueba listos.
- [ ] Para la revisión de Git del **16 de noviembre**, cada integrante necesita commits y PRs propios dentro del Sprint 3, con revisiones hechas a compañeros.

---

## 5. Fechas clave

| Fecha | Entregable |
|---|---|
| **2 nov** | Issues creados y plan revisado en equipo. |
| **3 nov** | Migración v2 y README técnico (Juan), matriz QA (Marco), `usuarios.md` (Pablo), búsqueda (Demy). |
| **4 nov · 23:59** | Enlace del repositorio en Moodle y todo lo de la demo fusionado en `main`. |
| **5 nov · 08:15** | Exposición: demo (6 min), preguntas al equipo (5 min) y preguntas individuales (4 min). |
| **16 nov · 23:59** | Corte de Git: lo que esté en `main` cuenta para el examen final. |
| **19 nov** | Examen final: cuestionario y revisión de Git. |

---

## 6. Estado actual (actualizado al 1 de noviembre de 2026)

`main` está en `3962af4`: PR #23 y PR #25 fusionados; CI en verde.

### ✅ Lo que ya está

| Área | Evidencia |
|---|---|
| App funcional | 4 pestañas (Inicio, Calendario, Cursos, Perfil), detalle de tarea y formularios de tarea y curso. |
| Persistencia real | Drift/SQLite con tablas `courses`, `tasks`, `subtasks`, `reminders`, claves foráneas e índices. |
| Migración v2 | `courses.archivado`, `schemaVersion = 2`, prueba v1 → v2 y PR #18 fusionado en `main`. |
| CRUD | Tareas y cursos se pueden crear, ver, editar y eliminar. |
| Capas | Datos → repositorios → providers → pantallas; las pantallas no escriben SQL. |
| Estados de UI | Carga, vacío y error con «Reintentar» en Inicio, Calendario, Cursos y Perfil (PR #25). |
| Perfil local | Identidad ficticia eliminada; arranque con reintento sin borrar datos (PR #25). |
| Decisiones | 3 ADR: 0001 (Hive, reemplazada), 0002 (Drift + Riverpod) y 0003 (flujo de datos y migraciones). |
| Calidad | 84 pruebas en verde; `dart analyze` sin observaciones; CI con 3 jobs en verde en `main`. |
| Capturas | 4 capturas a 390×844 en `docs/capturas/`, enlazadas desde el README (PR #25). |
| Repositorio | Público, con ruleset `main-protegida` (PR, status check y no fast-forward). |
| Bitácora | Entradas de Juan, Pablo y Demy; la de Marco del 29 de octubre sigue sin `@usuario`. |

### ⚠️ Parcial

| Tema | Qué falta |
|---|---|
| Usuarios | `docs/usuarios.md` existe con protocolo, pero tiene **0/3 sesiones reales**. Es requisito y también afecta «Producto y demo». |
| Revisiones | El ruleset exige 0 aprobaciones; los PRs #13, #18, #23 y #25 se fusionaron sin aprobación formal. Juan dejó comentarios en #15, #16, #20 y #22; Marco y Pablo siguen con 0 revisiones y Demy solo comentó en PRs propios. |
| Issues | Solo hay 3 issues cerrados (#17, #19, #21); faltan los de las demás tareas del sprint. |
| Riverpod | Documentado en la ADR 0003. Solo `main.dart` usa `ref.watch`; las pantallas reciben repositorios por constructor (deuda técnica). |

### ❌ Lo que hace falta

| Requisito | Estado |
|---|---|
| `docs/usuarios.md` con 3 personas reales | 0/3. Es el bloqueo principal. |
| Al menos una mejora basada en esas sesiones | Pendiente. |
| Aprobación obligatoria en el ruleset | Configurada en 0 aprobaciones. |
| Pruebas en teléfono Android y APK | Pendiente (Marco). |
| `docs/qa-matriz.md` | No existe. |
| Etiqueta, changelog y APK en el repo | No hay tags, releases ni changelog. |
| Versión actualizada | Sigue en `1.1.0+2`. |

---

## 7. Cierre del 2026-11-03

**Rama de trabajo:** `feat/cierre-sprint3`, creada desde `main` (`fd24dc9`) y **no fusionada**. `main` local ya está actualizado a `fd24dc9`.

### Cambios de esta rama

- `docs/qa-matriz.md` con 22 casos: 19 verificados por pruebas o revisión y 3 pendientes (APK/instalación Android, recorrido manual en navegador y 3 usuarios).
- `test/calendar_screen_test.dart`: calendario, navegación de meses, estado vacío y error con «Reintentar».
- `test/widget_test.dart`: error de Inicio con «Reintentar» y saludo sin identidad ficticia.
- Saludo de Inicio: «Hola» en lugar de «Hola, Diego».
- `README.md`, `CHANGELOG.md` y versión `1.2.0+3` preparados para la demo.
- Se incorporan al repositorio este plan y la matriz de pruebas.

### Verificación

- `flutter test` → **89 pruebas aprobadas**.
- `dart analyze lib test` → **0 observaciones**.
- `dart format --output=none --set-exit-if-changed lib test` → **0 archivos por cambiar**.
- `flutter build web --release` → **correcto**.
- `flutter build apk --release` → **no ejecutable en esta máquina**: falta Android SDK/AVD.
- CI de `main` → verde (último run del 2026-11-02).

### Reasignación por la falta de entrega de Marco

- La matriz QA, la verificación de migración y la de CI las asumió Juan.
- El APK no se pudo compilar aquí; queda para una máquina con Android Studio o un teléfono.
- Marco conserva su parte individual: explicar el PR #15, revisar al menos un PR y estar presente el 5. No se le atribuye trabajo que no hizo.
- La bitácora registra la corrección de la etiqueta «Integrante 1» → `@MarcoSiguenza` en la entrada del 3 de noviembre, sin reescribir la entrada original.

### Pendiente

- Fusionar la rama a `main` (requiere 1 aprobación de un Code Owner y CI verde).
- Compilar e instalar el APK en Android.
- Completar las 3 sesiones de usuarios (Pablo).
- Crear los issues que faltan y cerrar la revisión de Git del 16 de noviembre.
