import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/navigation_models.dart';
import '../widgets/navigation_components.dart';

Route<dynamic> buildRootRoute(RouteSettings settings) {
  switch (settings.name) {
    case NavigationRoutes.shellHome:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const NavigationShellPage(),
      );
    case NavigationRoutes.details:
      final arguments = settings.arguments is DetailArguments
          ? settings.arguments! as DetailArguments
          : const DetailArguments(
              title: 'Navigation detail',
              message: 'No route arguments were provided.',
              source: 'Unknown',
            );
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => DetailScreen(arguments: arguments),
      );
    case NavigationRoutes.drawerInfo:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const DrawerInfoPage(),
      );
    default:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const UnknownRoutePage(),
      );
  }
}

class NavigationShellPage extends StatefulWidget {
  const NavigationShellPage({super.key});

  @override
  State<NavigationShellPage> createState() => _NavigationShellPageState();
}

class _NavigationShellPageState extends State<NavigationShellPage> {
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _exploreNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _profileNavigatorKey =
      GlobalKey<NavigatorState>();
  final ValueNotifier<String?> _namedRouteResult = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _materialRouteResult = ValueNotifier<String?>(
    null,
  );

  int _currentIndex = 0;

  @override
  void dispose() {
    _namedRouteResult.dispose();
    _materialRouteResult.dispose();
    super.dispose();
  }

  GlobalKey<NavigatorState> _navigatorForIndex(int index) {
    switch (index) {
      case 0:
        return _homeNavigatorKey;
      case 1:
        return _exploreNavigatorKey;
      case 2:
      default:
        return _profileNavigatorKey;
    }
  }

  Future<void> _openNamedDetail(BuildContext context) async {
    final result = await Navigator.of(context, rootNavigator: true)
        .pushNamed<Object?>(
          NavigationRoutes.details,
          arguments: const DetailArguments(
            title: 'Named route detail',
            message:
                'This screen was opened with Navigator.pushNamed and route arguments.',
            source: 'Home shell action',
          ),
        );
    if (result is String) {
      _namedRouteResult.value = result;
    }
  }

  Future<void> _openMaterialPage(BuildContext context) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const QuickMaterialPage()),
    );
    if (result != null) {
      _materialRouteResult.value = result;
    }
  }

  Future<void> _openDrawerDetail(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushNamed<Object?>(
      NavigationRoutes.details,
      arguments: const DetailArguments(
        title: 'Drawer arguments',
        message: 'This route was opened from the navigation drawer.',
        source: 'Drawer menu',
      ),
    );
  }

  void _selectTab(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _handleLocalPop() async {
    final NavigatorState? currentNavigator = _navigatorForIndex(
      _currentIndex,
    ).currentState;
    if (currentNavigator != null && currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }
    return true;
  }

  Widget _buildTabNavigator({
    required GlobalKey<NavigatorState> navigatorKey,
    required RouteFactory onGenerateRoute,
  }) {
    return Navigator(
      key: navigatorKey,
      initialRoute: NavigationRoutes.shellHome,
      onGenerateRoute: onGenerateRoute,
    );
  }

  Route<dynamic> _generateHomeTabRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRoutes.shellHome:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => HomeOverviewPage(
            namedRouteResultListenable: _namedRouteResult,
            materialRouteResultListenable: _materialRouteResult,
            onOpenNamedDetail: _openNamedDetail,
            onOpenMaterialPage: _openMaterialPage,
          ),
        );
      case NavigationRoutes.homeStory:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomeStoryPage(),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const UnknownTabRoutePage(
            title: 'Home route not found',
            message: 'The home navigator did not recognize that route.',
          ),
        );
    }
  }

  Route<dynamic> _generateExploreTabRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRoutes.shellHome:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ExploreTabPage(),
        );
      case NavigationRoutes.exploreLab:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ExploreLabPage(),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const UnknownTabRoutePage(
            title: 'Explore route not found',
            message: 'The explore navigator did not recognize that route.',
          ),
        );
    }
  }

  Route<dynamic> _generateProfileTabRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRoutes.shellHome:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ProfileTabPage(),
        );
      case NavigationRoutes.profileSettings:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ProfileSettingsPage(),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const UnknownTabRoutePage(
            title: 'Profile route not found',
            message: 'The profile navigator did not recognize that route.',
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          final shouldClose = await _handleLocalPop();
          if (shouldClose && mounted) {
            Navigator.of(context).maybePop(result);
          }
        }
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 92,
          titleSpacing: 20,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B1F33), Color(0xFF0F4C81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ['Home', 'Explore', 'Profile'][_currentIndex],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Navigation showcase',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.76),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: IconButton(
                tooltip: 'Open drawer route',
                onPressed: () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(NavigationRoutes.drawerInfo),
                icon: const Icon(Icons.info_outline),
              ),
            ),
          ],
        ),
        drawer: AppNavigationDrawer(
          selectedIndex: _currentIndex,
          onTabSelected: _selectTab,
          onOpenArgumentRoute: () {
            Navigator.of(context).pop();
            _openDrawerDetail(context);
          },
          onOpenDrawerInfo: () {
            Navigator.of(context).pop();
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(NavigationRoutes.drawerInfo);
          },
        ),
        body: Stack(
          children: [
            const AppBackdrop(),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 180),
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    _buildTabNavigator(
                      navigatorKey: _homeNavigatorKey,
                      onGenerateRoute: _generateHomeTabRoute,
                    ),
                    _buildTabNavigator(
                      navigatorKey: _exploreNavigatorKey,
                      onGenerateRoute: _generateExploreTabRoute,
                    ),
                    _buildTabNavigator(
                      navigatorKey: _profileNavigatorKey,
                      onGenerateRoute: _generateProfileTabRoute,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDCE7F2)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A0B1F33),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _selectTab,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: const Color(0xFF0F4C81),
                unselectedItemColor: const Color(0xFF75889A),
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                showUnselectedLabels: true,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.layers_outlined),
                    activeIcon: Icon(Icons.layers),
                    label: 'Explore',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onOpenArgumentRoute,
    required this.onOpenDrawerInfo,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onOpenArgumentRoute;
  final VoidCallback onOpenDrawerInfo;

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;
    final double headerHeightClamped =
        (screenH * 0.45).clamp(260, 520) as double;

    return Drawer(
      backgroundColor: const Color(0xFFF7FBFF),
      surfaceTintColor: Colors.transparent,
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B1F33),
                  Color(0xFF0F4C81),
                  Color(0xFF31A0F5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SizedBox(
              height: headerHeightClamped,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    right: -18,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -42,
                    left: -14,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 50, 18),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Navigation Lab',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Complete navigation system',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              height: 0.8,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Drawer, tabs, nested stacks, and data passing in one app.',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 12,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              _DrawerStat(label: 'Sections', value: '3'),
                              SizedBox(width: 10),
                              _DrawerStat(label: 'Routes', value: '6'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  selected: selectedIndex == 0,
                  selectedTileColor: const Color(0xFFE7F1FB),
                  title: const Text('Home'),
                  subtitle: const Text('Named routes and data return'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onTabSelected(0);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.layers_outlined),
                  selected: selectedIndex == 1,
                  selectedTileColor: const Color(0xFFE7F1FB),
                  title: const Text('Explore'),
                  subtitle: const Text('TabBar and nested routes'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onTabSelected(1);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  selected: selectedIndex == 2,
                  selectedTileColor: const Color(0xFFE7F1FB),
                  title: const Text('Profile'),
                  subtitle: const Text('Stateful bottom-nav tab'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onTabSelected(2);
                  },
                ),
                const Divider(height: 24),
                ListTile(
                  leading: const Icon(Icons.route_outlined),
                  title: const Text('Open argument route'),
                  subtitle: const Text('Push a named route with arguments'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onOpenArgumentRoute();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Navigation notes'),
                  subtitle: const Text('Open a named route from the drawer'),
                  onTap: () {
                    Navigator.of(context).pop();
                    onOpenDrawerInfo();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerStat extends StatelessWidget {
  const _DrawerStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeOverviewPage extends StatelessWidget {
  const HomeOverviewPage({
    super.key,
    required this.namedRouteResultListenable,
    required this.materialRouteResultListenable,
    required this.onOpenNamedDetail,
    required this.onOpenMaterialPage,
  });

  final ValueListenable<String?> namedRouteResultListenable;
  final ValueListenable<String?> materialRouteResultListenable;
  final Future<void> Function(BuildContext context) onOpenNamedDetail;
  final Future<void> Function(BuildContext context) onOpenMaterialPage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NavigationHeroCard(
              title: 'Navigation Home',
              subtitle:
                  'Use this screen to launch named routes, MaterialPageRoute pages, and nested tab routes.',
              icon: Icons.navigation_rounded,
            ),
            const SizedBox(height: 18),
            const PageSectionHeader(
              label: 'Quick actions',
              title: 'Launch routes and see results',
              subtitle:
                  'This screen demonstrates named routes, MaterialPageRoute, and result passing in both directions.',
            ),
            const SizedBox(height: 14),
            ActionPanel(
              title: 'Actions',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: () => onOpenNamedDetail(context),
                    icon: const Icon(Icons.route),
                    label: const Text('Open named detail'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => onOpenMaterialPage(context),
                    icon: const Icon(Icons.pageview_outlined),
                    label: const Text('Open MaterialPageRoute page'),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(NavigationRoutes.homeStory),
                    icon: const Icon(Icons.subdirectory_arrow_right),
                    label: const Text('Open nested home route'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const PageSectionHeader(
              label: 'Live results',
              title: 'Route output you can inspect',
              subtitle:
                  'These cards update when the demo routes return values to the home screen.',
            ),
            const SizedBox(height: 14),
            ValueListenableBuilder<String?>(
              valueListenable: namedRouteResultListenable,
              builder: (context, value, _) => ResultPanel(
                title: 'Named route result',
                value: value,
                emptyLabel: 'No named route result yet.',
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<String?>(
              valueListenable: materialRouteResultListenable,
              builder: (context, value, _) => ResultPanel(
                title: 'MaterialPageRoute result',
                value: value,
                emptyLabel: 'No material route result yet.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeStoryPage extends StatelessWidget {
  const HomeStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NavigationHeroCard(
                    title: 'Nested home route',
                    subtitle: 'This page lives inside the home tab navigator.',
                    icon: Icons.subdirectory_arrow_right_rounded,
                  ),
                  const SizedBox(height: 16),
                  ActionPanel(
                    title: 'What this demonstrates',
                    child: const Text(
                      'The home tab keeps its own route stack, so this page appears without disturbing the other tabs.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Return to the home screen'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreTabPage extends StatefulWidget {
  const ExploreTabPage({super.key});

  @override
  State<ExploreTabPage> createState() => _ExploreTabPageState();
}

class _ExploreTabPageState extends State<ExploreTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NavigationHeroCard(
              title: 'Explore patterns',
              subtitle:
                  'This tab uses a TabController, a custom indicator, and an internal route stack.',
              icon: Icons.tab_rounded,
            ),
            const SizedBox(height: 18),
            const PageSectionHeader(
              label: 'TabBar',
              title: 'Switch between guided navigation concepts',
              subtitle:
                  'Each tab explores a different aspect of routing while staying inside the bottom-nav shell.',
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDDE8F3)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x120F4C81),
                    blurRadius: 22,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF0F4C81),
                  borderRadius: BorderRadius.circular(18),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF35516F),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Guide'),
                  Tab(text: 'Routes'),
                  Tab(text: 'State'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 340,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ExploreTabCard(
                    title: 'TabBar basics',
                    description:
                        'Use the controller to coordinate labels, indicators, and content.',
                    icon: Icons.explore_outlined,
                    actionLabel: 'Open nested explore route',
                    actionIcon: Icons.subdirectory_arrow_right,
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(NavigationRoutes.exploreLab),
                  ),
                  ExploreTabCard(
                    title: 'Nested navigation',
                    description:
                        'This tab can push its own internal pages without replacing the shell.',
                    icon: Icons.route_outlined,
                    actionLabel: 'Push a local route',
                    actionIcon: Icons.arrow_forward,
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(NavigationRoutes.exploreLab),
                  ),
                  ExploreTabCard(
                    title: 'State persistence',
                    description:
                        'The IndexedStack keeps this tab alive while you switch between bottom-nav items.',
                    icon: Icons.sync,
                    actionLabel: 'Inspect the bottom nav',
                    actionIcon: Icons.layers,
                    onPressed: () {},
                    showActionButton: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreLabPage extends StatelessWidget {
  const ExploreLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NavigationHeroCard(
                    title: 'Explore route',
                    subtitle:
                        'This page was pushed from inside the explore tab navigator.',
                    icon: Icons.route_rounded,
                  ),
                  const SizedBox(height: 16),
                  ActionPanel(
                    title: 'Nested route notes',
                    child: const Text(
                      'Use nested routes when one tab needs deeper flows while the shell stays visible.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Return to explore'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const NavigationHeroCard(
              title: 'Profile and settings',
              subtitle:
                  'This tab shows another nested stack and a different navigation destination.',
              icon: Icons.person_rounded,
            ),
            const SizedBox(height: 18),
            const PageSectionHeader(
              label: 'Persistent state',
              title: 'Profile routes stay isolated',
              subtitle:
                  'This tab keeps its own navigation stack while the shell preserves the selected section.',
            ),
            const SizedBox(height: 14),
            ActionPanel(
              title: 'Profile stack',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'You can keep profile-specific routes isolated from the rest of the app.',
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(NavigationRoutes.profileSettings),
                    icon: const Icon(Icons.settings),
                    label: const Text('Open profile settings'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ResultPanel(
              title: 'Bottom nav state',
              value:
                  'The profile tab stays alive while you switch tabs because the shell uses an IndexedStack.',
              emptyLabel: 'State persistence is handled by the shell.',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NavigationHeroCard(
                    title: 'Profile settings route',
                    subtitle:
                        'This is a nested route inside the profile navigator.',
                    icon: Icons.settings_rounded,
                  ),
                  const SizedBox(height: 16),
                  ActionPanel(
                    title: 'Nested route behavior',
                    child: const Text(
                      'This flow can live under the profile tab without affecting other tabs or the root drawer routes.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Return to profile'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.arguments});

  final DetailArguments arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(arguments.title),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NavigationHeroCard(
                    title: arguments.title,
                    subtitle: arguments.message,
                    icon: Icons.route_rounded,
                    details: [
                      _DetailLine(label: 'Source', value: arguments.source),
                      const _DetailLine(
                        label: 'Pattern',
                        value: 'Named route with arguments',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ActionPanel(
                    title: 'Return data back',
                    child: const Text(
                      'Press the button below to pop the route and return a value to the previous screen.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pop('Accepted from named detail'),
                    icon: const Icon(Icons.reply),
                    label: const Text('Send result back'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close without result'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerInfoPage extends StatelessWidget {
  const DrawerInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Navigation notes'),
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                NavigationHeroCard(
                  title: 'Navigation patterns',
                  subtitle:
                      'The app demonstrates the major flows from the task brief.',
                  icon: Icons.menu_book_rounded,
                ),
                SizedBox(height: 16),
                ActionPanel(
                  title: 'Implemented patterns',
                  child: Text(
                    'Named routes live in MaterialApp, the drawer can jump between major sections, bottom navigation is preserved with an IndexedStack, and the inner tabs keep their own route stacks.',
                  ),
                ),
                SizedBox(height: 16),
                ActionPanel(
                  title: 'Data flow',
                  child: Text(
                    'Route arguments go forward through pushNamed and results come back through Navigator.pop.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuickMaterialPage extends StatelessWidget {
  const QuickMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AppBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NavigationHeroCard(
                    title: 'MaterialPageRoute',
                    subtitle:
                        'This screen was pushed with an explicit MaterialPageRoute.',
                    icon: Icons.slideshow_rounded,
                  ),
                  const SizedBox(height: 16),
                  ActionPanel(
                    title: 'Local navigation',
                    child: const Text(
                      'This is the classic imperative navigation API: push a page, then pop with a result.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pop('Returned from MaterialPageRoute'),
                    child: const Text('Return result to home'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close without result'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(title: const Text('Route not found')),
      body: const Center(child: Text('The requested route does not exist.')),
    );
  }
}

class UnknownTabRoutePage extends StatelessWidget {
  const UnknownTabRoutePage({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ActionPanel(
              title: title,
              child: Text(message, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF60748A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF0A1D33)),
            ),
          ),
        ],
      ),
    );
  }
}
