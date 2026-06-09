import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/watchlist_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String watchlist = '/watchlist';

  static Route<dynamic> generateRoute(
      RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );

      case favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoriteScreen(),
        );

      case watchlist:
        return MaterialPageRoute(
          builder: (_) => const WatchlistScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}