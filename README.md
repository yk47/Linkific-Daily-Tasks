# 🚀 Dart Programming Language — Complete Learning Guide

![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Null Safety](https://img.shields.io/badge/Null%20Safety-Enabled-5C2D91?style=for-the-badge)
![Flutter Ready](https://img.shields.io/badge/Flutter-Compatible-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

A **complete learning reference and hands-on guide to the Dart Programming Language**, designed for beginners to intermediate developers. This repository provides structured explanations, practical examples, object-oriented programming concepts, null safety, asynchronous programming, and real-world practice projects.

Whether you're preparing for **Flutter development**, strengthening your **Dart fundamentals**, or revising concepts quickly, this guide covers everything you need in one place.

---

## 📚 Topics Covered

### 🟢 Dart Fundamentals
- Variables & Data Types
- Operators
- Type Inference
- String Interpolation
- Type Casting & Parsing

### 🟡 Control Flow
- `if`, `else if`, `else`
- `switch` statements
- Pattern Matching (Dart 3)
- Loops (`for`, `while`, `do-while`)
- `break` & `continue`

### 🔵 Functions
- Function Syntax
- Arrow Functions
- Named Parameters
- Optional Parameters
- Higher Order Functions
- Closures
- Recursive Functions

### 🟣 Collections
- Lists
- Sets
- Maps
- Functional Operations (`map`, `where`, `reduce`, `fold`)
- Spread Operators
- Collection If / For

### 🟠 Object-Oriented Programming (OOP)
- Classes & Objects
- Constructors
- Named Constructors
- Inheritance
- Method Overriding
- Abstract Classes
- Interfaces
- Mixins
- Factory Constructors

### 🔴 Null Safety
- Nullable vs Non-Nullable Types
- Null-aware Operators
- Type Promotion
- `late` Keyword
- Safe Null Handling

### ⚡ Async Programming
- Futures
- `async` / `await`
- Error Handling
- Streams
- Stream Controllers
- Concurrent Execution

### 🧠 Practice Programs
- Calculator Class
- Todo List Application
- Async API Simulation

---

## 📁 Repository Structure

```bash
dart-programming-guide/
│── README.md
│── Dart_Programming_Complete_Guide.pdf
│── examples/
│   ├── variables.dart
│   ├── functions.dart
│   ├── oop.dart
│   ├── null_safety.dart
│   ├── async_programming.dart
│   └── collections.dart
│── practice_programs/
│   ├── calculator.dart
│   ├── todo_list.dart
│   └── api_simulation.dart
```

---

## 🎯 Who Is This For?

✅ Beginners learning Dart from scratch  
✅ Flutter developers strengthening fundamentals  
✅ Students preparing for interviews  
✅ Developers revising Dart concepts quickly  
✅ Anyone transitioning from Java, JavaScript, Kotlin, or Python to Dart

---

## 🛠 Prerequisites

Before getting started, make sure you have:

- Dart SDK installed
- VS Code or Android Studio
- Basic programming knowledge (recommended but not required)

### Install Dart

Visit the official website:

https://dart.dev/get-dart

Verify installation:

```bash
dart --version
```

---

## ▶️ Running Dart Programs

Clone the repository:

```bash
git clone https://github.com/your-username/dart-programming-guide.git
```

Move into the project folder:

```bash
cd dart-programming-guide
```

Run any Dart file:

```bash
dart run examples/functions.dart
```

Example:

```dart
void main() {
  print("Hello Dart!");
}
```

Output:

```bash
Hello Dart!
```

---

## 💡 Learning Roadmap

Follow this order for best results:

```text
1. Variables & Data Types
2. Operators
3. Control Flow
4. Functions
5. Collections
6. OOP
7. Null Safety
8. Async Programming
9. Practice Projects
```

---

## 🔥 Example Code

### Variables

```dart
var name = "Yash";
final city = "Mumbai";
const gravity = 9.8;

print(name);
```

### Functions

```dart
int add(int a, int b) {
  return a + b;
}

void main() {
  print(add(10, 20));
}
```

### Async/Await

```dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return "Data Loaded";
}

void main() async {
  print(await fetchData());
}
```

---

## 📖 Learning Outcomes

After completing this guide, you will:

✔ Write clean and efficient Dart code  
✔ Understand Dart OOP deeply  
✔ Handle asynchronous programming confidently  
✔ Master Dart collections and null safety  
✔ Build a strong foundation for Flutter development

---

## 🤝 Contributing

Contributions are welcome!

If you'd like to improve examples, fix mistakes, or add advanced Dart topics:

1. Fork the repository
2. Create a new branch

```bash
git checkout -b feature-name
```

3. Commit your changes

```bash
git commit -m "Added new Dart examples"
```

4. Push to branch

```bash
git push origin feature-name
```

5. Open a Pull Request 🚀

---

## ⭐ Support

If you found this repository useful:

🌟 Star the repository  
🍴 Fork it  
📢 Share it with other developers

---

## 👨‍💻 Author

**Yash Karnik**  
Cybersecurity Enthusiast | Flutter Developer | Software Engineer

GitHub: https://github.com/yk47

---

## 📜 License

This project is licensed under the **MIT License** — feel free to use and modify it for learning purposes.

---

### 🚀 Happy Coding with Dart!
**Learn • Build • Grow**
