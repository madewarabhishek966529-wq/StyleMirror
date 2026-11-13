import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/style_catalog_data.dart';
import '../models/face_profile_model.dart';
import '../models/style_model.dart';
import '../widgets/border_beam_button.dart';
import '../widgets/face_analysis_dialog.dart';
import '../widgets/neon_flicker_text.dart';
import '../widgets/style_card.dart';

/// Screen 1 & 4: Landing Page & Personalized Barbershop Dashboard
/// Design System: Warm Ivory (#F7F5F0), Ink Navy (#0F1B2D), Deep Emerald (#0F766E), Copper (#B5733A)
class DashboardScreen extends StatelessWidget {
  final FaceProfile faceProfile;
  final ValueChanged<FaceProfile> onProfileUpdated;
  final ValueChanged<StyleModel> onStyleSelected;
  final VoidCallback onNavigateToTryOn;
  final VoidCallback onNavigateToExplore;

  const DashboardScreen({
    super.key,
    required this.faceProfile,
    required this.onProfileUpdated,
    required this.onStyleSelected,
    required this.onNavigateToTryOn,
    required this.onNavigateToExplore,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;
    final cardBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;

    // Filter styles matching current face shape
    final recommendedHair = StyleCatalogData.hairstyles
        .where((s) => faceProfile.recommendedHairStyleIds.contains(s.id))
        .toList();
    final recommendedBeard = StyleCatalogData.beardStyles
        .where((s) => faceProfile.recommendedBeardStyleIds.contains(s.id))
        .toList();

    final popularHair = StyleCatalogData.hairstyles.take(4).toList();
    final trendingBeards = StyleCatalogData.beardStyles.take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: const NeonFlickerText(
          text: 'StyleMirror',
          fontSize: 20,
        ),
        actions: [
          TextButton(
            onPressed: onNavigateToExplore,
            child: Text('Styles', style: TextStyle(color: secondaryTextColor, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: onNavigateToTryOn,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            child: const Text('Try Now'),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.face_retouching_natural, color: AppTheme.deepEmerald),
            tooltip: 'Analyze Face',
            onPressed: () => FaceAnalysisDialog.show(context, onProfileUpdated: onProfileUpdated),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: cardBg,
              backgroundImage: const AssetImage('assets/portraits/model_1.jpg'),
            ),
          ),
        ],
      ),
      floatingActionButton: BorderBeamButton(
        size: 58,
        tooltip: 'Try On',
        onTap: onNavigateToTryOn,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. HERO SECTION: "See the cut before you commit." (Image 2) ---
            _buildHeroSection(context, primaryTextColor, secondaryTextColor, cardBg, borderColor),
            const SizedBox(height: 24),

            // --- 2. 3-FEATURE VALUE ROW (Image 2) ---
            _buildFeatureRow(context, primaryTextColor, secondaryTextColor, cardBg, borderColor),
            const SizedBox(height: 24),

            // --- 3. READY TO STYLE YOUR LOOK CARD (Image 1 from user mockup) ---
            _buildReadyToStyleCard(context, primaryTextColor, secondaryTextColor, cardBg, borderColor),
            const SizedBox(height: 28),

            // --- 4. 3-STEP "HOW IT WORKS" SEQUENCE ---
            _buildHowItWorks(context, primaryTextColor, secondaryTextColor, cardBg, borderColor),
            const SizedBox(height: 28),

            // --- 5. MY FACE PROFILE CARD (Critical Biometric Component) ---
            _buildFaceProfileCard(context, primaryTextColor, secondaryTextColor, cardBg, borderColor),
            const SizedBox(height: 20),

            // --- 6. VIRTUAL TRY-ON STUDIO QUICK BANNER ---
            _buildQuickTryOnBanner(primaryTextColor, secondaryTextColor),
            const SizedBox(height: 28),

            // --- 7. RECOMMENDED HAIRSTYLES FOR FACE SHAPE ---
            _buildSectionHeader(
              title: 'Recommended Hairstyles for ${faceProfile.faceShape} Face',
              actionLabel: 'See All (25)',
              primaryTextColor: primaryTextColor,
              onAction: onNavigateToExplore,
            ),
            const SizedBox(height: 12),
            _buildHorizontalStyleList(recommendedHair.isNotEmpty ? recommendedHair : popularHair),
            const SizedBox(height: 28),

            // --- 8. RECOMMENDED BEARD STYLES FOR FACE SHAPE ---
            _buildSectionHeader(
              title: 'Recommended Beard Styles',
              actionLabel: 'See All (25)',
              primaryTextColor: primaryTextColor,
              onAction: onNavigateToExplore,
            ),
            const SizedBox(height: 12),
            _buildHorizontalStyleList(recommendedBeard.isNotEmpty ? recommendedBeard : trendingBeards),
            const SizedBox(height: 28),

            // --- 9. TRENDING MEN'S BARBER CUTS ---
            _buildSectionHeader(
              title: 'Trending Men\'s Barber Cuts',
              actionLabel: 'Explore (50)',
              primaryTextColor: primaryTextColor,
              onAction: onNavigateToExplore,
            ),
            const SizedBox(height: 12),
            _buildHorizontalStyleList(popularHair),
            const SizedBox(height: 24),

            // --- 10. BARBER TIP OF THE DAY ---
            _buildDailyGroomingTip(primaryTextColor, secondaryTextColor, cardBg, borderColor),
            const SizedBox(height: 20),

            // --- 11. RECENT SIMULATION HISTORY ---
            _buildRecentHistoryCard(primaryTextColor, secondaryTextColor, cardBg, borderColor),
            const SizedBox(height: 32),

            // --- 12. EDITORIAL FOOTER ---
            _buildFooter(secondaryTextColor),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, Color textPrimary, Color textSecondary, Color cardBg, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: borderColor),
        boxShadow: const [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Copper Subtitle Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.copper.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'HIGH-END BARBERSHOP AI STUDIO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.copper,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Main Headline (Playfair / Serif style)
          Text(
            'See the cut before you commit.',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: textPrimary,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'A clean modern SaaS virtual try-on crafted for men. Preview authentic haircuts and beards on your own face with precise barber clipper guard specs before visiting your barber.',
            style: TextStyle(
              fontSize: 13,
              color: textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),

          // Hero Split Preview Card
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/portraits/transform_before_1.jpg',
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        'assets/portraits/transform_after_1.jpg',
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.inkNavy.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('BEFORE: Natural Cut', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.deepEmerald.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('AFTER: Textured Crop (H03)', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Action Buttons with Wrap to prevent right-overflow on narrow screens
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: onNavigateToTryOn,
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Start Virtual Try-On'),
              ),
              OutlinedButton(
                onPressed: onNavigateToExplore,
                child: const Text('Browse 50 Styles'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, Color textPrimary, Color textSecondary, Color cardBg, Color borderColor) {
    return Row(
      children: [
        _buildFeatureItem(
          icon: Icons.shield_outlined,
          title: 'Identity Preserved',
          desc: 'Bone structure & skin stay authentic',
          cardBg: cardBg,
          borderColor: borderColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(width: 10),
        _buildFeatureItem(
          icon: Icons.content_cut,
          title: '50 Barber Styles',
          desc: 'Clipper guard numbers & lengths',
          cardBg: cardBg,
          borderColor: borderColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
        const SizedBox(width: 10),
        _buildFeatureItem(
          icon: Icons.timer_outlined,
          title: 'Auto-Delete in 24h',
          desc: 'Zero AI training & instant wipe',
          cardBg: cardBg,
          borderColor: borderColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
      ],
    );
  }

  /// Ready to Style Your Look Card (from User Mockup Image 1)
  Widget _buildReadyToStyleCard(BuildContext context, Color textPrimary, Color textSecondary, Color cardBg, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: borderColor),
        boxShadow: const [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.deepEmerald.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.style, color: AppTheme.deepEmerald, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            'Ready to Style Your Look?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose from 25 haircuts and 25 beard trims tailored to your face shape.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: textSecondary, height: 1.4),
          ),
          const SizedBox(height: 18),

          // Button 1: Capture / Choose Selfie
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNavigateToTryOn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.deepEmerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.camera_alt_outlined, size: 18, color: Colors.white),
              label: const Text(
                'Capture / Choose Selfie',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Button 2: Continue: Choose What to Style (Hair or Beard) ->
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onNavigateToTryOn,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.deepEmerald.withOpacity(0.4), width: 1.2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.arrow_forward, size: 16, color: AppTheme.deepEmerald),
              label: const Text(
                'Continue: Choose What to Style (Hair or Beard) ➔',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.deepEmerald),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Button 3: Let's Start: Style Hair & Beard
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onNavigateToTryOn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.deepEmerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 4,
              ),
              icon: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
              label: const Text(
                "Let's Start: Style Hair & Beard",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String desc,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: const [AppTheme.subtleShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppTheme.deepEmerald),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
            const SizedBox(height: 2),
            Text(desc, style: TextStyle(fontSize: 10, color: textSecondary, height: 1.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorks(BuildContext context, Color textPrimary, Color textSecondary, Color cardBg, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: borderColor),
        boxShadow: const [AppTheme.subtleShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How It Works',
                style: TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const Text('3 SIMPLE STEPS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.copper)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepItem('1', 'Upload', 'Frontal selfie with natural lighting', textPrimary, textSecondary),
              const SizedBox(width: 8),
              _buildStepItem('2', 'Choose', 'Pick from 25 cuts & 25 beards', textPrimary, textSecondary),
              const SizedBox(width: 8),
              _buildStepItem('3', 'Preview', 'Split comparison & barber specs', textPrimary, textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String step, String title, String desc, Color textPrimary, Color textSecondary) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppTheme.deepEmerald,
              shape: BoxShape.circle,
            ),
            child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(fontSize: 10, color: textSecondary, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceProfileCard(BuildContext context, Color textPrimary, Color textSecondary, Color cardBg, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: borderColor),
        boxShadow: const [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppTheme.deepEmerald.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified, color: AppTheme.deepEmerald, size: 14),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'MY FACE PROFILE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.deepEmerald,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => FaceAnalysisDialog.show(context, onProfileUpdated: onProfileUpdated),
                child: const Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 14, color: AppTheme.copper),
                    SizedBox(width: 4),
                    Text('Re-Analyze', style: TextStyle(fontSize: 12, color: AppTheme.copper, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 58,
                  height: 58,
                  child: Image.asset(
                    'assets/portraits/model_1.jpg',
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${faceProfile.faceShape} Face Shape',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${faceProfile.proportions} • ${faceProfile.jawline}',
                      style: TextStyle(fontSize: 11, color: textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '✓ Biometrics Active & Preserved',
                        style: TextStyle(fontSize: 9, color: AppTheme.success, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTryOnBanner(Color textPrimary, Color textSecondary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.deepEmerald.withOpacity(0.06),
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: AppTheme.deepEmerald.withOpacity(0.24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Virtual AI Try-On Studio',
                  style: TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Simulate 25 haircuts & 25 beards on your face in real-time with identity preservation.',
                  style: TextStyle(fontSize: 12, color: textSecondary, height: 1.3),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: onNavigateToTryOn,
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Launch Try-On'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 86,
              height: 104,
              child: Image.asset(
                'assets/portraits/transform_after_1.jpg',
                width: 86,
                height: 104,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionLabel,
    required Color primaryTextColor,
    required VoidCallback onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold, color: primaryTextColor),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Row(
            children: [
              Text(actionLabel, style: const TextStyle(fontSize: 12, color: AppTheme.deepEmerald, fontWeight: FontWeight.w600)),
              const Icon(Icons.chevron_right, size: 16, color: AppTheme.deepEmerald),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalStyleList(List<StyleModel> styles) {
    return SizedBox(
      height: 236,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: styles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final item = styles[i];
          return SizedBox(
            width: 160,
            child: StyleCard(
              style: item,
              isSelected: false,
              onSelect: () => onStyleSelected(item),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyGroomingTip(Color textPrimary, Color textSecondary, Color cardBg, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: borderColor),
        boxShadow: const [AppTheme.subtleShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.copper.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lightbulb_outline, color: AppTheme.copper, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Barber Tip of the Day',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.copper),
                ),
                const SizedBox(height: 4),
                Text(
                  'Map your neckline 2 fingers above the Adam\'s apple. Trimming too high weakens jaw definition.',
                  style: TextStyle(fontSize: 12, color: textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentHistoryCard(Color textPrimary, Color textSecondary, Color cardBg, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: borderColor),
        boxShadow: const [AppTheme.subtleShadow],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Image.asset('assets/portraits/transform_after_2.jpg', width: 48, height: 48, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Simulation', style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.bold)),
                Text('French Crop (H03) + Short Beard', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
                const Text('Yesterday, 8:45 PM • 95% Match', style: TextStyle(fontSize: 11, color: AppTheme.deepEmerald, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: onNavigateToTryOn,
            child: const Text('Reuse', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Color textSecondary) {
    return Center(
      child: Column(
        children: [
          Text(
            'StyleMirror • High-End AI Grooming Studio',
            style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Identity preserved • 50 barber styles • 24-hour automated data purge',
            style: TextStyle(fontSize: 10, color: textSecondary.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}
