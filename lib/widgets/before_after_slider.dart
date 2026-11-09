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
    this.beforeLabel = 'ORIGINAL',
    this.afterLabel = 'STYLE PREVIEW',
    this.initialPosition = 0.5,
    this.height,
  });

  /// Factory helper for creating slider from Uint8List memory bytes or fallback widgets
  factory BeforeAfterSlider.fromBytes({
    Key? key,
    required Uint8List? beforeBytes,
    required Uint8List? afterBytes,
    required Widget fallbackBefore,
    required Widget fallbackAfter,
    String beforeLabel = 'ORIGINAL',
    String afterLabel = 'STYLE PREVIEW',
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
  late double _dividerPosition;
  ComparisonMode _mode = ComparisonMode.slider;

  @override
  void initState() {
    super.initState();
    _dividerPosition = widget.initialPosition;
  }

  void _updatePosition(double globalDx, double width) {
    setState(() {
      _dividerPosition = (globalDx / width).clamp(0.01, 0.99);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mode selector chips
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModeChip('Split Slider', ComparisonMode.slider, Icons.compare),
                const SizedBox(width: 8),
                _buildModeChip('Side-by-Side', ComparisonMode.sideBySide, Icons.view_column),
                const SizedBox(width: 8),
                _buildModeChip('Original', ComparisonMode.originalOnly, Icons.person),
                const SizedBox(width: 8),
                _buildModeChip('Styled', ComparisonMode.styledOnly, Icons.auto_awesome),
              ],
            ),
          ),
        ),

        // Main preview container
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: widget.height ?? 380,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.border, width: 1.5),
            ),
            child: _buildComparisonContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildModeChip(String label, ComparisonMode mode, IconData icon) {
    final isSelected = _mode == mode;
    return GestureDetector(
      onTap: () => setState(() => _mode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryLight : AppTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
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
            Container(width: 2, color: AppTheme.border),
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
            final splitDx = width * _dividerPosition;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (details) {
                final localX = details.localPosition.dx;
                _updatePosition(localX, width);
              },
              onTapDown: (details) {
                final localX = details.localPosition.dx;
                _updatePosition(localX, width);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Full Styled After Image (Base)
                  widget.afterWidget,

                  // Clipped Original Before Image (Top Layer)
                  ClipRect(
                    clipper: _LeftSplitClipper(splitDx),
                    child: widget.beforeWidget,
                  ),

                  // Divider Line & Handle
                  Positioned(
                    left: splitDx - 1.5,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Grab Handle in center
                  Positioned(
                    left: splitDx - 18,
                    top: (height / 2) - 18,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.swap_horiz_rounded,
                          size: 22,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),

                  // Labels
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isLeft ? AppTheme.textSecondary.withOpacity(0.4) : AppTheme.primaryLight.withOpacity(0.6),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isLeft ? Colors.white70 : AppTheme.primaryLight,
            fontSize: 10,
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
