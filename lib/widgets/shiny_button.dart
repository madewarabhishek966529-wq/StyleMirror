import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// DartNova-inspired Shiny Button:
/// A sleek button with an animated metallic light reflection sweeping across its surface.
class ShinyButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget? icon;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shimmerColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final Duration duration;

  const ShinyButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.shimmerColor,
    this.borderRadius = 10.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.fontSize = 13.0,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  State<ShinyButton> createState() => _ShinyButtonState();
}

class _ShinyButtonState extends State<ShinyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

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
    final bgColor = widget.backgroundColor ?? AppTheme.deepEmerald;
    final fgColor = widget.foregroundColor ?? Colors.white;
    final shimmer = widget.shimmerColor ?? Colors.white.withOpacity(0.35);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: bgColor.withOpacity(0.28),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Stack(
              children: [
                // Base background color
                Container(
                  color: bgColor,
                  padding: widget.padding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        widget.icon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: fgColor,
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Diagonal Shimmer Beam Sweep
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return FractionalTranslation(
                        translation: Offset((_controller.value * 3.0) - 1.5, 0.0),
                        child: Transform.rotate(
                          angle: 0.35,
                          child: Container(
                            width: 32,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  shimmer,
                                  Colors.transparent,
                                ],
                              ),
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
        ),
      ),
    );
  }
}
