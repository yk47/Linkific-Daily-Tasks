# 🎬 Movie Explorer

A Flutter mobile application for discovering movies and series, built as a hands-on learning project for **Riverpod 2.x** state management. The app integrates with the [Watchmode REST API](https://api.watchmode.com/) to deliver live search, detailed movie information, and streaming availability — all powered by a clean, provider-driven architecture.

---

## ✨ Features

- 🔍 **Live Search** — real-time movie and series search via the Watchmode autocomplete API
- 🎥 **Movie Details** — plot overview, user rating, runtime, genres, and streaming sources
- ❤️ **Favourites** — add/remove movies from a personal favourites list
- 🔖 **Watchlist** — queue movies to watch later with a single tap
- 🌙 **Dark / Light Theme** — toggle between themes from the Settings screen
- 🎨 **Cinematic UI** — deep slate palette with electric-teal accents, Bebas Neue + DM Sans fonts

---

## 📱 Screenshots

> _Add screenshots here after running the app._

---

## 🏗️ Project Structure

```
lib/
├── core/
│   └── theme/
│       └── app_theme.dart        # AppTheme (dark + light) and AppColors palette
├── models/
│   └── movie_model.dart          # Movie data class with fromJson factory
├── services/
│   └── movie_service.dart        # HTTP calls to Watchmode API
├── providers/
│   ├── movie_provider.dart       # movieServiceProvider, searchQueryProvider, searchMoviesProvider, movieDetailsProvider
│   ├── favorite_provider.dart    # FavoriteNotifier + favoriteProvider
│   ├── watchlist_provider.dart   # WatchlistNotifier + watchlistProvider
│   └── theme_provider.dart       # ThemeNotifier + themeProvider
├── screens/
│   ├── home_screen.dart          # Bottom nav shell (IndexedStack)
│   ├── search_screen.dart        # Live search + FutureProvider results
│   ├── details_screen.dart       # Full-bleed poster + movie metadata
│   ├── favorite_screen.dart      # Favourites list
│   ├── watchlist_screen.dart     # Watchlist
│   └── settings_screen.dart      # Theme toggle + app info
├── widgets/
│   ├── movie_card.dart           # Reusable movie row card
│   ├── search_bar.dart           # Search text field widget
│   └── empty_state.dart          # Empty list placeholder
├── routes/
│   └── app_routes.dart           # Named route constants + generateRoute
└── main.dart                     # ProviderScope root, MaterialApp, orientation lock
```

---

## 🧠 Riverpod Provider Map

| Provider | Type | Purpose |
|---|---|---|
| `movieServiceProvider` | `Provider<MovieService>` | Singleton HTTP service injection |
| `searchQueryProvider` | `StateProvider<String>` | Live search query string |
| `searchMoviesProvider` | `FutureProvider<List<Movie>>` | Async movie search results |
| `movieDetailsProvider` | `FutureProvider.family<Map, int>` | Per-movie details by ID |
| `movieSourcesProvider` | `FutureProvider.family<List, int>` | Streaming sources by movie ID |
| `favoriteProvider` | `NotifierProvider<FavoriteNotifier, List<Movie>>` | Favourites list with toggle logic |
| `watchlistProvider` | `NotifierProvider<WatchlistNotifier, List<Movie>>` | Watchlist with toggle logic |
| `themeProvider` | `NotifierProvider<ThemeNotifier, bool>` | Dark/light theme state |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) — version 3.x or later
- Dart SDK `^3.11.5`
- A [Watchmode API key](https://api.watchmode.com/) (free tier available)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/riverpod_state_manage.git
   cd riverpod_state_manage
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add your API key**

   Open `lib/services/movie_service.dart` and replace the existing key:
   ```dart
   static const String apiKey = 'YOUR_WATCHMODE_API_KEY';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.6.1      # Core Riverpod providers
  hooks_riverpod: ^2.6.1        # HookConsumerWidget support
  flutter_hooks: ^0.21.2        # React-style hooks for Flutter
  http: ^1.5.0                  # HTTP client for REST API calls
  cached_network_image: ^3.4.1  # Cached poster image loading
  shared_preferences: ^2.5.3    # Key-value storage (planned for persistence)
  go_router: ^16.0.0            # Declarative routing (planned migration)
  cupertino_icons: ^1.0.8       # iOS-style icons
```

---

## 🔑 API Reference

The app uses the **Watchmode API v1**. All requests include an `X-API-Key` header.

| Endpoint | Used By | Description |
|---|---|---|
| `GET /v1/autocomplete-search/` | `searchMoviesProvider` | Search movies/series by title |
| `GET /v1/title/{id}/details/` | `movieDetailsProvider` | Plot, rating, runtime, genres |
| `GET /v1/title/{id}/sources/` | `movieSourcesProvider` | Streaming availability |

---

## 🎨 Design System

The app uses a custom **cinematic dark luxury** theme defined in `lib/core/theme/app_theme.dart`.

| Token | Value | Usage |
|---|---|---|
| `AppColors.bg` | `#0F1923` | Scaffold background |
| `AppColors.surface` | `#1C2B3A` | Card and nav bar surface |
| `AppColors.teal` | `#00C9A7` | Primary accent (icons, borders, strips) |
| `AppColors.heartRed` | `#FF6B81` | Favourites accent |
| `AppColors.bookmarkGold` | `#FFD166` | Watchlist accent |

**Fonts:** `Bebas Neue` (display headings) · `DM Sans` (UI text)

---

## 📚 Key Riverpod Patterns Used

**Reactive search pipeline**
```dart
// 1. Widget writes to StateProvider
ref.read(searchQueryProvider.notifier).state = value;

// 2. FutureProvider watches it and re-runs automatically
final searchMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.watch(movieServiceProvider).searchMovies(query);
});

// 3. Screen watches FutureProvider and rebuilds on state change
final movies = ref.watch(searchMoviesProvider);
```

**NotifierProvider for list state**
```dart
class FavoriteNotifier extends Notifier<List<Movie>> {
  @override
  List<Movie> build() => [];

  void toggleFavorite(Movie movie) {
    final exists = state.any((item) => item.id == movie.id);
    state = exists
        ? state.where((item) => item.id != movie.id).toList()
        : [...state, movie];
  }
}
```

**FutureProvider.family for parameterised async data**
```dart
final movieDetailsProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, movieId) async {
  return ref.watch(movieServiceProvider).getMovieDetails(movieId);
});

// Consumed in a widget:
final detailsAsync = ref.watch(movieDetailsProvider(movie.id));
detailsAsync.when(
  data: (details) => Text(details['plot_overview']),
  loading: () => CircularProgressIndicator(),
  error: (e, _) => Text('Failed to load'),
);
```

---

## ⚠️ Known Limitations

- **No persistence** — Favourites and Watchlist reset on app restart. `shared_preferences` is installed but not yet wired.
- **No search debounce** — the API fires on every keystroke. A 300ms debounce is planned.
- **Hardcoded API key** — move to a `.env` file or secrets manager before production use.
- **Streaming sources** — `movieSourcesProvider` fetches data but it is not yet rendered in the UI.

---

## 🗺️ Planned Improvements

- [ ] Persist Favourites and Watchlist with `shared_preferences`
- [ ] Add search debounce using `flutter_hooks`
- [ ] Migrate routing to `go_router`
- [ ] Render streaming sources in the Details screen
- [ ] Add unit tests for `FavoriteNotifier` and `WatchlistNotifier` using `ProviderContainer`
- [ ] Move API key to environment variables

---


