import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class CounterBugScreen extends StatefulWidget {
  const CounterBugScreen({super.key});

  @override
  State<CounterBugScreen> createState() => _CounterBugScreenState();
}

class _CounterBugScreenState extends State<CounterBugScreen> {
  int brokenCounter = 0;
  int fixedCounter = 0;

  void incrementBrokenCounter() {
    brokenCounter++;
    debugPrint('Broken Counter (internal): $brokenCounter');
  }

  void incrementFixedCounter() {
    setState(() {
      fixedCounter++;
    });
    debugPrint('Fixed Counter: $fixedCounter');
  }

  void resetCounters() {
    setState(() {
      brokenCounter = 0;
      fixedCounter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: styledAppBar('setState() Bug'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoCard(
            text: 'The broken counter\'s value changes internally but the UI '
                'never rebuilds. Open Debug Console to see the true internal value.',
            icon: Icons.refresh_rounded,
            accentColor: AppColors.error,
          ),
          const SizedBox(height: 20),

          _buildCounterCard(
            tag: 'NO setState()',
            tagColor: AppColors.error,
            title: 'Broken Counter',
            description: 'State mutated directly — UI will not update',
            value: brokenCounter,
            onPressed: incrementBrokenCounter,
            color: AppColors.error,
            codeHint: 'brokenCounter++;  // missing setState()',
          ),
          const SizedBox(height: 14),

          _buildCounterCard(
            tag: 'WITH setState()',
            tagColor: AppColors.success,
            title: 'Fixed Counter',
            description: 'setState() triggers rebuild — UI updates correctly',
            value: fixedCounter,
            onPressed: incrementFixedCounter,
            color: AppColors.success,
            codeHint: 'setState(() { fixedCounter++; });',
          ),
          const SizedBox(height: 20),

          DebugButton(
            label: 'Reset Both Counters',
            icon: Icons.refresh_rounded,
            outlined: true,
            onPressed: resetCounters,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCounterCard({
    required String tag,
    required Color tagColor,
    required String title,
    required String description,
    required int value,
    required VoidCallback onPressed,
    required Color color,
    required String codeHint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: color.withOpacity(0.15)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: tagColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  '$value',
                  style: TextStyle(
                    color: color,
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    height: 1,
                  ),
                ),
                const SizedBox(height: 20),
                // Code hint
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    codeHint,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: color == AppColors.success
                          ? AppColors.background
                          : Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Increment',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
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