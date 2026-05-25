# Flutter Navigation & Routing Demo

A Flutter project demonstrating complete navigation patterns, routing techniques, and UI navigation components in Flutter.

This project covers:

- Basic Navigation (`Navigator.push` & `Navigator.pop`)
- Named Routes
- Data Passing Between Screens
- Navigation Drawer
- Bottom Navigation Bar
- Tab Navigation (`TabBar`)
- Nested Navigation
- Complex Routing Structure

---

## 📌 Learning Objectives

The main purpose of this project is to:

- Master navigation patterns in Flutter
- Implement complex routing
- Handle navigation data
- Create navigation drawers
- Build bottom navigation systems
- Implement tab navigation
- Learn nested navigation architecture

---

## 🚀 Features

### 1. Basic Navigation
Implemented Flutter's fundamental navigation system using:

- `Navigator.push()`
- `Navigator.pop()`
- `MaterialPageRoute`

#### Functionality
- Navigate between multiple screens
- Pass data to another screen
- Return data back to previous screen

Example:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailsScreen(data: "Hello"),
  ),
);
```

---

### 2. Named Routes

Named routes are implemented using `MaterialApp`.

### Route Configuration

```dart
MaterialApp(
  routes: {
    '/home': (context) => HomeScreen(),
    '/profile': (context) => ProfileScreen(),
  },
);
```

### Navigation

```dart
Navigator.pushNamed(context, '/profile');
```

### Passing Arguments

```dart
Navigator.pushNamed(
  context,
  '/profile',
  arguments: userData,
);
```

### Receiving Arguments

```dart
final args =
    ModalRoute.of(context)!.settings.arguments;
```

---

### 3. Navigation Drawer

The app includes a fully functional `Drawer` widget.

#### Features
- Drawer Header
- Navigation Menu Items
- Smooth Navigation
- Route Handling

Example:

```dart
Drawer(
  child: ListView(
    children: [
      DrawerHeader(
        child: Text("Menu"),
      ),
      ListTile(
        title: Text("Home"),
        onTap: () {},
      ),
    ],
  ),
)
```

---

### 4. Bottom Navigation Bar

Implemented using `BottomNavigationBar`.

#### Features
- Multiple Screens
- Persistent State
- Navigation Icons
- Labels

Example:

```dart
BottomNavigationBar(
  currentIndex: selectedIndex,
  onTap: onItemTapped,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
)
```

---

### 5. Tab Navigation

Implemented using:

- `TabBar`
- `TabBarView`
- `TabController`

Example:

```dart
DefaultTabController(
  length: 3,
  child: Scaffold(
    appBar: AppBar(
      bottom: const TabBar(
        tabs: [
          Tab(text: 'Home'),
          Tab(text: 'Explore'),
          Tab(text: 'Profile'),
        ],
      ),
    ),
    body: const TabBarView(
      children: [
        HomeScreen(),
        ExploreScreen(),
        ProfileScreen(),
      ],
    ),
  ),
)
```

---

### 6. Nested Navigation

This project demonstrates nested navigation structures including:

- Multiple Navigators
- Bottom Navigation + Tabs
- Nested Routing
- Independent Navigation Stack

---

## 📂 Project Structure

```txt
lib/
│   app.dart
│   main.dart
│   
├───models
│       navigation_models.dart
│       
├───screens
│       navigation_screens.dart
│       
├───themes
│       app_theme.dart
│       
└───widgets
        navigation_components.dart

```

---

## 🛠️ Technologies Used

- Flutter
- Dart
- Material Design
- Navigator API
- Named Routes
- Stateful Widgets

---

## 📖 Learning Resources

### YouTube Search Terms
- Flutter navigation complete guide
- Flutter routing tutorial
- Named routes Flutter
- Flutter navigation drawer
- Bottom navigation bar Flutter

### Recommended Channels
- Flutter Official
- Reso Coder
- The Flutter Way

### Official Documentation
https://docs.flutter.dev/cookbook/navigation

---

## ▶️ Getting Started

### Prerequisites

Make sure Flutter is installed:

```bash
flutter doctor
```

### Install Dependencies

```bash
flutter pub get
```

### Run App

```bash
flutter run
```

---

## ✅ Deliverables Implemented

- [x] Complete Navigation System
- [x] Named Routes Configured
- [x] Navigation Drawer
- [x] Bottom Navigation Bar
- [x] Tab Navigation
- [x] Data Passing Between Screens
- [x] Nested Navigation

---

## 📷 Screenshots

Add screenshots of your application here.

Example:

```txt
screenshots/
├── home.png
├── drawer.png
├── bottom_navigation.png
└── tabs.png
```

---

## 💡 Best Practices Followed

- Modular Screen Structure
- Clean Navigation Logic
- Reusable Widgets
- Named Routes for Scalability
- Proper State Management
- Organized Folder Structure

---

## 👨‍💻 Author

**Yash Karnik**

 Flutter Developer 

GitHub: https://github.com/yk47
