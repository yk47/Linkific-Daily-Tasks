# navigation_

A Flutter navigation showcase that demonstrates named routes, a drawer, bottom navigation, tabs, nested navigators, and data passing in both directions.

## What It Demonstrates

- `Navigator.push` and `Navigator.pop`
- `MaterialPageRoute`
- Passing data forward with named-route arguments
- Returning data backward with route results
- `Drawer` and `DrawerHeader`
- `BottomNavigationBar` with persistent tab state
- `TabController`, `TabBar`, and `TabBarView`
- Nested navigators and nested routes

## Route Map

- `/` opens the navigation shell
- `/details` opens the named-route detail screen and reads arguments from `RouteSettings`
- `/drawer-info` opens the route notes screen from the drawer or app bar
- `/home/story` opens a nested route inside the home tab navigator
- `/explore/lab` opens a nested route inside the explore tab navigator
- `/profile/settings` opens a nested route inside the profile tab navigator

## Key Flow

1. The shell keeps the bottom navigation state with an `IndexedStack` so tab stacks stay alive.
2. The drawer switches sections or launches named routes.
3. The home tab launches a named route with arguments and also a `MaterialPageRoute` screen that returns a result.
4. The explore tab shows a manual `TabController` with a custom indicator and a nested route.
5. The profile tab shows another nested route and demonstrates state persistence across bottom-navigation switches.

## Run It

```bash
flutter pub get
flutter run
```

## Test It

```bash
flutter test
```
