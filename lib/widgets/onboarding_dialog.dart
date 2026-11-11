import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Screen 2: 3-step Onboarding Workflow
class OnboardingDialog extends StatefulWidget {
  final VoidCallback onFinished;

  const OnboardingDialog({super.key, required this.onFinished});

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onFinished,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: OnboardingDialog(onFinished: onFinished),
      ),
    );
  }

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Discover Your Perfect Hairstyle',
      'tagline': 'AI-Powered Precision Cuts',
      'description': 'Analyze your unique bone structure and facial proportions to find haircuts tailored specifically for your face shape.',
      'icon': Icons.content_cut,
      'image': 'assets/portraits/transform_after_1.jpg',
    },
    {
      'title': 'Find Your Perfect Beard',
      'tagline': 'Sculpted Facial Hair',
      'description': 'From clean shaves to stubbles, boxed beards and goatees, see which beard density and neckline suits your jaw.',
      'icon': Icons.brush,
      'image': 'assets/portraits/transform_after_3.jpg',
    },
    {
      'title': 'Try Before You Choose',
      'tagline': 'Photorealistic Virtual Try-On',
      'description': 'Preview 50 premium styles composited on your authentic face with 100% identity preservation before your next barber visit.',
      'icon': Icons.auto_awesome,
      'image': 'assets/portraits/transform_after_2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentIndex];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.borderHighlight.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryAccent.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row with skip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.content_cut,
                      color: AppTheme.primaryAccent,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'StyleMirror',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onFinished();
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: AppTheme.secondaryText, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Central Preview Photo Frame
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 240,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    page['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.face,
                        size: 64,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ),
                  DecoratedBox(
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
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        page['tagline'] as String,
                        style: const TextStyle(
                          color: AppTheme.background,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title & Description
          Text(
            page['title'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            page['description'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.secondaryText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _pages.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == i ? 24 : 8,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == i
                        ? AppTheme.primaryAccent
                        : AppTheme.secondaryText.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Next / Get Started CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_currentIndex < _pages.length - 1) {
                  setState(() => _currentIndex++);
                } else {
                  Navigator.pop(context);
                  widget.onFinished();
                }
              },
              child: Text(
                _currentIndex < _pages.length - 1 ? 'Next' : 'Get Started',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
