# counter_app

An interactive Flutter counter app built to demonstrate local state with `setState`.

## What This App Shows

This project focuses on the core state concepts used in Flutter UI work:

- **State**: data that can change while the app is running and affects what the UI shows.
- **Local state**: state owned by one widget, like the counter value on the home screen.
- **Ephemeral state**: short-lived UI state that does not need to be shared app-wide.
- **`StatefulWidget`**: the widget type used when a screen needs to rebuild as state changes.
- **`setState`**: the method that tells Flutter to rebuild after a local value changes.

## How The Counter Works

The counter screen stores an integer in the widget state object. When a button is pressed, the app calls `setState`, updates the value, and Flutter redraws only the parts of the UI that depend on it.

This is the right approach for:

- Button clicks
- Incrementing and decrementing counters
- Toggle switches and short-lived input state
- Simple form interactions before data is submitted

## State Lifecycle Notes

- `createState` connects the `StatefulWidget` to its mutable state object.
- `initState` is the place for one-time setup.
- `didUpdateWidget` reacts when the parent widget configuration changes.
- `dispose` cleans up controllers, focus nodes, and subscriptions.

## When To Use `setState`

Use `setState` when a widget owns the data and the UI for that same screen needs to change immediately. It is ideal for local, ephemeral state. If the data needs to be shared across many screens or persisted beyond one widget, move to a broader state management approach.

## Related Topics To Practice

- Text input with `TextEditingController`
- Focus management with `FocusNode`
- Form validation and submit handling
- Lists that add, remove, update, filter, and search items
