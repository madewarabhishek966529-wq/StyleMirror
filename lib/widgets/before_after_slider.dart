import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

enum ComparisonMode {
  slider,
  sideBySide,
  originalOnly,
  styledOnly,
}

/// Interactive Before & After comparison widget for Hair and Beard try-on
/// Design System: Tactile Emerald handle, Sliding Mode Pills, 14px Card Container
class BeforeAfterSlider extends StatefulWidget {
  final Widget beforeWidget;
  final Widget afterWidget;
  final String beforeLabel;
  final String afterLabel;
  final double initialPosition; // 0.0 to 1.0
  final double? height;

  const BeforeAfterSlider({
    super.key,
    required this.beforeWidget,
    required this.afterWidget,
    this.beforeLabel = 'BEFORE',
    this.afterLabel = 'AFTER',
    this.initialPosition = 0.5,
    this.height,
  });

  factory BeforeAfterSlider.fromBytes({
    Key? key,
    required Uint8List? beforeBytes,
    required Uint8List? afterBytes,
    required Widget fallbackBefore,
    required Widget fallbackAfter,
    String beforeLabel = 'BEFORE',
    String afterLabel = 'AFTER',
    double? height,
  }) {
    return BeforeAfterSlider(
      key: key,
      beforeWidget: beforeBytes != null
          ? Image.memory(beforeBytes, fit: BoxFit.cover)
          : fallbackBefore,
      afterWidget: afterBytes != null
          ? Image.memory(afterBytes, fit: BoxFit.cover)
          : fallbackAfter,
      beforeLabel: beforeLabel,
      afterLabel: afterLabel,
      height: height,
    );
  }

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  late double _position; // 0.0 to 1.0
  ComparisonMode _mode = ComparisonMode.slider;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  void _onPanUpdate(DragUpdateDetails details, double width) {
    if (width <= 0) return;
    setState(() {
      _position = (_position + details.delta.dx / width).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? 380.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mode Selector Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModeChip('Split Slider', ComparisonMode.slider, Icons.tune_rounded),
              const SizedBox(width: 8),
              _buildModeChip('Side-by-Side', ComparisonMode.sideBySide, Icons.view_column_rounded),
              const SizedBox(width: 8),
              _buildModeChip('Original', ComparisonMode.originalOnly, Icons.person_outline),
              const SizedBox(width: 8),
              _buildModeChip('Styled', ComparisonMode.styledOnly, Icons.auto_awesome_outlined),
            ],
          ),
        ),

        // Main Viewer Frame (14px radius, 1px border, soft shadow)
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
              boxShadow: const [AppTheme.cardShadow],
            ),
            child: _buildComparisonContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildModeChip(String label, ComparisonMode mode, IconData icon) {
    final isSelected = _mode == mode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _mode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: const Cubic(0.22, 1, 0.36, 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.deepEmerald
              : (isDark ? AppTheme.darkCard : AppTheme.cardWhite),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.deepEmerald
                : (isDark ? AppTheme.darkBorder : AppTheme.borderIvory),
            width: 1,
          ),
          boxShadow: isSelected ? const [AppTheme.subtleShadow] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : (isDark ? AppTheme.darkTextSecondary : AppTheme.slate),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : (isDark ? AppTheme.darkTextSecondary : AppTheme.slate),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonContent() {
    switch (_mode) {
      case ComparisonMode.originalOnly:
        return Stack(
          fit: StackFit.expand,
          children: [
            widget.beforeWidget,
            _buildBadge(widget.beforeLabel, isLeft: true),
          ],
        );
      case ComparisonMode.styledOnly:
        return Stack(
          fit: StackFit.expand,
          children: [
            widget.afterWidget,
            _buildBadge(widget.afterLabel, isLeft: false),
          ],
        );
      case ComparisonMode.sideBySide:
        return Row(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  widget.beforeWidget,
                  _buildBadge(widget.beforeLabel, isLeft: true),
                ],
              ),
            ),
            Container(width: 2, color: AppTheme.deepEmerald),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  widget.afterWidget,
                  _buildBadge(widget.afterLabel, isLeft: false),
                ],
              ),
            ),
          ],
        );
      case ComparisonMode.slider:
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            final splitDx = width * _position;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (details) => _onPanUpdate(details, width),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Layer 1: After Widget (Styled) in full width
                  widget.afterWidget,

                  // Layer 2: Before Widget (Original) clipped to splitDx
                  ClipRect(
                    clipper: _LeftSplitClipper(splitDx),
                    child: widget.beforeWidget,
                  ),

                  // Divider Line
                  Positioned(
                    left: splitDx - 1.5,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Grab Handle in center (tactile circular button with emerald icon)
                  Positioned(
                    left: splitDx - 17,
                    top: (height / 2) - 17,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.deepEmerald, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.swap_horiz_rounded,
                          size: 20,
                          color: AppTheme.deepEmerald,
                        ),
                      ),
                    ),
                  ),

                  // Badges
                  _buildBadge(widget.beforeLabel, isLeft: true),
                  _buildBadge(widget.afterLabel, isLeft: false),
                ],
              ),
            );
          },
        );
    }
  }

  Widget _buildBadge(String text, {required bool isLeft}) {
    return Positioned(
      bottom: 12,
      left: isLeft ? 12 : null,
      right: isLeft ? null : 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.inkNavy.withOpacity(0.85),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isLeft ? Colors.white24 : AppTheme.copper.withOpacity(0.7),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isLeft ? Colors.white70 : AppTheme.copper,
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _LeftSplitClipper extends CustomClipper<Rect> {
  final double splitX;
  _LeftSplitClipper(this.splitX);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, splitX, size.height);
  }

  @override
  bool shouldReclip(_LeftSplitClipper oldClipper) => oldClipper.splitX != splitX;
}
