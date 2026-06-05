# 🌐 REST API Integration App

A Flutter application demonstrating REST API integration, JSON parsing, state management, error handling, loading states, and responsive UI design.

## 📚 Learning Objectives

This project covers:

- Making HTTP requests in Flutter
- Working with REST APIs
- Parsing JSON data
- Creating model classes
- Error handling and exception management
- Managing loading states
- Implementing search functionality
- Pull-to-refresh support
- Building responsive UI components

---

## 🚀 Features

### API Integration
- Fetch data from REST APIs
- Consume multiple endpoints
- Handle query parameters and headers
- Process API responses efficiently

### JSON Handling
- Parse JSON responses
- Create model classes
- Implement `fromJson()` methods
- Handle nested JSON structures

### Error Handling
- Network error handling
- API response validation
- Exception management using try-catch
- User-friendly error messages
- Retry mechanism

### UI Features
- Loading indicators
- Pull-to-refresh functionality
- Search functionality
- Detail screens
- Responsive layouts

---

## 🛠️ Tools & Technologies

### Framework
- Flutter SDK
- Dart

### State Management
- GetX

### Networking
- HTTP Package
- REST APIs

### Development Tools
- Android Studio
- VS Code
- Git & GitHub

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  get: ^4.6.6
  http: ^1.2.1
```

---

## 📁 Project Structure

```txt
lib
├── controllers
│   ├── country_controller.dart
│   ├── news_controller.dart
│   └── weather_controller.dart
│
├── models
│   ├── country.dart
│   ├── news.dart
│   └── weather.dart
│
├── services
│   ├── api_service.dart
│   ├── country_service.dart
│   ├── news_service.dart
│   └── weather_service.dart
│
├── screens
│   ├── home_screen.dart
│   ├── countries_screen.dart
│   ├── country_details_screen.dart
│   ├── news_screen.dart
│   ├── news_details_screen.dart
│   └── weather_screen.dart
│
├── widgets
│   ├── country_card.dart
│   └── news_card.dart
│
└── main.dart
```

---

## 🔄 HTTP Methods Covered

### GET
Fetch data from API endpoints.

```dart
final response = await http.get(Uri.parse(url));
```

### POST
Send data to an API.

```dart
await http.post(
  Uri.parse(url),
  body: jsonEncode(data),
);
```

### PUT/PATCH
Update existing records.

```dart
await http.put(
  Uri.parse(url),
  body: jsonEncode(data),
);
```

### DELETE
Remove records.

```dart
await http.delete(Uri.parse(url));
```

---

## 📊 Loading States

The application handles different states:

- Loading State
- Success State
- Empty State
- Error State

Users receive appropriate visual feedback during network operations.

---

## ⚠️ Error Handling

Implemented error handling for:

- No Internet Connection
- Timeout Exceptions
- Invalid Responses
- API Failures
- Server Errors
- Unexpected Exceptions

---

## 🔍 Search Functionality

Features include:

- Real-time search
- Filtered API data
- Dynamic UI updates
- Optimized user experience

---

## 🔄 Pull to Refresh

Users can refresh API data by pulling down on supported screens.

---

## 🎯 Output / Deliverables

- REST API Integration
- Multiple HTTP Methods
- JSON Parsing
- Model Classes
- Error Handling
- Loading States
- Search Functionality
- Pull-to-Refresh
- Responsive UI
- Clean Architecture
- API Service Layer
- GetX State Management
- README Documentation

---

## 📱 Screens Included

- Home Screen
- Countries Screen
- Country Details Screen
- News Screen
- News Details Screen
- Weather Screen

---

## ▶️ Getting Started

### Clone Repository

```bash
git clone <repository-url>
```

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

---

## 🎓 Concepts Learned

- REST API Integration
- HTTP Requests
- JSON Serialization
- Asynchronous Programming
- State Management
- Error Handling
- Clean Architecture
- Responsive UI Development

---
