import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _isPressed
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.04),
            border: Border.all(
              color: _isPressed
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.12),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(16),
              splashColor: Colors.white.withOpacity(0.05),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else ...[
                      _GoogleLogo(),
                      const SizedBox(width: 12),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Google "G" Logo painted with Canvas ──────────────────────────────────────

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(22, 22), painter: _GoogleLogoPainter());
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    // Clip to circle
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );

    // White background
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white);

    const double sweep = 3.14159265 / 2; // 90°

    // Red (top-right)
    _drawSlice(canvas, cx, cy, r, -sweep / 2, sweep, const Color(0xFFEA4335));
    // Blue (top-left)
    _drawSlice(
      canvas,
      cx,
      cy,
      r,
      -sweep / 2 + sweep,
      sweep,
      const Color(0xFF4285F4),
    );
    // Green (bottom-left)
    _drawSlice(
      canvas,
      cx,
      cy,
      r,
      -sweep / 2 + sweep * 2,
      sweep,
      const Color(0xFF34A853),
    );
    // Yellow (bottom-right)
    _drawSlice(
      canvas,
      cx,
      cy,
      r,
      -sweep / 2 + sweep * 3,
      sweep,
      const Color(0xFFFBBC05),
    );

    // Inner white circle (donut)
    canvas.drawCircle(Offset(cx, cy), r * 0.62, Paint()..color = Colors.white);

    // Blue horizontal bar (the crossbar of the G)
    final Paint barPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - r * 0.18, r * 0.98, r * 0.36),
      barPaint,
    );

    // Re-draw inner white to clean up bar overlap on left
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.62),
      3.14159265 / 2,
      3.14159265,
      true,
      Paint()..color = Colors.white,
    );
  }

  void _drawSlice(
    Canvas canvas,
    double cx,
    double cy,
    double r,
    double startAngle,
    double sweepAngle,
    Color color,
  ) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(cx, cy)
      ..arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle,
        sweepAngle,
        false,
      )
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
