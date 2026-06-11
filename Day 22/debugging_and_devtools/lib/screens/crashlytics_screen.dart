import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsCrashScreen extends StatelessWidget {
  const CrashlyticsCrashScreen({super.key});

  /// 1. Non-fatal error (safe logging)
  Future<void> logNonFatalError() async {
    try {
      throw Exception("Non-fatal test error (logged only)");
    } catch (e, stack) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Manual non-fatal test",
        fatal: false,
      );
    }
  }

  /// 2. Fatal crash (reported + app crashes)
  void triggerFatalCrash() {
    FirebaseCrashlytics.instance.log("About to crash the app manually");

    // This will crash app
    FirebaseCrashlytics.instance.crash();
  }

  /// 3. Dart runtime crash (null exception)
  void nullCrashWithLogging() {
    FirebaseCrashlytics.instance.log("Triggering null crash test");

    String? text;

    // This throws runtime error + Crashlytics can capture via FlutterError
    debugPrint(text!.length.toString());
  }

  /// 4. Custom exception with context
  Future<void> customException() async {
    try {
      FirebaseCrashlytics.instance.log("Starting custom exception test");

      List<int> data = [];

      // intentional error
      print(data[5]);
    } catch (e, stack) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "List index crash test",
        fatal: true,
      );
    }
  }

  /// 5. Async crash simulation
  Future<void> asyncCrash() async {
    FirebaseCrashlytics.instance.log("Async crash started");

    await Future.delayed(const Duration(seconds: 1));

    throw Exception("Async fatal crash triggered");
  }

  Widget buildButton({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onTap,
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crashlytics Crash Lab"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "This screen tests Firebase Crashlytics integration.\n\n"
                  "Check Firebase Console → Crashlytics dashboard for reports.",
                ),
              ),
            ),

            const SizedBox(height: 20),

            buildButton(
              title: "Log Non-Fatal Error",
              color: Colors.blue,
              onTap: logNonFatalError,
            ),

            const SizedBox(height: 10),

            buildButton(
              title: "Custom Exception (Fatal)",
              color: Colors.orange,
              onTap: customException,
            ),

            const SizedBox(height: 10),

            buildButton(
              title: "Async Crash",
              color: Colors.purple,
              onTap: asyncCrash,
            ),

            const SizedBox(height: 10),

            buildButton(
              title: "🔥 FORCE FATAL CRASH",
              color: Colors.red,
              onTap: triggerFatalCrash,
            ),
          ],
        ),
      ),
    );
  }
}