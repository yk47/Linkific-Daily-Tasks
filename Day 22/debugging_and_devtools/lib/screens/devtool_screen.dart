import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class DevToolsScreen extends StatelessWidget {
  const DevToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: styledAppBar('DevTools Guide'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoCard(
            text: 'Flutter DevTools is a suite of profiling and debugging tools. '
                'Use it alongside this guide while building real apps.',
            icon: Icons.developer_mode_rounded,
            accentColor: AppColors.cyan,
          ),
          const SizedBox(height: 20),
          _buildToolCard(
            number: '01',
            title: 'Widget Inspector',
            icon: Icons.account_tree_rounded,
            color: AppColors.cyan,
            items: [
              'View and explore the widget tree',
              'Detect layout overflow issues',
              'Inspect layout constraints & sizing',
              'Select widgets directly on screen',
            ],
          ),
          const SizedBox(height: 12),
          _buildToolCard(
            number: '02',
            title: 'Timeline View',
            icon: Icons.timeline_rounded,
            color: AppColors.success,
            items: [
              'Detect jank (frames over 16ms)',
              'Analyze UI vs Raster thread',
              'Measure per-frame render time',
              'Optimize animations & transitions',
            ],
          ),
          const SizedBox(height: 12),
          _buildToolCard(
            number: '03',
            title: 'Memory Profiler',
            icon: Icons.memory_rounded,
            color: AppColors.purple,
            items: [
              'Track heap allocation over time',
              'Detect and isolate memory leaks',
              'Monitor object creation rates',
              'Verify controller disposal',
            ],
          ),
          const SizedBox(height: 12),
          _buildToolCard(
            number: '04',
            title: 'Network Inspector',
            icon: Icons.cloud_rounded,
            color: AppColors.warning,
            items: [
              'Monitor all outgoing API requests',
              'Inspect HTTP status codes',
              'View request headers & responses',
              'Debug failed or slow API calls',
            ],
          ),
          const SizedBox(height: 12),
          _buildToolCard(
            number: '05',
            title: 'Logging View',
            icon: Icons.terminal_rounded,
            color: AppColors.error,
            items: [
              'View print() and debugPrint() output',
              'Track app lifecycle events',
              'Debug runtime errors & exceptions',
              'Monitor stream and state changes',
            ],
          ),
          const SizedBox(height: 24),
          _buildWorkflowCard(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required String number,
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Text(
                  number,
                  style: TextStyle(
                    color: color.withOpacity(0.35),
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
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
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 7, right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13.5,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildWorkflowCard() {
    final steps = [
      ('Reproduce', 'Re-create the exact conditions that trigger the issue'),
      ('Check Logs', 'Look at console output for errors or clues'),
      ('Widget Inspector', 'Visualize the tree and constraints'),
      ('Timeline', 'Profile frame rendering for jank'),
      ('Memory', 'Hunt for leaks or excess allocations'),
      ('Fix & Verify', 'Apply changes and confirm resolution'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.cyanDim,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.route_rounded,
                    color: AppColors.cyan,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Debugging Workflow',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: steps.asMap().entries.map((entry) {
                final i = entry.key;
                final step = entry.value;
                final isLast = i == steps.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: AppColors.cyan,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 1,
                            height: 28,
                            color: AppColors.cardBorder,
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: isLast ? 0 : 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.$1,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              step.$2,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}