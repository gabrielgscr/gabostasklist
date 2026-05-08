# Gabo's Task List

Español | English

---

## ES

Aplicación móvil para organizar tareas personales, académicas y laborales, con enfoque en reducir la procrastinación mediante recordatorios y seguimiento de pendientes.

### Estado actual del proyecto

Este proyecto está desarrollado con Flutter y Dart, y funciona actualmente con almacenamiento local.

- Gestión de estado y navegación con GetX.
- Persistencia local con SQLite a través de SQFEntity.
- Recordatorios locales con Awesome Notifications.
- Preferencias de usuario con SharedPreferences.
- Soporte de localización en español e inglés.

### Requisitos

- Flutter SDK 3.41.x (o una versión estable compatible).
- Dart SDK 3.11.x (incluido con Flutter 3.41.x).
- Android Studio o Visual Studio Code con extensiones de Flutter/Dart.

Guía oficial de instalación de Flutter:
https://docs.flutter.dev/get-started/install

### Inicio rápido

Desde la carpeta raíz del proyecto:

1. Instalar dependencias:

```bash
flutter pub get
```

2. Ejecutar la app:

```bash
flutter run
```

3. Revisar análisis estático:

```bash
flutter analyze
```

### Comandos de desarrollo

#### Regenerar código de SQFEntity / build_runner

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### Generar splash screen

```bash
dart run flutter_native_splash:create
```

#### Generar iconos de launcher

```bash
flutter pub run flutter_launcher_icons
```

#### Compilar release Android (APK por ABI)

Antes de compilar release, crea `android/key.properties` a partir de `android/key.properties.example` y completa la ruta del keystore, alias y contraseñas.

```bash
flutter build apk --split-per-abi
```

### Dependencias principales

- `get`
- `sqfentity` y `sqfentity_gen`
- `flutter_local_notifications`
- `shared_preferences`
- `encrypt`
- `http`
- `flutter_datetime_picker_plus`
- `intl`
- `flutter_timezone` y `timezone`
- `flutter_localizations` (SDK)

Dependencias de desarrollo:

- `build_runner`
- `build_verify`
- `flutter_lints`
- `flutter_launcher_icons`

### Estructura del proyecto (resumen)

- `lib/main.dart`: punto de entrada, inicialización, rutas base y notificaciones.
- `lib/controllers/`: lógica de presentación con GetX.
- `lib/model/`: definición de entidades y archivos generados por SQFEntity.
- `lib/screens/`: pantallas principales (login, dashboard, tareas, perfil).
- `lib/widgets/`: componentes reutilizables.
- `lib/tools/`: utilidades (preferencias, cifrado, notificaciones, helpers).

### Funcionalidades actuales

- Registro e inicio de sesión local.
- Persistencia de usuarios, tareas y recordatorios en base de datos local.
- Creación de tareas con fecha/hora y configuración de recordatorio.
- Panel principal con secciones de tareas de hoy, atrasadas y próximas.
- Lista de tareas con filtros y cambio de estado de completado.
- Perfil básico y opción de recordar credenciales.

### Roadmap

- Integración con backend para sincronización entre dispositivos.
- Mejora del flujo de autenticación y seguridad de credenciales.
- Cobertura de pruebas automatizadas (unitarias y de widgets).

### Créditos

Algunos recursos gráficos fueron tomados de Freepik.

---

## EN

Mobile app to organize personal, academic, and work tasks, focused on reducing procrastination through reminders and task tracking.

### Current project status

This project is built with Flutter and Dart and currently works with local-first storage.

- State management and navigation with GetX.
- Local persistence using SQLite through SQFEntity.
- Local reminders with Awesome Notifications.
- User preferences with SharedPreferences.
- Localization support for Spanish and English.

### Requirements

- Flutter SDK 3.41.x (or a compatible stable version).
- Dart SDK 3.11.x (included with Flutter 3.41.x).
- Android Studio or Visual Studio Code with Flutter/Dart extensions.

Official Flutter install guide:
https://docs.flutter.dev/get-started/install

### Quick start

From the project root folder:

1. Install dependencies:

```bash
flutter pub get
```

2. Run the app:

```bash
flutter run
```

3. Run static analysis:

```bash
flutter analyze
```

### Development commands

#### Regenerate SQFEntity / build_runner code

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### Generate splash screen

```bash
dart run flutter_native_splash:create
```

#### Generate launcher icons

```bash
flutter pub run flutter_launcher_icons
```

#### Build Android release (APK per ABI)

Before building release, create `android/key.properties` from `android/key.properties.example` and fill in the keystore path, alias, and passwords.

```bash
flutter build apk --split-per-abi
```

### Main dependencies

- `get`
- `sqfentity` and `sqfentity_gen`
- `flutter_local_notifications`
- `shared_preferences`
- `encrypt`
- `http`
- `flutter_datetime_picker_plus`
- `intl`
- `flutter_timezone` and `timezone`
- `flutter_localizations` (SDK)

Development dependencies:

- `build_runner`
- `build_verify`
- `flutter_lints`
- `flutter_launcher_icons`

### Project structure (summary)

- `lib/main.dart`: entry point, initialization, base routing and notifications.
- `lib/controllers/`: presentation logic with GetX.
- `lib/model/`: entity definitions and SQFEntity-generated files.
- `lib/screens/`: main screens (login, dashboard, tasks, profile).
- `lib/widgets/`: reusable UI components.
- `lib/tools/`: utilities (preferences, encryption, notifications, helpers).

### Current features

- Local user registration and sign-in.
- Local database persistence for users, tasks, and reminders.
- Task creation with due date/time and reminder settings.
- Main dashboard with today, overdue, and upcoming sections.
- Task list with filtering and completion status toggling.
- Basic profile view and remember-credentials option.

### Roadmap

- Backend integration for cross-device sync.
- Authentication flow and credential security improvements.
- Automated test coverage (unit and widget tests).

### Credits

Some visual assets were taken from Freepik.