import 'package:flutter/material.dart';

class HeroExamples extends StatelessWidget {
  const HeroExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Animations')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(4, (i) {
            final tag = 'hero-$i';
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HeroDetail(tag: tag, index: i),
                ),
              ),
              child: Hero(
                tag: tag,
                createRectTween: (begin, end) =>
                    MaterialRectArcTween(begin: begin, end: end),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.primaries[i % Colors.primaries.length],
                  child: Center(
                    child: Text(
                      'Item $i',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class HeroDetail extends StatelessWidget {
  final String tag;
  final int index;
  const HeroDetail({super.key, required this.tag, required this.index});

  @override
  Widget build(BuildContext context) {
    final color = Colors.primaries[index % Colors.primaries.length];
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: Hero(
          tag: tag,
          createRectTween: (begin, end) =>
              MaterialRectArcTween(begin: begin, end: end),
          flightShuttleBuilder:
              (flightContext, animation, direction, fromContext, toContext) =>
                  ScaleTransition(scale: animation, child: toContext.widget),
          child: Card(
            elevation: 4,
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: 260,
              height: 260,
              child: Center(
                child: Text(
                  'Item $index',
                  style: const TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
