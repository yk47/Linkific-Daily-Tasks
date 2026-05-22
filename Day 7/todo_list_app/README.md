# Todo List App

This project is a small Flutter todo application built to practice local state, `setState`, and interactive UI patterns.

## What the app does

- Add todos with validation
- Mark todos complete or incomplete
- Edit existing todos
- Delete todos with a button or swipe gesture
- Filter the list with search

## State concepts demonstrated

### What is state?

State is data that can change while the app is running and that affects what the UI shows.

In this app, the todo list, completion status, search query, and form text are all pieces of state.

### Local vs app-wide state

- Local state lives inside one screen or widget tree branch.
- App-wide state is shared across many parts of the app.

This project uses local state only. Everything is managed inside one `StatefulWidget`.

### Ephemeral state

Ephemeral state is short-lived UI state such as:

- Text field contents
- Focus
- Search input
- Checkbox values

The todo app keeps these values in the widget state because they do not need persistence beyond the current screen.

### When to use `setState`

Use `setState` when a state change should cause the UI to rebuild.

This app calls `setState` when:

- A todo is added
- A todo is edited
- A todo is toggled complete or incomplete
- A todo is deleted
- The search filter changes

## `StatefulWidget` lifecycle

### `createState`

`createState` creates the mutable state object for the widget.

### `initState`

Use `initState` to set up controllers, listeners, or one-time initialization.

This project keeps the setup simple, but this is the right place to initialize data in a larger app.

### `dispose`

Use `dispose` to clean up controllers and focus nodes.

The todo app disposes its `TextEditingController` and `FocusNode` instances to avoid leaks.

### `didUpdateWidget`

Use `didUpdateWidget` when a parent passes new configuration into an existing state object and that change needs to be reflected locally.

This app does not need it yet, because the screen owns its own todo state.

## Form state management

The app uses:

- `TextEditingController` for the add form
- `FocusNode` to keep the input ready for quick entry
- `Form` and validators to block empty submissions

## Reading list

- Flutter state management docs: https://docs.flutter.dev/data-and-backend/state-mgmt
- `setState` API: https://api.flutter.dev/flutter/widgets/State/setState.html
- `StatefulWidget` API: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html

## Run the app

```bash
flutter run
```

## Run tests

```bash
flutter test
```