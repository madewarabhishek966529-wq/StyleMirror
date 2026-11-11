import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/style_catalog_data.dart';
import '../models/face_profile_model.dart';
import '../models/style_model.dart';
import '../widgets/face_analysis_dialog.dart';
import '../widgets/style_card.dart';

/// Screen 4: Home Dashboard — Personalized AI Grooming Dashboard
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
    // Get recommendations matching current face shape
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryAccent.withOpacity(0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.content_cut, color: AppTheme.primaryAccent, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('StyleMirror'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.face_retouching_natural, color: AppTheme.primaryAccent),
            tooltip: 'Analyze Face',
            onPressed: () => FaceAnalysisDialog.show(context, onProfileUpdated: onProfileUpdated),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.cardBackground,
              backgroundImage: const AssetImage('assets/portraits/model_1.jpg'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Personalized Greeting
            const Text(
              'Good evening, Alex',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your facial features are calibrated for precision styling.',
              style: TextStyle(fontSize: 13, color: AppTheme.secondaryText),
            ),
            const SizedBox(height: 18),

            // 2. My Face Profile Card (Critical Screen Component)
            _buildFaceProfileCard(context),
            const SizedBox(height: 20),

            // 3. Quick Try-On Banner
            _buildQuickTryOnBanner(),
            const SizedBox(height: 24),

            // 4. Recommended Hairstyles for Face Shape
            _buildSectionHeader(
              title: 'Recommended Hairstyles for ${faceProfile.faceShape} Face',
              actionLabel: 'See All',
              onAction: onNavigateToExplore,
            ),
            const SizedBox(height: 12),
            _buildHorizontalStyleList(recommendedHair.isNotEmpty ? recommendedHair : popularHair),
            const SizedBox(height: 24),

            // 5. Recommended Beard Styles for Face Shape
            _buildSectionHeader(
              title: 'Recommended Beard Styles',
              actionLabel: 'See All',
              onAction: onNavigateToExplore,
            ),
            const SizedBox(height: 12),
            _buildHorizontalStyleList(recommendedBeard.isNotEmpty ? recommendedBeard : trendingBeards),
            const SizedBox(height: 24),

            // 6. Popular Cuts & Trending Grooming
            _buildSectionHeader(title: 'Trending Men\'s Barber Cuts', actionLabel: 'Explore (50)', onAction: onNavigateToExplore),
            const SizedBox(height: 12),
            _buildHorizontalStyleList(popularHair),
            const SizedBox(height: 24),

            // 7. Daily Grooming Tip Card
            _buildDailyGroomingTip(),
            const SizedBox(height: 24),

            // 8. Recent Style Transformation History
            _buildRecentHistoryCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryAccent.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified, color: AppTheme.primaryAccent, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'MY FACE PROFILE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryAccent,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => FaceAnalysisDialog.show(context, onProfileUpdated: onProfileUpdated),
                child: const Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 14, color: AppTheme.secondaryAccent),
                    SizedBox(width: 4),
                    Text('Re-Analyze', style: TextStyle(fontSize: 12, color: AppTheme.secondaryAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/portraits/model_1.jpg',
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${faceProfile.faceShape} Face Shape',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${faceProfile.proportions} • ${faceProfile.jawline}',
                      style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
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

  Widget _buildQuickTryOnBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryAccent.withOpacity(0.22),
            AppTheme.secondaryAccent.withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryAccent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Virtual AI Try-On Studio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Simulate 25 haircuts & 25 beards on your face in real-time.',
                  style: TextStyle(fontSize: 12, color: AppTheme.secondaryText, height: 1.3),
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
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/portraits/transform_after_1.jpg',
              width: 90,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String actionLabel, required VoidCallback onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Row(
            children: [
              Text(actionLabel, style: const TextStyle(fontSize: 12, color: AppTheme.primaryAccent, fontWeight: FontWeight.w600)),
              const Icon(Icons.chevron_right, size: 16, color: AppTheme.primaryAccent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalStyleList(List<StyleModel> styles) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: styles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final item = styles[i];
          return SizedBox(
            width: 155,
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

  Widget _buildDailyGroomingTip() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.secondaryAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lightbulb_outline, color: AppTheme.secondaryAccent, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Barber Tip of the Day',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.secondaryAccent),
                ),
                SizedBox(height: 4),
                Text(
                  'Map your neckline 2 fingers above the Adam\'s apple. Trimming too high weakens jaw definition.',
                  style: TextStyle(fontSize: 12, color: AppTheme.secondaryText, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/portraits/transform_after_2.jpg', width: 48, height: 48, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Simulation', style: TextStyle(fontSize: 10, color: AppTheme.secondaryText, fontWeight: FontWeight.bold)),
                Text('French Crop (H03) + Short Beard', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Yesterday, 8:45 PM • 95% Match', style: TextStyle(fontSize: 11, color: AppTheme.primaryAccent)),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            onPressed: onNavigateToTryOn,
            child: const Text('Reuse', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
