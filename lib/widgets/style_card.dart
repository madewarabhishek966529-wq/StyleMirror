import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/style_model.dart';

/// Interactive card component for selecting a Hairstyle or Beard style
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
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceElevated : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryLight : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: ID badge + category + selection indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : AppTheme.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.border, width: 0.5),
                    ),
                    child: Text(
                      style.id,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    )
                  else
                    Icon(
                      style.isHair ? Icons.face : Icons.mood,
                      size: 18,
                      color: AppTheme.textMuted,
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Visual style image with high-definition thumbnail
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Thumbnail image loaded from asset
                      Image.asset(
                        style.assetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isSelected
                                    ? [
                                        AppTheme.primary.withOpacity(0.2),
                                        AppTheme.accentCyan.withOpacity(0.1),
                                      ]
                                    : [
                                        AppTheme.background,
                                        AppTheme.surfaceElevated,
                                      ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                style.isHair ? Icons.content_cut : Icons.brush,
                                size: 36,
                                color: isSelected ? AppTheme.primaryLight : AppTheme.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),

                      // Bottom subtle gradient overlay for contrast
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 38,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.75),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Category pill on bottom of thumbnail image
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
                          ),
                          child: Text(
                            style.category,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Style name
              Text(
                style.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Prompt hint summary
              Text(
                style.promptHint,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

