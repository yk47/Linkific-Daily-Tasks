import 'package:debugging_and_devtools/screens/crash_test-screen.dart';
import 'package:debugging_and_devtools/screens/devtool_screen.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/demo_card.dart';
import 'counter_bug_screen.dart';

import 'logging_screen.dart';
import 'memory_leak_screen.dart';
import 'network_error_screen.dart';
import 'overflow_screen.dart';
import 'performance_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          _buildSectionLabel('// Core Debugging'),
          _buildCards(context),
          _buildSectionLabel('// Performance & Tools'),
          _buildToolCards(context),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'FLUTTER DEBUGGER',
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Debug Lab',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Interactive demos for mastering Flutter\ndebugging tools & DevTools.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            // Stats row
            Row(
              children: [
                _buildStat('8', 'modules'),
                const SizedBox(width: 20),
                _buildStat('5', 'devtools'),
                const SizedBox(width: 20),
                _buildStat('∞', 'crashes'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.cyan,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontFamily: 'monospace',
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        DemoCard(
          title: 'Logging',
          subtitle: 'print() vs debugPrint() behavior',
          icon: Icons.terminal_rounded,
          accentColor: AppColors.cyan,
          onTap: () => openScreen(context, const LoggingScreen()),
        ),
        DemoCard(
          title: 'Counter Bug',
          subtitle: 'setState() missing — UI won\'t rebuild',
          icon: Icons.refresh_rounded,
          accentColor: AppColors.error,
          onTap: () => openScreen(context, const CounterBugScreen()),
        ),
        DemoCard(
          title: 'Layout Overflow',
          subtitle: 'RenderFlex overflow detection & fix',
          icon: Icons.open_in_full_rounded,
          accentColor: AppColors.warning,
          onTap: () => openScreen(context, const OverflowScreen()),
        ),
        DemoCard(
          title: 'Network Errors',
          subtitle: 'Dio exceptions, timeouts & handling',
          icon: Icons.cloud_off_rounded,
          accentColor: AppColors.purple,
          onTap: () => openScreen(context, const NetworkErrorScreen()),
        ),
        DemoCard(
          title: 'Memory Leaks',
          subtitle: 'Controller disposal & heap profiling',
          icon: Icons.memory_rounded,
          accentColor: AppColors.success,
          onTap: () => openScreen(context, const MemoryLeakScreen()),
        ),
        DemoCard(
          title: 'Crash Test',
          subtitle: 'Intentional runtime crashes',
          icon: Icons.warning_amber_rounded,
          accentColor: AppColors.error,
          onTap: () => openScreen(context, const CrashTestScreen()),
        ),
      ]),
    );
  }

  Widget _buildToolCards(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        DemoCard(
          title: 'Performance',
          subtitle: 'Jank detection & optimization patterns',
          icon: Icons.speed_rounded,
          accentColor: AppColors.warning,
          onTap: () => openScreen(context, const PerformanceScreen()),
        ),
        DemoCard(
          title: 'DevTools Guide',
          subtitle: 'Complete Flutter DevTools reference',
          icon: Icons.developer_mode_rounded,
          accentColor: AppColors.cyan,
          onTap: () => openScreen(context, const DevToolsScreen()),
        ),
      ]),
    );
  }
}