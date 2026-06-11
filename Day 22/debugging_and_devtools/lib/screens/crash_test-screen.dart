import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class CrashTestScreen extends StatelessWidget {
  const CrashTestScreen({super.key});

  void nullCrash() {
    String? text;
    debugPrint(text!.length.toString());
  }

  void indexCrash() {
    List<int> list = [1, 2, 3];
    debugPrint(list[10].toString());
  }

  void exceptionCrash() {
    throw Exception('🔥 Forced crash triggered!');
  }

  void recursionCrash() {
    recursionCrash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: styledAppBar('Crash Test'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoCard(
            text: '⚠️  These buttons intentionally crash the app. '
                'Use only for testing Crashlytics and DevTools error reporting.',
            icon: Icons.warning_amber_rounded,
            accentColor: AppColors.error,
          ),
          const SizedBox(height: 20),

          _buildCrashCard(
            tag: 'NULL_DEREF',
            title: 'Null Pointer',
            description: 'Force-unwraps a null String — throws Null check operator used on a null value',
            color: AppColors.error,
            icon: Icons.cancel_outlined,
            onPressed: nullCrash,
          ),
          const SizedBox(height: 12),

          _buildCrashCard(
            tag: 'RANGE_ERROR',
            title: 'Index Out of Range',
            description: 'Accesses index 10 on a 3-element list — throws RangeError',
            color: AppColors.warning,
            icon: Icons.format_list_numbered_rounded,
            onPressed: indexCrash,
          ),
          const SizedBox(height: 12),

          _buildCrashCard(
            tag: 'EXCEPTION',
            title: 'Force Exception',
            description: 'Throws a manual Exception — useful for testing error boundaries',
            color: AppColors.purple,
            icon: Icons.bolt_rounded,
            onPressed: exceptionCrash,
          ),
          const SizedBox(height: 12),

          _buildCrashCard(
            tag: 'STACK_OVERFLOW',
            title: 'Infinite Recursion',
            description: 'Calls itself indefinitely until the Dart VM runs out of stack space',
            color: Colors.red[900]!,
            icon: Icons.all_inclusive_rounded,
            onPressed: recursionCrash,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCrashCard({
    required String tag,
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: color,
                            fontSize: 9,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Trigger Crash'),
                    ),
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