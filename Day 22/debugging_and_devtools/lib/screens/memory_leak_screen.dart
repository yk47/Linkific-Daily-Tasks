import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class MemoryLeakScreen extends StatefulWidget {
  const MemoryLeakScreen({super.key});

  @override
  State<MemoryLeakScreen> createState() => _MemoryLeakScreenState();
}

class _MemoryLeakScreenState extends State<MemoryLeakScreen> {
  final List<TextEditingController> controllers = [];
  int createdCount = 0;

  void createControllers(int count) {
    for (int i = 0; i < count; i++) {
      controllers.add(TextEditingController());
      createdCount++;
    }
    setState(() {});
  }

  void clearControllersWithoutDispose() {
    controllers.clear();
    setState(() {});
  }

  void clearControllersProperly() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    setState(() {});
  }

  void resetAll() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    createdCount = 0;
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: styledAppBar('Memory Leak Demo'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoCard(
              text: 'Creates TextEditingController instances without proper disposal. '
                  'Open DevTools → Memory tab to observe heap allocations.',
              icon: Icons.memory_rounded,
              accentColor: AppColors.success,
            ),
            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'total created',
                    value: '$createdCount',
                    valueColor: AppColors.cyan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'active now',
                    value: '${controllers.length}',
                    valueColor: controllers.isEmpty
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Actions
            DebugButton(
              label: 'Create 5 Controllers',
              icon: Icons.add_rounded,
              color: AppColors.cyan,
              onPressed: () => createControllers(5),
            ),
            const SizedBox(height: 8),
            DebugButton(
              label: 'Clear WITHOUT Dispose — Leak!',
              icon: Icons.delete_outline_rounded,
              color: AppColors.error,
              onPressed: clearControllersWithoutDispose,
            ),
            const SizedBox(height: 8),
            DebugButton(
              label: 'Clear WITH Dispose — Safe',
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.success,
              onPressed: clearControllersProperly,
            ),
            const SizedBox(height: 8),
            DebugButton(
              label: 'Reset All',
              icon: Icons.refresh_rounded,
              outlined: true,
              onPressed: resetAll,
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            Row(
              children: [
                const Text(
                  'Active controllers',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (controllers.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warningDim,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controllers.length} alive',
                      style: const TextStyle(
                        color: AppColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Expanded(
              child: controllers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No active controllers',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: controllers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: TextField(
                              controller: controllers[index],
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                labelText: 'controller_$index',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}