---
description: "Use when editing Flutter/Dart code in this project. Enforces existing architecture with GetX controllers, SQFEntity models, shared UI widgets, notification practices, and strict verification."
name: "Flutter Architecture Guidelines"
applyTo: "lib/**/*.dart, android/**/*.gradle, android/**/*.properties, pubspec.yaml"
---
# Flutter Architecture Guidelines

Follow these rules when changing this codebase.

## Current Architecture (must preserve)
- State management and navigation are based on GetX.
- Business/UI orchestration lives in lib/controllers.
- Data persistence uses SQFEntity models in lib/model.
- Reusable UI components are in lib/widgets.
- Cross-cutting helpers (notifications, snackbars, preferences, encryption) are in lib/tools.

## Layer Responsibilities
- Screens in lib/screens should keep orchestration light.
- Controllers in lib/controllers should own async flows, validation, and interaction with model/tools.
- Model definitions in lib/model/model.dart are source of truth for schema changes.
- Do not edit generated files in lib/model/model.g.dart and lib/model/model.g.view.dart manually.

## Notifications
When changing notifications:
- Verify plugin compatibility with current Flutter/Android toolchain.
- Keep permission requests explicit and user-friendly.
- Validate schedule and timezone behavior end-to-end.
- Ensure safe navigation handling after notification tap.

## Snackbar and Feedback
- Use showSnackbar from lib/tools/tools.dart.
- Use typed feedback consistently:
  - AppSnackbarType.success for successful operations.
  - AppSnackbarType.error for validation/failure outcomes.
  - AppSnackbarType.info for neutral hints.

## Android and Build Rules
When editing Android config or dependencies:
- Keep AGP/Gradle/Kotlin versions compatible with Flutter SDK in use.
- Keep compileSdk and targetSdk aligned with plugin requirements.
- Keep secrets and signing files out of version control.

## Verification Policy (strict)
After code edits:
1. Run flutter analyze.
2. Run flutter test when relevant tests exist.
3. If changes include android/**, pubspec.yaml, or plugin/dependency versions, run flutter build apk --debug.
4. Report verification outcomes and any remaining risks.

## Change Style
- Prefer minimal, safe edits over large rewrites.
- Preserve existing naming and project conventions.
- Avoid introducing new architectural patterns unless required by the task.
- If a migration is needed, explain why and limit scope.
