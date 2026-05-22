# quiz_app

An interactive Flutter quiz app built to practice local state, `setState`, and user input handling.

## What this app demonstrates

### State in Flutter

State is data that can change while the app is running and affect what appears on screen.

The quiz app uses local state for:

- current question index
- selected answer
- score
- finished/restart state

### Local vs app-wide state

This project uses local state because the quiz data only needs to live inside one screen. App-wide state would be better for shared data used across many screens.

### Ephemeral state

Ephemeral state is short-lived UI state such as:

- which answer is selected
- whether feedback is visible
- whether the quiz is complete

### Why `setState` is used

`setState` tells Flutter to rebuild the widget after the quiz state changes. In this app it updates the UI when the user:

- taps an answer
- advances to the next question
- restarts the quiz

## StatefulWidget lifecycle

This app is centered on a `StatefulWidget` so the screen can change over time.

- `createState` creates the mutable state object
- `initState` is where one-time setup would go if needed
- `dispose` is where controllers or listeners should be cleaned up
- `didUpdateWidget` is useful when the parent configuration changes and the state needs to react

## Forms and interaction

The quiz itself is a simple interaction demo, but the same pattern applies to form state:

- `TextEditingController` for text input
- `FocusNode` for focus management
- validation state for form errors
- submit handling for send actions

## Running the app

```bash
flutter pub get
flutter run
```

## Suggested study topics

- Flutter state management explained
- Flutter `setState` tutorial
- StatefulWidget complete guide
- Flutter interactive UI
- Flutter form state management
