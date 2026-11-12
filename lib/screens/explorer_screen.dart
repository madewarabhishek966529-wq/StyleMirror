import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/style_catalog_data.dart';
import '../models/face_profile_model.dart';
import '../models/style_model.dart';
import '../widgets/style_card.dart';

/// Screen 6 & Screen 7: Hairstyle Explorer & Beard Style Explorer
/// Design System: Warm Ivory background, Deep Emerald selection, Copper details, Sticky Bottom Bar
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
  StyleModel? _selectedStyle;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Style ID & Compatibility Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.deepEmerald,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      style.id,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.copper.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      style.isHair ? 'Compatible: Oval, Square, Round' : 'Compatible: All Face Shapes',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.copper),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Large Reference Image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
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

              // Style Name
              Text(
                style.name,
                style: TextStyle(fontFamily: 'serif', fontSize: 22, fontWeight: FontWeight.bold, color: primaryTextColor),
              ),
              const SizedBox(height: 4),
              Text(
                style.promptHint,
                style: TextStyle(fontSize: 13, color: secondaryTextColor, height: 1.4),
              ),
              const SizedBox(height: 16),

              // Barber Consultation Specs Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBackground : AppTheme.ivoryBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderIvory),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Barber Consultation Specifications:',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.copper),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      style.isHair
                          ? '• Side Clipper Guard: #1.5 to #2 Fade Transition\n• Top Texture: 1.5–2 inches textured scissor cut\n• Styling Product: Matte styling clay with pliable hold'
                          : '• Baseline Length: 4mm–8mm trimmer guard\n• Cheek Line: Sculpted diagonal to corner of mouth\n• Hydration: 3 drops cedarwood beard oil daily',
                      style: TextStyle(fontSize: 11, color: secondaryTextColor, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Try This Style Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onStyleSelected(style);
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;
    final cardBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;

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
        title: Row(
          children: [
            Text(
              'Style Explorer',
              style: TextStyle(fontFamily: 'serif', fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor),
            ),
            const Spacer(),
            // Pinned User Portrait Thumbnail in Header
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.deepEmerald, width: 1.5),
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage('assets/portraits/model_1.jpg'),
              ),
            ),
          ],
        ),
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
                _buildExplorerGrid(
                  styles: filteredHair,
                  categories: _hairCategories,
                  selectedCategory: _hairCategory,
                  onCategoryChanged: (cat) => setState(() => _hairCategory = cat),
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                _buildExplorerGrid(
                  styles: filteredBeard,
                  categories: _beardCategories,
                  selectedCategory: _beardCategory,
                  onCategoryChanged: (cat) => setState(() => _beardCategory = cat),
                  primaryTextColor: primaryTextColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          ),

          // Sticky "Generate Preview" Bottom Bar when style is selected
          if (_selectedStyle != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(top: BorderSide(color: borderColor, width: 1)),
                boxShadow: const [AppTheme.cardShadow],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        _selectedStyle!.assetPath,
                        width: 38,
                        height: 38,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedStyle!.name,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryTextColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${_selectedStyle!.id} • ${_selectedStyle!.category}',
                            style: TextStyle(fontSize: 10, color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => widget.onStyleSelected(_selectedStyle!),
                      icon: const Icon(Icons.auto_awesome, size: 14),
                      label: const Text('Generate Preview', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ],
                ),
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
    required Color primaryTextColor,
    required Color secondaryTextColor,
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
              ? Center(
                  child: Text('No styles match your search.', style: TextStyle(color: secondaryTextColor)),
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
                    final isSel = _selectedStyle?.id == item.id;
                    return GestureDetector(
                      onDoubleTap: () => _showStyleDetails(item),
                      child: StyleCard(
                        style: item,
                        isSelected: isSel,
                        onSelect: () {
                          setState(() {
                            if (_selectedStyle?.id == item.id) {
                              _selectedStyle = null;
                            } else {
                              _selectedStyle = item;
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
