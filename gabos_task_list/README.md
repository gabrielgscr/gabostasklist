# gabos_task_list

Este proyecto contiene los fuentes para la aplicación Gabo's Task List, que te ayudará a disminuir a procrastinación y a mejorar
el acomodo que realizas de las tareas laborales, académicas, personales, etcétera.

## Por donde iniciar

Este proyecto está desarrollado en Flutter y Dart. Se planea para el futuro usar otros lenguajes como Python, C# y/o Java para crear
un backend que brindará servicios a los usuarios.

Para instalar Flutter:
https://docs.flutter.dev/get-started/install

A continuación se lista las tareas necesarias para configurar y ejecutar el proyecto:
1. Ejecuta el comando "flutter pub get" en la carpeta base del proyecto


## Paquetes requeridos
Dependencias
1. GetX: https://pub.dev/packages/get
2. SqfEntity: https://pub.dev/packages/sqfentity
3. shared_preferences
4. http
5. encrypt
6. flutter_datetime_picker_plus
7. intl
Dependencias de desarrollo
1. build_runner
2. build_verify
3. flutter_lints

## Generación de modelo de SQFEntity
flutter pub run build_runner build --delete-conflicting-outputs
dart run build_runner build --delete-conflicting-outputs
