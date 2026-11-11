import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/grooming_guide_data.dart';
import '../models/face_profile_model.dart';
import '../models/grooming_guide_model.dart';
import '../widgets/face_analysis_dialog.dart';
import 'privacy_screen.dart';

/// Screen 13: Profile & Settings + Screen 11: Grooming Guide Hub
class ProfileScreen extends StatefulWidget {
  final FaceProfile faceProfile;
  final ValueChanged<FaceProfile> onProfileUpdated;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const ProfileScreen({
    super.key,
    required this.faceProfile,
    required this.onProfileUpdated,
    required this.onThemeToggle,
    this.isDarkMode = true,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _openArticleDetails(GroomingArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: AppTheme.border),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        avatar: Icon(article.icon, size: 14, color: AppTheme.primaryAccent),
                        label: Text(article.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      Text(article.readTime, style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.summary,
                    style: const TextStyle(fontSize: 13, color: AppTheme.secondaryText, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  const Text('Key Barber Rules:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.secondaryAccent)),
                  const SizedBox(height: 8),
                  for (final tip in article.keyTips)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: AppTheme.success),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(tip, style: const TextStyle(fontSize: 12, color: Colors.white, height: 1.4)),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                  const Text('Deep Dive Guide:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(
                    article.fullContent,
                    style: const TextStyle(fontSize: 13, color: AppTheme.secondaryText, height: 1.5),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Grooming Guide'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/portraits/model_1.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alex Vance',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'alex.vance@example.com',
                          style: TextStyle(fontSize: 12, color: AppTheme.secondaryText),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryAccent.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'StyleMirror Pro Member',
                            style: TextStyle(fontSize: 10, color: AppTheme.primaryAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // My Face Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Face Analysis Profile',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () => FaceAnalysisDialog.show(context, onProfileUpdated: widget.onProfileUpdated),
                        child: const Text('Update', style: TextStyle(color: AppTheme.primaryAccent, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        avatar: const Icon(Icons.face, size: 14, color: AppTheme.primaryAccent),
                        label: Text('${widget.faceProfile.faceShape} Shape'),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        avatar: const Icon(Icons.architecture, size: 14, color: AppTheme.secondaryAccent),
                        label: Text(widget.faceProfile.jawline.split('&').first.trim()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grooming Guide Section (Screen 11)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Men\'s Grooming Guide',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '${GroomingGuideData.articles.length} Articles',
                  style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText),
                ),
              ],
            ),
            const SizedBox(height: 12),

            for (final article in GroomingGuideData.articles)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => _openArticleDetails(article),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(article.icon, color: AppTheme.primaryAccent, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(article.category, style: const TextStyle(fontSize: 10, color: AppTheme.secondaryAccent, fontWeight: FontWeight.bold)),
                                  Text(article.readTime, style: const TextStyle(fontSize: 10, color: AppTheme.secondaryText)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(article.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 2),
                              Text(
                                article.summary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: AppTheme.secondaryText),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Settings & Privacy Controls
            const Text(
              'Settings & Security',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            Material(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  children: [
                  ListTile(
                    leading: const Icon(Icons.shield_outlined, color: AppTheme.primaryAccent),
                    title: const Text('Privacy & Security Commitments', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Zero AI training, 24h purge & data deletion', style: TextStyle(fontSize: 11, color: AppTheme.secondaryText)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.secondaryText),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyScreen()));
                    },
                  ),
                  const Divider(color: AppTheme.border, height: 1),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_outlined, color: AppTheme.secondaryAccent),
                    title: const Text('Appearance', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text(widget.isDarkMode ? 'Dark Theme (Obsidian)' : 'Light Theme', style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText)),
                    trailing: Switch(
                      value: widget.isDarkMode,
                      activeColor: AppTheme.primaryAccent,
                      onChanged: (_) => widget.onThemeToggle(),
                    ),
                  ),
                  const Divider(color: AppTheme.border, height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined, color: AppTheme.secondaryText),
                    title: const Text('Grooming Reminders', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Bi-weekly haircut & beard trim notifications', style: TextStyle(fontSize: 11, color: AppTheme.secondaryText)),
                    trailing: Switch(
                      value: true,
                      activeColor: AppTheme.primaryAccent,
                      onChanged: (_) {},
                    ),
                  ),
                  const Divider(color: AppTheme.border, height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppTheme.error),
                    title: const Text('Log Out', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.error)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out of StyleMirror.')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
            const SizedBox(height: 24),

            // App Version
            const Center(
              child: Text(
                'StyleMirror v1.0.0 • AI Barber Grooming Companion',
                style: TextStyle(fontSize: 11, color: AppTheme.secondaryText),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
