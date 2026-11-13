import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// DartNova-inspired Border Beam Card:
/// Animates a radiant glowing light beam orbiting around any rounded rectangular card.
class BorderBeamCard extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final double borderRadius;
  final Duration duration;
  final List<Color>? beamColors;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double beamLength; // fraction 0.0 - 1.0 of the perimeter

  const BorderBeamCard({
    super.key,
    required this.child,
    this.borderWidth = 1.6,
    this.borderRadius = 14.0,
    this.duration = const Duration(milliseconds: 3500),
    this.beamColors,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.beamLength = 0.25,
  });

  @override
  State<BorderBeamCard> createState() => _BorderBeamCardState();
}

class _BorderBeamCardState extends State<BorderBeamCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (!isTest) {
      _controller.repeat();
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = widget.backgroundColor ?? (isDark ? AppTheme.darkCard : AppTheme.cardWhite);
    final baseBorder = widget.borderColor ?? (isDark ? AppTheme.darkBorder : AppTheme.borderIvory);

    final colors = widget.beamColors ??
        [
          Colors.transparent,
          AppTheme.deepEmerald.withOpacity(0.1),
          AppTheme.deepEmerald,
          const Color(0xFF00FFCC), // Radiant neon cyan tip
          AppTheme.copper,
          Colors.transparent,
        ];

    return Stack(
      children: [
        // Base container with background & base border
        Container(
          padding: widget.padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(color: baseBorder, width: 1.0),
            boxShadow: const [AppTheme.cardShadow],
          ),
          child: widget.child,
        ),

        // Animated border beam on top
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _BorderBeamCardPainter(
                    progress: _controller.value,
                    borderWidth: widget.borderWidth,
                    borderRadius: widget.borderRadius,
                    colors: colors,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BorderBeamCardPainter extends CustomPainter {
  final double progress;
  final double borderWidth;
  final double borderRadius;
  final List<Color> colors;

  _BorderBeamCardPainter({
    required this.progress,
    required this.borderWidth,
    required this.borderRadius,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;

    final metric = pathMetrics.first;
    final totalLength = metric.length;
    final beamLength = totalLength * 0.28;

    final start = (progress * totalLength) % totalLength;
    final end = start + beamLength;

    Path extractPath;
    if (end <= totalLength) {
      extractPath = metric.extractPath(start, end);
    } else {
      extractPath = metric.extractPath(start, totalLength);
      extractPath.addPath(metric.extractPath(0, end - totalLength), Offset.zero);
    }

    // Glowing beam paint
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2.2
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5)
      ..shader = SweepGradient(
        colors: colors,
        startAngle: 0,
        endAngle: math.pi * 2,
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(rect);

    canvas.drawPath(extractPath, glowPaint);

    // Sharp core beam paint
    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: colors,
        startAngle: 0,
        endAngle: math.pi * 2,
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(rect);

    canvas.drawPath(extractPath, corePaint);
  }

  @override
  bool shouldRepaint(_BorderBeamCardPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
