# Guía Maestra para Continuar en Casa: Medicent V3 Mobile (Flutter + TDD)

**Fecha:** 3 de noviembre de 2026  
**Rama de trabajo:** `develop`  
**Repositorio GitHub:** `https://github.com/cristianbg2007/AppMovil_Medicent_v3.git`  
**Modalidad:** Desarrollo Individual guiado por pruebas (TDD: Red -> Green -> Refactor)

---

## 1. Estado Actual del Proyecto (Dónde quedamos hoy)

Hoy dejamos completados y funcionando dos componentes clave:
1. **Núcleo de Red (`lib/core/api/`):**
   - `api_endpoints.dart`: Centraliza las URLs de Flask (funciona en Web Chrome, emulador Android `10.0.2.2` y Windows).
   - `api_client.dart`: Cliente HTTP con inyección automática de `Content-Type: application/json` y tokens `Authorization: Bearer <token>`.
   - Pruebas unitarias pasando: `test/core/api/api_endpoints_test.dart` y `test/core/api/api_client_test.dart`.
2. **Inicio del Módulo de Autenticación (`lib/features/auth/`):**
   - `lib/features/auth/models/usuario_model.dart`: Modelo completo con `fromJson` y `toJson` para mapear los usuarios (`id`, `nombre`, `correo`, `rol`, `token`).
   - Prueba unitaria lista en: `test/features/auth/models/usuario_model_test.dart`.

---

## 2. Preparación al Abrir el Proyecto en Casa

Cada vez que vayas a trabajar en casa, sigue estos pasos previos:

1. **Abrir la terminal en la carpeta móvil:**
   ```bash
   cd C:\Users\Aprendiz\.gemini\antigravity-ide\scratch\mobile_medicent_v3
   ```
2. **Verificar que estés en la rama `develop`:**
   ```bash
   git branch
   # Debe mostrar * develop
   ```
3. **Traer cambios por si acaso:**
   ```bash
   git pull origin develop
   ```
4. **Verificar que todas las pruebas pasen:**
   ```bash
   flutter test
   ```
5. **(Opcional) Si quieres probar contra el Backend Flask:**
   - Abre otra terminal y ve a `Backend_Medicent_v3`:
     ```bash
     cd C:\Users\Aprendiz\.gemini\antigravity-ide\scratch\Backend_Medicent_v3
     py run.py
     ```

---

## 3. Plan Paso a Paso para la Siguiente Sesión (Día 2: Continuación de Auth)

El siguiente paso es construir el **Servicio de Autenticación** (`auth_service.dart`) bajo TDD. Este servicio se encargará de llamar a Flask para hacer Login y Guardar el Token en almacenamiento seguro.

### Paso 1: 🔴 Escribir la prueba del servicio
1. Crear el archivo: `test/features/auth/services/auth_service_test.dart`
2. Esta prueba debe comprobar:
   - Que al llamar a `login(correo, password)` retorne un `UsuarioModel` si las credenciales son válidas.
   - Que guarde el token JWT en `flutter_secure_storage`.
   - Que retorne `null` si el backend devuelve un error 401.

### Paso 2: 🟢 Escribir el código del servicio
1. Crear el archivo: `lib/features/auth/services/auth_service.dart`
2. Implementar los métodos:
   - `Future<UsuarioModel?> login(String correo, String contrasena)`
   - `Future<bool> registro(String nombre, String correo, String contrasena, String rol)`
   - `Future<void> logout()`
3. Ejecutar la prueba:
   ```bash
   flutter test test/features/auth/services/auth_service_test.dart
   ```

### Paso 3: Crear la Pantalla de Login (`login_screen.dart`)
1. Crear: `lib/features/auth/screens/login_screen.dart`
2. Formulario visual con:
   - Campo de texto: Correo electrónico
   - Campo de texto: Contraseña
   - Botón: "Iniciar Sesión" (llama a `AuthService.login`)
   - Navegación al Dashboard (`features/home/screens/home_screen.dart`).

---

## 4. Comandos Frecuentes y Útiles

| Tarea | Comando |
| :--- | :--- |
| Correr todas las pruebas | `flutter test` |
| Correr una prueba específica | `flutter test test/features/auth/models/usuario_model_test.dart` |
| Probar la app en Chrome | `flutter run -d chrome` |
| Guardar cambios en Git | `git add .` <br> `git commit -m "mensaje"` <br> `git push origin develop` |

---

## 5. Regla Fundamental de TDD en este Proyecto
- **1°** Escribes la prueba en `test/`.
- **2°** Verificas que falle en rojo (`flutter test ...`).
- **3°** Escribes el archivo correspondiente en `lib/`.
- **4°** Verificas que pase en verde.

