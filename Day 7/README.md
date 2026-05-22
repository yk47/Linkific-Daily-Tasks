# Flutter State Management Demos

A collection of small Flutter applications built to demonstrate **core Flutter state concepts**, including **StatefulWidget**, **setState**, form handling, local state management, and interactive UI patterns.

These mini-projects are designed for learning and practicing Flutter fundamentals through real examples.

---

## Projects Included

### 1. Calculator Demo
**File:** `lib/calculator.dart`

A simple calculator app demonstrating:

- Local UI state
- `setState()` for rebuilding UI
- Stateful interactions
- Button-based input handling

**Concepts covered**
- Mutable UI state
- Updating the display dynamically
- Efficient widget rebuilding

---

### 2. Form & List Demo
**File:** `lib/form_demo.dart`

A form-based app demonstrating:

- `TextEditingController`
- `FocusNode`
- Form validation
- Mutable list management
- Add / update / remove / filter functionality

**Concepts covered**
- Form state
- Input handling
- Validation logic
- Focus management
- Dynamic list updates

---

### 3. Counter App

An interactive Flutter counter app built to practice **local state with `setState()`**.

**Features**
- Increment counter
- Decrement counter
- UI updates instantly

**Concepts covered**
- Local state
- Ephemeral UI state
- `StatefulWidget`
- `setState()` rebuilding

---

### 4. Quiz App

An interactive quiz application used to practice **local state, user interaction, and UI rebuilding**.

**Features**
- Question navigation
- Answer selection
- Score tracking
- Restart quiz
- Finished state handling

**State used**
- Current question index
- Selected answer
- Quiz score
- Completion state

---

### 5. Todo List App

A small Flutter todo app built to practice **interactive UI and state updates**.

**Features**
- Add todos with validation
- Edit todos
- Delete todos
- Swipe-to-delete
- Mark complete/incomplete
- Search and filter todos

**Concepts covered**
- Form handling
- Search state
- List updates
- Dynamic rebuilding
- Controller disposal

---

# Core Flutter State Concepts Covered

## What is State?

**State** is mutable data that can change while the app is running and affects what appears on screen.

Examples from these projects:

- Calculator input
- Counter value
- Quiz score
- Selected answers
- Todo items
- Search text
- Form input fields

---

## Local vs App-Wide State

### Local State
State owned by a single widget or screen.

Used throughout these demos because the data only belongs to one UI section.

Examples:
- Counter number
- Calculator display
- Selected quiz answer
- Todo search query

### App-Wide State
Shared data across multiple screens.

For larger apps, consider:

- **Provider**
- **BLoC**
- **Riverpod**
- **Cubit**

---

## Ephemeral State

Ephemeral state is **short-lived UI state** that only matters temporarily.

Examples:

- Text field content
- Button toggles
- Search query
- Current question selection
- Calculator input
- Checkbox state

These demos mainly focus on **ephemeral/local state**.

---

## Understanding `StatefulWidget`

Use a `StatefulWidget` when the UI needs to update dynamically.

### Lifecycle Overview

### `createState()`
Creates the mutable state object.

```dart
@override
State<MyWidget> createState() => _MyWidgetState();
```

### `initState()`
Used for one-time setup.

Common use cases:

- Initialize controllers
- Add listeners
- Load initial data

```dart
@override
void initState() {
  super.initState();
}
```

### `didUpdateWidget()`
Called when parent widget configuration changes.

Useful when state must react to updated inputs.

```dart
@override
void didUpdateWidget(covariant MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
}
```

### `dispose()`
Used to clean up resources.

Important for:

- `TextEditingController`
- `FocusNode`
- Streams
- Animation controllers

```dart
@override
void dispose() {
  controller.dispose();
  focusNode.dispose();
  super.dispose();
}
```

---

## Understanding `setState()`

`setState()` tells Flutter:

> "Something changed — rebuild the widget."

### Example

```dart
setState(() {
  counter++;
});
```

### When to Use `setState()`

Use it for **simple local UI updates**, such as:

- Counter changes
- Calculator button presses
- Quiz answer selection
- Form input interactions
- Todo add/edit/delete
- Search filtering

### Best Practice

Only wrap the **minimal state update** inside `setState()` to keep rebuilds efficient.

Good example:

```dart
setState(() {
  todos.add(todo);
});
```

Avoid putting unnecessary logic inside `setState()`.

---

# Form State Management

Several demos include form-related state handling.

### `TextEditingController`
Used to read and manage text input.

```dart
final controller = TextEditingController();
```

### `FocusNode`
Controls keyboard focus and improves UX.

```dart
final focusNode = FocusNode();
```

### Validation
Used to prevent invalid submissions.

Example:
- Blocking empty todo input
- Validating form fields

---


# Running the Project

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Run tests:

```bash
flutter test
```

---

# Suggested Learning Topics

To continue learning Flutter state management, practice:

- Flutter `setState()` tutorial
- StatefulWidget deep dive
- Flutter forms and validation
- `TextEditingController`
- `FocusNode`
- Local vs global state
- Provider
- Riverpod
- BLoC architecture

---

# Recommended Resources

### Flutter Documentation
- https://docs.flutter.dev/data-and-backend/state-mgmt

### API References
- https://api.flutter.dev/flutter/widgets/State/setState.html
- https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html

### Flutter Learning
- https://docs.flutter.dev

### Recommended YouTube Channels
- Reso Coder
- The Flutter Way
- Vandad Nahavandipoor

### Recommended Search Terms
- *Flutter state management explained*
- *Flutter setState tutorial*
- *StatefulWidget complete guide*
- *Flutter interactive UI*
- *Flutter form state management*

---

## Getting Started

If this is your first Flutter project:

A few helpful resources:

- Learn Flutter
- Write your first Flutter app
- Flutter learning resources

For additional help, check the official Flutter documentation for tutorials, samples, and complete API references.

---

## Goal of This Repository

The goal of this repository is to provide **hands-on practice for Flutter state management fundamentals** using small, focused applications that demonstrate real-world UI interactions and local state handling.
