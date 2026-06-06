# Flutter Provider Shopping Cart App

A Flutter shopping cart application built using Provider State Management.

## Features

- Provider State Management
- ChangeNotifier
- notifyListeners()
- Consumer Widgets
- MultiProvider
- Add Products
- Remove Products
- Dynamic Cart Count
- Total Price Calculation

## Concepts Used

### Provider

Used for dependency injection and state management.

### ChangeNotifier

Provides reactive state updates.

### Consumer

Rebuilds only necessary widgets.

### context.watch()

Listens to state changes.

### context.read()

Accesses provider without listening.

### MultiProvider

Registers multiple providers in one place.

## Folder Structure

```text
lib/
├── models
├── providers
├── screens
├── widgets
└── main.dart
```

## Package

```yaml
provider: ^6.1.5
```

## Learning Outcomes

- Understand Provider architecture
- Manage app-wide state
- Build scalable Flutter apps
- Separate business logic from UI
- Use multiple providers effectively