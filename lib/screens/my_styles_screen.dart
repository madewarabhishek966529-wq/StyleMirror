import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/face_profile_model.dart';
import '../models/style_model.dart';

/// Screen 10: My Styles — Saved Looks, Try-On Previews & Barber Consultation Export
class MyStylesScreen extends StatefulWidget {
  final FaceProfile faceProfile;
  final ValueChanged<StyleModel> onStyleSelected;
  final VoidCallback onNavigateToTryOn;

  const MyStylesScreen({
    super.key,
    required this.faceProfile,
    required this.onStyleSelected,
    required this.onNavigateToTryOn,
  });

  @override
  State<MyStylesScreen> createState() => _MyStylesScreenState();
}

class _MyStylesScreenState extends State<MyStylesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _savedLooks = [
    {
      'id': 'look_01',
      'title': 'Textured Crew Cut & Faded Jaw',
      'styleId': 'H01',
      'specs': 'Guard #1.5 Skin Fade • 4mm Stubble',
      'match': '98% Match',
      'date': 'Yesterday, 8:45 PM',
      'image': 'assets/portraits/transform_after_1.jpg',
      'isFavorite': true,
      'isHair': true,
    },
    {
      'id': 'look_02',
      'title': 'Short Boxed Beard Contour',
      'styleId': 'B05',
      'specs': 'Sculpted Cheek Line • 8mm Baseline',
      'match': '96% Match',
      'date': 'Oct 22, 2026',
      'image': 'assets/portraits/transform_after_3.jpg',
      'isFavorite': true,
      'isHair': false,
    },
    {
      'id': 'look_03',
      'title': 'French Crop with Textured Fringe',
      'styleId': 'H03',
      'specs': 'Mid Temple Taper • Scissor Crop',
      'match': '95% Match',
      'date': 'Oct 18, 2026',
      'image': 'assets/portraits/transform_after_2.jpg',
      'isFavorite': false,
      'isHair': true,
    },
    {
      'id': 'look_04',
      'title': 'Mid Skin Taper & Designer Stubble',
      'styleId': 'H12',
      'specs': 'Zero Neck Taper • 2.5mm Shadow',
      'match': '99% Match',
      'date': 'Oct 14, 2026',
      'image': 'assets/portraits/transform_after_1.jpg',
      'isFavorite': true,
      'isHair': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showBarberCardDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppTheme.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.content_cut, color: AppTheme.primaryAccent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Barber Consultation Card',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.secondaryText, size: 18),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Show this directly to your barber for exact clipper guard lengths & angles:',
                style: TextStyle(fontSize: 12, color: AppTheme.secondaryText),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HAIRCUT SPECIFICATION:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryAccent)),
                    SizedBox(height: 4),
                    Text('• Sides & Back: Mid Skin Fade (#1.5 into #2 guard)', style: TextStyle(fontSize: 12, color: Colors.white)),
                    Text('• Crown & Top: 2 inches point-cut with textured fringe', style: TextStyle(fontSize: 12, color: Colors.white)),
                    Divider(color: AppTheme.border, height: 16),
                    Text('BEARD SPECIFICATION:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondaryAccent)),
                    SizedBox(height: 4),
                    Text('• Length: 6mm clipper baseline', style: TextStyle(fontSize: 12, color: Colors.white)),
                    Text('• Neckline: 2 fingers above Adam\'s apple, U-shaped', style: TextStyle(fontSize: 12, color: Colors.white)),
                    Text('• Cheekline: Natural fade; line up sideburn connection', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppTheme.success,
                        content: Text('✓ Barber Consultation Card saved to device.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Save Card to Photos'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteLook(int index) {
    setState(() {
      _savedLooks.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Look removed from vault.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Styles Vault'),
        actions: [
          TextButton.icon(
            onPressed: _showBarberCardDialog,
            icon: const Icon(Icons.share, size: 16, color: AppTheme.primaryAccent),
            label: const Text('Barber Card', style: TextStyle(fontSize: 12, color: AppTheme.primaryAccent, fontWeight: FontWeight.bold)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Virtual Previews (4)'),
            Tab(text: 'Hairstyles (3)'),
            Tab(text: 'Beard Styles (2)'),
            Tab(text: 'Favorites (3)'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Biometric Vault Metrics Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            color: AppTheme.cardBackground,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryAccent.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified, color: AppTheme.primaryAccent, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_savedLooks.length} Stored Looks • ${widget.faceProfile.faceShape} Biometrics',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                InkWell(
                  onTap: _showBarberCardDialog,
                  child: const Row(
                    children: [
                      Icon(Icons.print_outlined, size: 14, color: AppTheme.secondaryAccent),
                      SizedBox(width: 4),
                      Text('Export', style: TextStyle(fontSize: 11, color: AppTheme.secondaryAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.border, height: 1),

          // Saved Looks Grid
          Expanded(
            child: _savedLooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bookmark_outline, size: 48, color: AppTheme.secondaryText),
                        const SizedBox(height: 12),
                        const Text('No saved looks yet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('Try on styles and save your favorites here', style: TextStyle(color: AppTheme.secondaryText, fontSize: 12)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: widget.onNavigateToTryOn,
                          child: const Text('Try on a Style'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: _savedLooks.length,
                    itemBuilder: (context, i) {
                      final item = _savedLooks[i];
                      return _buildSavedLookCard(item, i);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedLookCard(Map<String, dynamic> item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.person, size: 48)),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['match'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: Icon(
                        item['isFavorite'] == true ? Icons.favorite : Icons.favorite_border,
                        color: item['isFavorite'] == true ? AppTheme.primaryAccent : Colors.white70,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          item['isFavorite'] = !(item['isFavorite'] == true);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  item['specs'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppTheme.secondaryAccent),
                ),
                const SizedBox(height: 2),
                Text(
                  item['date'] as String,
                  style: const TextStyle(fontSize: 9, color: AppTheme.secondaryText),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: widget.onNavigateToTryOn,
                        child: const Text('Try On', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 16, color: AppTheme.error),
                      onPressed: () => _deleteLook(index),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
