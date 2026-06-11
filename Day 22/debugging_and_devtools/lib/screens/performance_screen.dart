import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  bool showBadVersion = true;
  int heavyResult = 0;
  int? lastDurationMs;

  int heavyCalculation() {
    int result = 0;
    for (int i = 0; i < 50000000; i++) {
      result += (i % 5);
    }
    return result;
  }

  void runHeavyTask() {
    final sw = Stopwatch()..start();
    setState(() {
      heavyResult = heavyCalculation();
    });
    sw.stop();
    setState(() {
      lastDurationMs = sw.elapsedMilliseconds;
    });
    debugPrint('Heavy task: ${sw.elapsedMilliseconds}ms');
  }

  void runOptimizedTask() {
    final sw = Stopwatch()..start();
    int result = 0;
    for (int i = 0; i < 1000000; i++) {
      result += (i % 5);
    }
    setState(() {
      heavyResult = result;
    });
    sw.stop();
    setState(() {
      lastDurationMs = sw.elapsedMilliseconds;
    });
    debugPrint('Optimized task: ${sw.elapsedMilliseconds}ms');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: styledAppBar('Performance Demo'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoCard(
            text: 'Demonstrates how heavy computation causes jank. '
                'Open DevTools → Timeline to observe frame drops.',
            icon: Icons.speed_rounded,
            accentColor: AppColors.warning,
          ),
          const SizedBox(height: 16),

          // Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: SwitchListTile(
              dense: true,
              title: Text(
                showBadVersion ? '⚠️  Bad Version Active' : '✅  Optimized Active',
                style: TextStyle(
                  color: showBadVersion ? AppColors.error : AppColors.success,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                showBadVersion
                    ? '50M iterations on main thread'
                    : '1M iterations — 50x faster',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
              value: showBadVersion,
              onChanged: (v) => setState(() => showBadVersion = v),
            ),
          ),
          const SizedBox(height: 16),

          DebugButton(
            label: showBadVersion ? 'Run HEAVY Task' : 'Run OPTIMIZED Task',
            icon: showBadVersion
                ? Icons.warning_amber_rounded
                : Icons.rocket_launch_rounded,
            color: showBadVersion ? AppColors.error : AppColors.success,
            onPressed: showBadVersion ? runHeavyTask : runOptimizedTask,
          ),
          const SizedBox(height: 16),

          // Result
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'RESULT',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontFamily: 'monospace',
                        letterSpacing: 1.5,
                      ),
                    ),
                    if (lastDurationMs != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: (lastDurationMs! > 100)
                              ? AppColors.errorDim
                              : AppColors.successDim,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${lastDurationMs}ms',
                          style: TextStyle(
                            color: (lastDurationMs! > 100)
                                ? AppColors.error
                                : AppColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  heavyResult == 0 ? '—' : '$heavyResult',
                  style: const TextStyle(
                    color: AppColors.cyan,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'Performance Tips',
            icon: Icons.lightbulb_outline_rounded,
            accentColor: AppColors.warning,
            child: Column(
              children: const [
                _TipRow(tip: 'Avoid heavy computation in build()'),
                _TipRow(tip: 'Use Isolates for CPU-intensive work'),
                _TipRow(tip: 'Use const constructors wherever possible'),
                _TipRow(tip: 'Minimize unnecessary setState() calls'),
                _TipRow(tip: 'Use ListView.builder for large lists'),
                _TipRow(tip: 'Profile before optimizing — measure first'),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final String tip;
  const _TipRow({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.warning,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}