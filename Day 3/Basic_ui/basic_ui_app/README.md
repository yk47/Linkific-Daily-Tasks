# Basic UI Lab

A small Flutter learning app built to explain widget trees, stateless widgets, stateful widgets, and basic layout widgets.

## What the app includes

- A home dashboard that shows the widget tree concept
- A stateless widget screen with static UI and reusable chips
- A stateful counter screen that rebuilds with `setState`
- A layout showcase screen using `Stack`, `Row`, `Column`, `Expanded`, `Flexible`, `Spacer`, and `ListView`
- Material Design navigation built with `MaterialApp` and `Scaffold`

## Flutter concepts covered

- Everything in Flutter is a widget.
- The widget tree is a nested hierarchy of widgets.
- `build` describes the current UI.
- `StatelessWidget` is used for UI that does not manage mutable state.
- `StatefulWidget` keeps mutable state inside a separate `State` object.
- `setState` tells Flutter to rebuild the affected part of the UI.
- Hot reload helps you iterate quickly while preserving most app state.

## Screens

1. Home dashboard
2. Stateless widget example
3. Stateful widget example
4. Layout widget example

## Run locally

```bash
flutter pub get
flutter run
```

## Notes

This project is created locally only and is not pushed to GitHub.
