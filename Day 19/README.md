# 🛍️ Flutter Provider Shopping Cart

A dark-themed e-commerce shopping cart app built with Flutter, demonstrating the **Provider** state management pattern end-to-end. Covers `ChangeNotifier`, `MultiProvider`, `Consumer`, `context.watch()`, and `context.read()` in a real-world scenario.

---

## 📱 Features

- **Product catalogue** — 6-item tech grid with emoji icons and category badges
- **Add to cart** — card highlights gold when a product is in the cart
- **Quantity control** — inline `+` / `−` stepper on each product card
- **Reactive cart badge** — live item count updates in the app bar
- **Cart screen** — full item list with per-item subtotals and a grand total
- **Clear cart** — bulk-remove all items in one tap
- **Haptic feedback** — device vibration on cart interactions
- **Staggered animations** — cards fade and slide in on load
- **Dark luxury theme** — warm gold accent on a near-black background (Material 3)

---

## 🧠 Provider Concepts Demonstrated

| Concept | Where Used |
|---|---|
| `ChangeNotifier` | `CartProvider`, `ProductProvider` |
| `MultiProvider` | `main.dart` — registers both providers at root |
| `ChangeNotifierProvider` | Inside `MultiProvider.providers` |
| `Consumer<T>` | Cart badge in `HomeScreen` app bar |
| `context.watch<T>()` | `HomeScreen` body, `CartScreen` |
| `context.read<T>()` | All mutation callbacks (`onTap` handlers) |
| Derived state (getters) | `totalItems`, `totalPrice`, `isInCart()`, `quantityOf()` |
| `notifyListeners()` | After every mutation in `CartProvider` |
| Local `setState` | `AnimationController` in `AnimatedProductCard` |

---

## 📁 Project Structure

```
lib/
├── main.dart                  # App root — MultiProvider setup
├── models/
│   └── product.dart           # Pure Dart data class
├── providers/
│   ├── cart_provider.dart     # Cart state & business logic
│   └── product_provider.dart  # Product catalogue
├── screens/
│   ├── home_screen.dart       # Product grid
│   └── cart_screen.dart       # Cart & checkout
├── widgets/
│   ├── product_card.dart      # Animated card + quantity control
│   └── product_tile.dart      # Simple list tile alternative
└── theme/
    └── app_theme.dart         # Centralised design tokens
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.11.5`
- Dart SDK `>=3.11.5`

### Install & Run

```bash
# Clone the repo
git clone <your-repo-url>
cd provider_state_manage_app

# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5       # State management

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0  # Lint rules
```

Only **one** external production dependency beyond the Flutter SDK — `provider` is a lightweight `InheritedWidget` wrapper with no transitive dependencies.

---

## 🏗️ Architecture

State flows strictly downward. No layer imports from a layer above it:

```
main.dart
  └── MultiProvider
        ├── ProductProvider  (ChangeNotifier)
        └── CartProvider     (ChangeNotifier)
              └── MaterialApp → HomeScreen → CartScreen
```

### ProductProvider

Read-only catalogue provider. Exposes `List<Product>` via a getter. `notifyListeners()` is never called because the catalogue is static — it acts as a dependency-injection container.

### CartProvider

Reactive state using two parallel `Map`s keyed by product ID for O(1) lookup:

```dart
final Map<String, Product> _cartMap    = {};  // id → Product
final Map<String, int>     _quantities = {};  // id → quantity
```

**Methods:** `addToCart()` · `removeOneFromCart()` · `removeFromCart()` · `clearCart()`  
**Getters:** `cartItems` · `totalItems` · `totalPrice` · `isInCart()` · `quantityOf()`

Every mutation ends with `notifyListeners()`.

---

## 🎨 Theme

All design tokens live in `AppTheme`:

| Token | Value | Usage |
|---|---|---|
| `bg` | `#0F0F0F` | Scaffold background |
| `surface` | `#1A1A1A` | Card and app bar surfaces |
| `accent` | `#E8C97E` | Warm gold — CTAs, prices, active states |
| `textPrimary` | `#F5F0E8` | Main readable text |
| `textSecondary` | `#8A8880` | Captions and labels |

---

## 🧪 Running Tests

```bash
flutter test
```

> **Note:** The default `widget_test.dart` is boilerplate scaffolding and is not valid for this app. Replace it with `CartProvider` unit tests and widget tests for meaningful coverage.

**Suggested test cases:**
- `addToCart()` increases `totalItems`
- Adding the same product twice increments quantity, not item count
- `removeOneFromCart()` with `qty == 1` removes the product entirely
- `clearCart()` resets both `totalItems` and `totalPrice` to zero
- `HomeScreen` renders all 6 product cards

---

## 📚 Key Learning Points

**Use `context.watch<T>()`** in `build()` when the whole widget depends on provider state — it subscribes and rebuilds on every `notifyListeners()`.

**Use `Consumer<T>`** when only *part* of a widget subtree needs to react — keeps rebuilds surgical and efficient.

**Use `context.read<T>()`** inside event callbacks (`onTap`, `onPressed`) — gets the provider without subscribing, so no unwanted rebuilds.

**Keep `ChangeNotifier` framework-free** — neither provider imports `BuildContext`. Business logic stays independently testable.

**Local `setState` still belongs** — `AnimationController` lives in `StatefulWidget`, not a provider, because it is transient UI state with no business meaning.

---

## 🔭 Possible Extensions

- **`FutureProvider`** — load the product catalogue from an async API
- **`StreamProvider`** — real-time inventory or price updates via WebSocket
- **`ProxyProvider`** — if `CartProvider` needed a dependency on `ProductProvider`
- **`context.select<T, R>()`** — micro-optimise rebuilds to fire only when a specific field changes
- **Persistent storage** — save cart state across launches with `SharedPreferences` or SQLite
- **Authentication state** — `AuthProvider` to gate the checkout flow

---

## 📄 License

This project is for educational purposes.
