import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/app_platform.dart';

/// Neon Flicker Text with realistic electric neon gas-tube pulse & intermittent flicker
class NeonFlickerText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color? baseColor;
  final Color? glowColor;
  final FontWeight fontWeight;
  final bool showIcon;

  const NeonFlickerText({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.baseColor,
    this.glowColor,
    this.fontWeight = FontWeight.w800,
    this.showIcon = true,
  });

  @override
  State<NeonFlickerText> createState() => _NeonFlickerTextState();
}

class _NeonFlickerTextState extends State<NeonFlickerText> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _flickerTimer;
  double _flickerOpacity = 1.0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    if (!AppPlatform.isTest) {
      _pulseController.repeat(reverse: true);
      _scheduleNextFlicker();
    } else {
      _pulseController.value = 1.0;
    }
  }

  void _scheduleNextFlicker() {
    final nextInterval = 2500 + _random.nextInt(3500); // Random flicker every 2.5 - 6 seconds
    _flickerTimer = Timer(Duration(milliseconds: nextInterval), () {
      if (!mounted) return;
      _triggerNeonFlicker();
    });
  }

  void _triggerNeonFlicker() async {
    // Quick burst of 3 realistic neon tube flickers
    for (int i = 0; i < 3; i++) {
      if (!mounted) return;
      setState(() => _flickerOpacity = 0.25 + _random.nextDouble() * 0.35);
      await Future.delayed(Duration(milliseconds: 30 + _random.nextInt(50)));
      if (!mounted) return;
      setState(() => _flickerOpacity = 1.0);
      await Future.delayed(Duration(milliseconds: 20 + _random.nextInt(40)));
    }
    if (mounted) {
      _scheduleNextFlicker();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _flickerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = widget.baseColor ?? (isDark ? Colors.white : AppTheme.inkNavy);
    final glow = widget.glowColor ?? AppTheme.deepEmerald;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulse = _pulseController.value;
        final currentOpacity = _flickerOpacity.clamp(0.2, 1.0);
        final glowIntensity = (0.7 + (pulse * 0.3)) * currentOpacity;

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.showIcon) ...[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: glow.withOpacity(0.12 * glowIntensity),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: glow.withOpacity(0.35 * glowIntensity),
                      blurRadius: 10 * glowIntensity,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.content_cut,
                  color: glow,
                  size: widget.fontSize * 0.85,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Opacity(
              opacity: currentOpacity,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                  color: primaryColor,
                  letterSpacing: -0.3,
                  shadows: [
                    // Tight inner neon glow
                    Shadow(
                      color: glow.withOpacity(0.9 * glowIntensity),
                      blurRadius: 4 * glowIntensity,
                    ),
                    // Medium neon spread
                    Shadow(
                      color: glow.withOpacity(0.65 * glowIntensity),
                      blurRadius: 12 * glowIntensity,
                    ),
                    // Outer ambient neon aura
                    Shadow(
                      color: const Color(0xFF00FFCC).withOpacity(0.4 * glowIntensity),
                      blurRadius: 22 * glowIntensity,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

