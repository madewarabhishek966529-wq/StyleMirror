import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/style_catalog_data.dart';
import '../models/face_profile_model.dart';
import '../models/style_model.dart';
import '../widgets/style_card.dart';

/// Screen 6 & Screen 7: Hairstyle Explorer & Beard Style Explorer
class ExplorerScreen extends StatefulWidget {
  final FaceProfile faceProfile;
  final ValueChanged<StyleModel> onStyleSelected;

  const ExplorerScreen({
    super.key,
    required this.faceProfile,
    required this.onStyleSelected,
  });

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _hairCategory = 'All';
  String _beardCategory = 'All';
  String _selectedFaceShapeFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // 10 Hairstyle categories specified in prompt
  final List<String> _hairCategories = [
    'All',
    'Short Hairstyles',
    'Medium Hairstyles',
    'Long Hairstyles',
    'Fade Hairstyles',
    'Undercut',
    'Textured Hairstyles',
    'Curly Hairstyles',
    'Wavy Hairstyles',
    'Professional Hairstyles',
    'Modern Hairstyles',
  ];

  // 11 Beard categories specified in prompt
  final List<String> _beardCategories = [
    'All',
    'Clean Shave',
    'Light Stubble',
    'Heavy Stubble',
    'Short Beard',
    'Full Beard',
    'Goatee',
    'Van Dyke',
    'Balbo',
    'Circle Beard',
    'Boxed Beard',
    'Corporate Beard',
  ];

  final List<String> _faceShapeFilters = [
    'All',
    'Oval',
    'Square',
    'Round',
    'Rectangle',
    'Diamond',
    'Heart',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showStyleDetails(StyleModel style) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: AppTheme.border),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      style.id,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.background),
                    ),
                  ),
                  Chip(
                    avatar: const Icon(Icons.verified, size: 14, color: AppTheme.success),
                    label: Text(
                      style.isHair ? 'Compatible: Oval, Square, Round' : 'Compatible: All Face Shapes',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.asset(
                    style.assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.face, size: 64)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                style.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                style.promptHint,
                style: const TextStyle(fontSize: 13, color: AppTheme.secondaryText, height: 1.4),
              ),
              const SizedBox(height: 16),

              // Specifications & Barber Guard Guidance
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Barber Consultation Specs:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.secondaryAccent)),
                    const SizedBox(height: 4),
                    Text(
                      style.isHair
                          ? '• Side Guard: #1.5 to #2 Fade Transition\n• Top Length: 1.5–2 inches textured scissor cut\n• Styling Product: Matte styling clay with pliable hold'
                          : '• Baseline Length: 4mm–8mm trimmer guard\n• Cheek Line: Sculpted diagonal to corner of mouth\n• Hydration: 3 drops cedarwood beard oil daily',
                      style: const TextStyle(fontSize: 11, color: AppTheme.secondaryText, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onStyleSelected(style);
                  },
                  icon: const Icon(Icons.auto_awesome),
                  label: Text('Try This ${style.isHair ? 'Hairstyle' : 'Beard Style'} in Studio'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.toLowerCase();

    // Filter Hairstyles
    final filteredHair = StyleCatalogData.hairstyles.where((s) {
      final matchesQuery = query.isEmpty ||
          s.name.toLowerCase().contains(query) ||
          s.promptHint.toLowerCase().contains(query);
      return matchesQuery;
    }).toList();

    // Filter Beard Styles
    final filteredBeard = StyleCatalogData.beardStyles.where((s) {
      final matchesQuery = query.isEmpty ||
          s.name.toLowerCase().contains(query) ||
          s.promptHint.toLowerCase().contains(query);
      return matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Style Explorer'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.face, size: 18), text: 'Hairstyles (25)'),
            Tab(icon: Icon(Icons.brush, size: 18), text: 'Beard Styles (25)'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search 25 haircuts & 25 beards (fade, crop, stubble)...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Face Shape Filter Row
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _faceShapeFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final shape = _faceShapeFilters[i];
                final isSelected = shape == _selectedFaceShapeFilter;
                return ChoiceChip(
                  label: Text(shape == 'All' ? 'All Shapes' : '$shape Face'),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedFaceShapeFilter = shape),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Hairstyle Explorer Tab
                _buildExplorerGrid(
                  styles: filteredHair,
                  categories: _hairCategories,
                  selectedCategory: _hairCategory,
                  onCategoryChanged: (cat) => setState(() => _hairCategory = cat),
                ),

                // 2. Beard Style Explorer Tab
                _buildExplorerGrid(
                  styles: filteredBeard,
                  categories: _beardCategories,
                  selectedCategory: _beardCategory,
                  onCategoryChanged: (cat) => setState(() => _beardCategory = cat),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplorerGrid({
    required List<StyleModel> styles,
    required List<String> categories,
    required String selectedCategory,
    required ValueChanged<String> onCategoryChanged,
  }) {
    return Column(
      children: [
        // Category Filter Chips
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final cat = categories[i];
              final isSel = selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSel,
                onSelected: (_) => onCategoryChanged(cat),
              );
            },
          ),
        ),

        // Grid
        Expanded(
          child: styles.isEmpty
              ? const Center(
                  child: Text('No styles match your search.', style: TextStyle(color: AppTheme.secondaryText)),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: styles.length,
                  itemBuilder: (context, i) {
                    final item = styles[i];
                    return StyleCard(
                      style: item,
                      isSelected: false,
                      onSelect: () => _showStyleDetails(item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
