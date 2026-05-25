import 'package:flutter/material.dart';

class AnimatedUiExamples extends StatefulWidget {
  const AnimatedUiExamples({super.key});

  @override
  State<AnimatedUiExamples> createState() => _AnimatedUiExamplesState();
}

class _AnimatedUiExamplesState extends State<AnimatedUiExamples> {
  bool _showForm = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated UIs')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Animated UI samples',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                AnimatedCrossFade(
                  firstChild: ElevatedButton(
                    onPressed: () => setState(() => _showForm = true),
                    child: const Text('Show Login'),
                  ),
                  secondChild: _buildForm(),
                  crossFadeState: _showForm
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 400),
                ),
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: _loading ? 60 : 200,
                  height: 48,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Submit'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SizedBox(
      width: 320,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => setState(() => _showForm = false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(onPressed: _submit, child: const Text('Login')),
            ],
          ),
        ],
      ),
    );
  }

  void _submit() {
    setState(() => _loading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _loading = false);
    });
  }
}
