import 'package:flutter/material.dart';

/// DartNova-inspired Dot Pattern Background:
/// Renders a subtle, modern grid of dots with an optional radial gradient mask.
class DotPatternBackground extends StatelessWidget {
  final Widget child;
  final double dotRadius;
  final double spacing;
  final Color? dotColor;

  const DotPatternBackground({
    super.key,
    required this.child,
    this.dotRadius = 1.0,
    this.spacing = 24.0,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = dotColor ??
        (isDark
            ? Colors.white.withOpacity(0.06)
            : const Color(0xFF0F1B2D).withOpacity(0.04));

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _DotPatternPainter(
              dotRadius: dotRadius,
              spacing: spacing,
              dotColor: color,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  final double dotRadius;
  final double spacing;
  final Color dotColor;

  _DotPatternPainter({
    required this.dotRadius,
    required this.spacing,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter oldDelegate) =>
      oldDelegate.dotRadius != dotRadius ||
      oldDelegate.spacing != spacing ||
      oldDelegate.dotColor != dotColor;
}

