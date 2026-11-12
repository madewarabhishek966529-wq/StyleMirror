import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Clean 3-step navigation indicator for the Try-On flow with Editorial Barbershop Styling
class StepIndicator extends StatelessWidget {
  final int currentStep; // 0: Selfie, 1: Choose Look, 2: Try-On Studio
  final ValueChanged<int>? onStepTapped;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;

    const steps = [
      {'num': '1', 'title': 'Selfie'},
      {'num': '2', 'title': 'Choose Look'},
      {'num': '3', 'title': 'Try-On Studio'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: const [AppTheme.subtleShadow],
      ),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            Expanded(
              child: GestureDetector(
                onTap: (onStepTapped != null && i <= currentStep)
                    ? () => onStepTapped!(i)
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: i < currentStep
                            ? AppTheme.success
                            : (i == currentStep ? AppTheme.deepEmerald : (isDark ? AppTheme.darkBackground : AppTheme.ivoryBackground)),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: i == currentStep ? AppTheme.deepEmerald : borderColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: i < currentStep
                            ? const Icon(Icons.check, size: 13, color: Colors.white)
                            : Text(
                                steps[i]['num']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: i == currentStep ? Colors.white : secondaryTextColor,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        steps[i]['title']!,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: i == currentStep ? FontWeight.w700 : FontWeight.w500,
                          color: i == currentStep ? primaryTextColor : secondaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (i < steps.length - 1)
              Container(
                width: 16,
                height: 1,
                color: i < currentStep ? AppTheme.deepEmerald : borderColor,
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
          ],
        ],
      ),
    );
  }
}
