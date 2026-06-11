import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class LoggingScreen extends StatefulWidget {
  const LoggingScreen({super.key});

  @override
  State<LoggingScreen> createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  final List<_LogEntry> logs = [];

  void addLog(String type, String message, Color color) {
    setState(() {
      logs.insert(0, _LogEntry(type: type, message: message, color: color));
    });
  }

  void generatePrintLog() {
    print('This is a print() log');
    addLog('print()', 'This is a print() log', AppColors.cyan);
  }

  void generateDebugPrintLog() {
    debugPrint('This is a debugPrint() log');
    addLog('debugPrint()', 'This is a debugPrint() log', AppColors.success);
  }

  void generateLargeLog() {
    final largeText = List.generate(200, (i) => 'Item $i').join(' ');
    debugPrint(largeText);
    addLog('debugPrint()', 'Large output — ${largeText.length} chars', AppColors.warning);
  }

  void clearLogs() {
    setState(() => logs.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: styledAppBar(
        'Logging Demo',
        actions: [
          if (logs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Clear logs',
              onPressed: clearLogs,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoCard(
              text: 'Open the Debug Console in VS Code or Android Studio '
                  'to observe the logs generated below.',
              icon: Icons.terminal_rounded,
              accentColor: AppColors.cyan,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _LogButton(
                    label: 'print()',
                    color: AppColors.cyan,
                    onPressed: generatePrintLog,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LogButton(
                    label: 'debugPrint()',
                    color: AppColors.success,
                    onPressed: generateDebugPrintLog,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _LogButton(
                    label: 'Large Log',
                    color: AppColors.warning,
                    onPressed: generateLargeLog,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Text(
                  'CONSOLE OUTPUT',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontFamily: 'monospace',
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                if (logs.isNotEmpty)
                  Text(
                    '${logs.length} entries',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: logs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.terminal_rounded,
                              color: AppColors.textMuted,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No logs yet',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: logs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: log.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  log.type,
                                  style: TextStyle(
                                    color: log.color,
                                    fontSize: 10,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  log.message,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogEntry {
  final String type;
  final String message;
  final Color color;
  _LogEntry({required this.type, required this.message, required this.color});
}

class _LogButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _LogButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.12),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: color.withOpacity(0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      ),
      child: Text(label),
    );
  }
}