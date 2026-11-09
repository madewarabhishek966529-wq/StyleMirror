import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Modal dialog ensuring legal compliance and explicit user consent
/// according to docs/08_SECURITY_PRIVACY.md
class ConsentDialog extends StatefulWidget {
  final VoidCallback onAccepted;

  const ConsentDialog({super.key, required this.onAccepted});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConsentDialog(
        onAccepted: () => Navigator.of(context).pop(true),
      ),
    );
  }

  @override
  State<ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  bool _isOwnPhoto = false;
  bool _agreeProcessing = false;

  bool get _canProceed => _isOwnPhoto && _agreeProcessing;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.border, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    color: AppTheme.primaryLight,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Privacy & Consent',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'StyleMirror AI Safety Standards',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Highlight info box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock_clock_outlined, size: 16, color: AppTheme.accentCyan),
                      SizedBox(width: 8),
                      Text(
                        '24-Hour Auto-Deletion',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentCyan,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Your photo and all generated looks are automatically purged after 24 hours. You can also delete everything immediately with one tap at any time.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Checkbox 1
            InkWell(
              onTap: () => setState(() => _isOwnPhoto = !_isOwnPhoto),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isOwnPhoto,
                      activeColor: AppTheme.primary,
                      onChanged: (val) => setState(() => _isOwnPhoto = val ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'This is my own photograph (or I have explicit consent to use it).',
                        style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Checkbox 2
            InkWell(
              onTap: () => setState(() => _agreeProcessing = !_agreeProcessing),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Checkbox(
                      value: _agreeProcessing,
                      activeColor: AppTheme.primary,
                      onChanged: (val) => setState(() => _agreeProcessing = val ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'I agree to photo processing for hairstyle & beard preview. My photo will NEVER be used to train AI models.',
                        style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceed ? widget.onAccepted : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canProceed ? AppTheme.primary : AppTheme.surfaceElevated,
                    ),
                    child: const Text('Proceed'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

