import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// DartNova-inspired Bento Card:
/// Modular, high-end card with icon, title, description, and subtle ambient hover/press state.
class BentoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? badgeText;
  final VoidCallback? onTap;
  final Color? accentColor;

  const BentoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.badgeText,
    this.onTap,
    this.accentColor,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;
    final accent = widget.accentColor ?? AppTheme.deepEmerald;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: _isHovered ? Matrix4.translationValues(0, -2, 0) : Matrix4.identity(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered ? accent.withOpacity(0.5) : borderColor,
              width: 1.0,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: accent.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              else
                AppTheme.subtleShadow,
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.icon, size: 18, color: accent),
                  ),
                  if (widget.badgeText != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.badgeText!,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: accent,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 10,
                  color: textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
