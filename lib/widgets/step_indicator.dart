import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Clean 3-step navigation indicator for the Try-On flow
class StepIndicator extends StatelessWidget {
  final int currentStep; // 0: Selfie, 1: Choose Style, 2: Result
  final ValueChanged<int>? onStepTapped;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    const steps = [
      {'num': '1', 'title': 'Selfie'},
      {'num': '2', 'title': 'Choose Look'},
      {'num': '3', 'title': 'Try-On Studio'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
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
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: i < currentStep
                            ? AppTheme.success
                            : (i == currentStep ? AppTheme.primary : AppTheme.surfaceElevated),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: i == currentStep ? AppTheme.primaryLight : AppTheme.border,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: i < currentStep
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : Text(
                                steps[i]['num']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: i == currentStep ? Colors.white : AppTheme.textMuted,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        steps[i]['title']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: i == currentStep ? FontWeight.w700 : FontWeight.w500,
                          color: i == currentStep ? AppTheme.textPrimary : AppTheme.textMuted,
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
                width: 20,
                height: 1,
                color: i < currentStep ? AppTheme.success : AppTheme.border,
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
          ],
        ],
      ),
    );
  }
}
