import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Border Beam Button: A high-end button featuring an animated glowing light beam
/// orbiting around its circular border, with a centered '+' symbol.
class BorderBeamButton extends StatefulWidget {
  final VoidCallback onTap;
  final double size;
  final double beamWidth;
  final List<Color>? beamColors;
  final Widget? icon;
  final String? tooltip;
  final String? label;

  const BorderBeamButton({
    super.key,
    required this.onTap,
    this.size = 58,
    this.beamWidth = 3.0,
    this.beamColors,
    this.icon,
    this.tooltip = 'Try On',
    this.label,
  });

  @override
  State<BorderBeamButton> createState() => _BorderBeamButtonState();
}

class _BorderBeamButtonState extends State<BorderBeamButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Continuous 360-degree border beam rotation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;

    final defaultBeamColors = [
      Colors.transparent,
      AppTheme.deepEmerald.withOpacity(0.1),
      AppTheme.deepEmerald,
      const Color(0xFF00FFCC), // Radiant neon cyan tip
      AppTheme.copper,
      Colors.transparent,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Tooltip(
            message: widget.tooltip ?? 'Try On',
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _BorderBeamPainter(
                      progress: _controller.value,
                      beamWidth: widget.beamWidth,
                      colors: widget.beamColors ?? defaultBeamColors,
                      baseBorderColor: borderColor,
                    ),
                    child: Center(
                      child: Container(
                        width: widget.size - (widget.beamWidth * 2) - 4,
                        height: widget.size - (widget.beamWidth * 2) - 4,
                        decoration: BoxDecoration(
                          color: cardBg,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.deepEmerald.withOpacity(0.18),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: widget.icon ??
                              const Icon(
                                Icons.add,
                                size: 30,
                                color: AppTheme.deepEmerald,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 3),
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: primaryTextColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ],
    );
  }
}

class _BorderBeamPainter extends CustomPainter {
  final double progress; // 0.0 -> 1.0
  final double beamWidth;
  final List<Color> colors;
  final Color baseBorderColor;

  _BorderBeamPainter({
    required this.progress,
    required this.beamWidth,
    required this.colors,
    required this.baseBorderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - beamWidth) / 2;

    // 1. Draw subtle base border ring
    final basePaint = Paint()
      ..color = baseBorderColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, basePaint);

    // 2. Draw rotating glowing beam
    final rect = Rect.fromCircle(center: center, radius: radius);
    final angle = progress * 2 * math.pi;

    final beamPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = beamWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: colors,
        stops: const [0.0, 0.4, 0.7, 0.85, 0.95, 1.0],
        transform: GradientRotation(angle),
      ).createShader(rect);

    canvas.drawCircle(center, radius, beamPaint);

    // 3. Subtle ambient glow along beam
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = beamWidth * 2.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          AppTheme.deepEmerald.withOpacity(0.3),
          const Color(0xFF00FFCC).withOpacity(0.5),
          Colors.transparent,
        ],
        stops: const [0.0, 0.65, 0.88, 1.0],
        transform: GradientRotation(angle),
      ).createShader(rect);

    canvas.drawCircle(center, radius, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _BorderBeamPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
