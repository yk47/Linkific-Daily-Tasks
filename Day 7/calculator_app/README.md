# Flutter State Demos — Calculator & Form

This small project demonstrates core Flutter state concepts and how to use `setState` and `StatefulWidget` in practical widgets.

**What you'll find**
- **Calculator**: `lib/calculator.dart` — a simple calculator demonstrating local UI state and `setState`.
- **Form & List demo**: `lib/form_demo.dart` — uses `TextEditingController`, `FocusNode`, validation, and maintains a mutable list (add/update/remove/filter).

**State concepts covered**
- **What is state**: Mutable information that affects UI rendering.
- **Local vs app-wide state**: These demos use local (widget) state via `StatefulWidget` and `setState`. For app-wide state consider providers, bloc, or Riverpod.
- **Ephemeral state**: UI-only state like the calculator's current input or a text field's content.
- **When to use `setState`**: Use for simple, local updates inside a `State` object. Avoid for cross-app state.

**Mastering `StatefulWidget`**
- `createState()` returns the `State` object.
- Lifecycle: `initState()`, `didUpdateWidget()`, `dispose()` — `form_demo.dart` calls `dispose()` to clean up controllers.

**Using `setState`**
- Wrap only the minimal changes in `setState` to keep rebuilds efficient.
- The calculator updates its display using `setState` on button presses.

**Run**
```
flutter pub get
flutter run
```

**Further learning**
- Official docs: https://docs.flutter.dev/data-and-backend/state-mgmt
- YouTube search terms (recommended): "Flutter state management explained", "Flutter setState tutorial", "StatefulWidget complete guide"
- Recommended channels: Reso Coder, The Flutter Way, Vandad Nahavandipoor
# calculator_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
