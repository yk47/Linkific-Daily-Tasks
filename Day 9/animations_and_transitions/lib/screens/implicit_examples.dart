import 'package:flutter/material.dart';

class ImplicitExamples extends StatefulWidget {
  const ImplicitExamples({super.key});

  @override
  State<ImplicitExamples> createState() => _ImplicitExamplesState();
}

class _ImplicitExamplesState extends State<ImplicitExamples> {
  bool _toggled = false;
  bool _showFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Animations')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Implicit Animations',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            _exampleCard(
              child: Column(
                children: [
                  const Text(
                    'AnimatedContainer (size & color)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    width: _toggled ? 200 : 100,
                    height: _toggled ? 200 : 100,
                    decoration: BoxDecoration(
                      color: _toggled ? Colors.teal : Colors.amber,
                      borderRadius: BorderRadius.circular(_toggled ? 24 : 8),
                    ),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => setState(() => _toggled = !_toggled),
                    child: const Text('Toggle'),
                  ),
                ],
              ),
            ),

            _exampleCard(
              child: Column(
                children: [
                  const Text(
                    'AnimatedOpacity',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    opacity: _toggled ? 0.2 : 1.0,
                    duration: const Duration(milliseconds: 400),
                    child: const FlutterLogo(size: 72),
                  ),
                ],
              ),
            ),

            _exampleCard(
              child: Column(
                children: [
                  const Text(
                    'AnimatedCrossFade',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    firstChild: Container(
                      width: 150,
                      height: 80,
                      color: Colors.blue,
                      child: const Center(child: Text('First')),
                    ),
                    secondChild: Container(
                      width: 150,
                      height: 80,
                      color: Colors.purple,
                      child: const Center(child: Text('Second')),
                    ),
                    crossFadeState: _showFirst
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 500),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() => _showFirst = !_showFirst),
                    child: const Text('CrossFade'),
                  ),
                ],
              ),
            ),

            _exampleCard(
              child: Column(
                children: [
                  const Text(
                    'TweenAnimationBuilder (color & rotation)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: _toggled ? 1.0 : 0.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value * 3.14,
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Color.lerp(Colors.red, Colors.green, value),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exampleCard({required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}
