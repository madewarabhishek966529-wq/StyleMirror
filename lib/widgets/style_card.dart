import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/style_model.dart';

/// StyleCard: 14px radius card with 1px border, emerald active state & copper compatibility pill
class StyleCard extends StatelessWidget {
  final StyleModel style;
  final bool isSelected;
  final VoidCallback onSelect;

  const StyleCard({
    super.key,
    required this.style,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final borderColor = isSelected
        ? AppTheme.deepEmerald
        : (isDark ? AppTheme.darkBorder : AppTheme.borderIvory);
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;

    // Compatibility pill text
    final compatibilityText = style.isHair ? 'Best for Oval & Square' : 'Universal Match';

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: const Cubic(0.22, 1, 0.36, 1),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.deepEmerald.withOpacity(0.2),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [AppTheme.subtleShadow],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: ID chip + Selection Check Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.deepEmerald
                          : (isDark ? AppTheme.darkBackground : AppTheme.ivoryBackground),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? AppTheme.deepEmerald : (isDark ? AppTheme.darkBorder : AppTheme.borderIvory),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      style.id,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : primaryTextColor,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppTheme.deepEmerald,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 13,
                        color: Colors.white,
                      ),
                    )
                  else
                    Icon(
                      style.isHair ? Icons.content_cut : Icons.brush,
                      size: 15,
                      color: secondaryTextColor,
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Image Thumbnail
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        style.assetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: isDark ? AppTheme.darkBackground : AppTheme.ivoryBackground,
                          child: Center(
                            child: Icon(
                              style.isHair ? Icons.face : Icons.brush,
                              size: 28,
                              color: secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                      // Bottom gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 32,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.65),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Category Tag
                      Positioned(
                        bottom: 4,
                        left: 6,
                        child: Text(
                          style.category,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Style Name
              Text(
                style.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: primaryTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),

              // Copper Compatibility Pill ("Best for oval/square")
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.copper.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  compatibilityText,
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.copper,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
