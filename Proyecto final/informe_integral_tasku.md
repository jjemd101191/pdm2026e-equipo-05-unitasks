# INFORME INTEGRAL DEL PROYECTO: TaskU
## Gestor Académico Inteligente para Estudiantes Universitarios

**Mercado de referencia:** Estudiantes universitarios de Quetzaltenango, Guatemala.

---

## 1. Resumen Ejecutivo

TaskU es una aplicación móvil desarrollada en Flutter diseñada para el seguimiento estructurado de compromisos académicos (tareas, exámenes y proyectos). Nace para resolver la dispersión de información y la falta de recordatorios efectivos en la vida universitaria. El proyecto plantea un modelo de negocio híbrido (Freemium + Publicidad) y se posiciona en el mercado local con una ventaja competitiva basada en la especialización académica y el funcionamiento sin conexión. El presente informe consolida el análisis de mercado, la investigación de usuarios, el modelo de negocio y la planificación operativa del equipo de desarrollo.

---

## 2. Análisis de Mercado y Competencia (Matriz MPC)

Se evaluó la propuesta de TaskU frente a herramientas digitales accesibles para estudiantes en Quetzaltenango (Google Tasks/Calendar, Notion, Trello y Microsoft To Do), utilizando 7 factores críticos de éxito.

- **Puntuación Proyectada:** TaskU obtiene el mayor puntaje (3.50/4.00), seguido de Google Tasks/Calendar y Microsoft To Do (3.20), Notion (2.95) y Trello (2.85).
- **Fortaleza Principal:** Especialización en tareas, exámenes y proyectos universitarios.
- **Ventaja Diferenciadora:** Integración de organización académica, colaboración y acceso sin Internet.
- **Principal Debilidad:** Ausencia de reconocimiento de marca y base de usuarios consolidada.
- **Principal Amenaza:** Competencia de aplicaciones gratuitas con funciones maduras y reconocimiento internacional.

> **Nota Metodológica:** Las calificaciones son estimaciones académicas de funcionalidades previstas, no una validación comercial definitiva ni una medición de cuota de mercado.

---

## 3. Investigación de Usuarios (Sondeo Simulado)

A partir de una encuesta descriptiva con 50 perfiles sintéticos ($n=50$), se identificaron los siguientes hallazgos clave:

- **Hábitos y Necesidades:** El 74% de los estudiantes reporta tener 4 o más tareas pendientes en una semana normal. El 70% experimenta olvidos o entregas tardías al menos ocasionalmente.
- **Preferencias Funcionales:** Las alertas y recordatorios (38%) y el registro rápido (28%) son las características más valoradas, seguidas de la coordinación grupal (20%) y el funcionamiento sin Internet (14%).
- **Interés en TaskU:** El 72% expresa intención positiva de uso (declarada, no adopción comprobada).
- **Riesgo del Modelo Freemium:** Solo el 16% considera suficiente el límite gratuito de 3 tareas activas. El 46% preferiría al menos 5 tareas gratis o no usaría la app con ese límite.
- **Monetización:** El 64% considera realizar algún pago (principalmente menos de US$5), y el 70% tolera publicidad pequeña de forma media o alta, siempre que no interfiera con la experiencia.
- **Colaboración:** El 46% participa frecuentemente en proyectos grupales, lo que valida la inclusión de tableros colaborativos.

---

## 4. Definición Estratégica del Producto

### 4.1 User Persona
**Diego Morales (21 años):** Estudiante universitario de 5.º a 8.º semestre. Su dispositivo principal es el smartphone. Busca una app sencilla para no olvidar entregas, centralizar su información académica y coordinar trabajos en grupo sin la complejidad de herramientas como Notion o ClickUp. Su motivación para pasar a Premium es tener tareas ilimitadas y tableros grupales en temporadas de alta carga.

### 4.2 Modelo de Negocio (Business Model Canvas)
- **Propuesta de Valor:** Gestor académico simple que centraliza tareas, exámenes y proyectos; funciona sin conexión; gratuito para empezar (3 tareas) y Premium para escalar (ilimitado, equipos, nube, sin anuncios, PDF).  
  *Eslogan:* "Menos tiempo organizando, más tiempo estudiando".
- **Segmentos de Clientes:** Estudiantes universitarios con varios cursos; nicho de conversión: estudiantes con alta carga y proyectos grupales.
- **Fuentes de Ingresos:** Publicidad pasiva (AdMob) en la versión gratuita y un pago único por el pase Premium.
- **Canales:** Google Play / App Store, redes sociales, promoción en campus universitarios y boca a boca.

### 4.3 Embudo de Conversión Freemium
1. **Descarga gratuita:** Instala TaskU y registra tareas (con banners AdMob).
2. **Uso habitual:** Hasta 3 tareas activas. Datos locales + respaldo manual.
3. **Barrera Freemium:** Al intentar una 4.ª tarea o un tablero grupal, se muestra el modal de actualización.
4. **Premium:** Pago único (tareas ilimitadas, tableros, nube, sin anuncios, PDF).

---

## 5. Plan Operativo y Asignación de Roles

Para el desarrollo del proyecto, el equipo de Programación de Dispositivos Móviles está formado por **4 integrantes de Ingeniería en Sistemas**. Las responsabilidades se asignan según la evidencia de trabajo en el repositorio (commits, PRs, revisiones y documentación):

- **Arquitectura — Juan José Martínez:** Responsable de la integridad técnica. Define el esquema de datos (Drift/SQLite), las migraciones, los repositorios y los providers; documenta las decisiones en `docs/adr/` y explica el flujo de un dato desde la pantalla hasta la base.
- **QA (Quality Assurance) — Marco Siguenza:** Responsable de la calidad. Diseña y ejecuta la matriz de pruebas, valida la app en dispositivo, verifica la migración v2, vigila el CI y las puertas de calidad, compila y verifica el APK, y hace el cierre de calidad (versión, changelog y etiqueta).
- **UX / Investigación — Pablo Franco:** Responsable de la usabilidad. Diseña los flujos y pantallas, valida con usuarios reales y documenta los hallazgos y correcciones en `docs/usuarios.md`.
- **Programador extra — Demy De León:** Implementa funcionalidades asignadas y sus pruebas. En este sprint: búsqueda de tareas en Inicio, apoyo en los assets de la web y verificación de sus propios cambios.

> **Tareas de proceso:** los issues, el README, el guion de la demo y el enlace en Moodle se reparten en equipo; no corresponden a un rol de PM.

> **Nota sobre el equipo:** Yordy Cabrera no forma parte del equipo de Programación de Dispositivos Móviles (su participación corresponde a Mercadeo y Gerencia), por lo que no se incluye en este equipo ni en estos roles.

El detalle de tareas por integrante y el estado actual del proyecto están en [`docs/roles-y-plan.md`](../docs/roles-y-plan.md).

---

## 6. Conclusiones y Recomendaciones Estratégicas

1. **Validación del MVP:** Implementar primero el registro de tareas en pocos pasos, alertas confiables y consulta sin conexión.
2. **Prueba del Límite Gratuito:** Dado que el límite de 3 tareas genera fricción (solo el 16% lo considera suficiente), se recomienda realizar una prueba A/B o entrevistas de usabilidad comparando 3 frente a 5 tareas activas gratuitas.
3. **Estrategia de Monetización:** Probar un precio accesible para el pase Premium (pago único) y utilizar banners discretos que no interrumpan el registro de pendientes.
4. **Validación Real:** Sustituir las cifras sintéticas del sondeo por una investigación real con estudiantes de distintos semestres de la Universidad Mesoamericana y otras instituciones de Quetzaltenango.
5. **Métricas de Éxito:** Medir usuarios activos, retención, tasa de llegada al límite gratuito y conversión efectiva a Premium antes de asumir la viabilidad comercial definitiva.