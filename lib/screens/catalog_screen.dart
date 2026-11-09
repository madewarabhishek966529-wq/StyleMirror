import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../data/style_catalog_data.dart';
import '../models/style_model.dart';
import '../widgets/style_card.dart';

/// Style Catalog Explorer showcasing all 25 Hairstyles and 25 Beard styles
class CatalogScreen extends StatefulWidget {
  final ValueChanged<StyleModel>? onStyleSelected;

  const CatalogScreen({super.key, this.onStyleSelected});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _typeFilter = 'all'; // 'all', 'hair', 'beard'
  String _categoryFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showStyleDetails(StyleModel style) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppTheme.border),
      ),
      builder: (context) {
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
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      style.id,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                    ),
                  ),
                  Chip(label: Text(style.category)),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.asset(
                    style.assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                style.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                style.promptHint,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Barber Prompt Reference:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentCyan,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  'Change ${style.isHair ? 'hairstyle' : 'beard'} to ${style.name} — ${style.promptHint}. Keep natural face features, skin tone, and hairline.',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 20),
              if (widget.onStyleSelected != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onStyleSelected!(style);
                    },
                    child: const Text('Try This Style in Studio'),
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

    final filtered = StyleCatalogData.allStyles.where((s) {
      if (_typeFilter == 'hair' && !s.isHair) return false;
      if (_typeFilter == 'beard' && !s.isBeard) return false;
      if (_categoryFilter != 'All' && s.category != _categoryFilter) return false;
      if (query.isNotEmpty &&
          !s.name.toLowerCase().contains(query) &&
          !s.promptHint.toLowerCase().contains(query) &&
          !s.id.toLowerCase().contains(query)) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Style Catalog (50 Looks)'),
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
                hintText: 'Search 25 hairstyles & 25 beards...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Type Chips (All, Hairstyles, Beards)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildTypeChip('All 50', 'all'),
                const SizedBox(width: 8),
                _buildTypeChip('Hairstyles (25)', 'hair'),
                const SizedBox(width: 8),
                _buildTypeChip('Beard Styles (25)', 'beard'),
              ],
            ),
          ),

          // Grid
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No matching styles found.',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final item = filtered[i];
                      return StyleCard(
                        style: item,
                        isSelected: false,
                        onSelect: () => _showStyleDetails(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, String type) {
    final isSelected = _typeFilter == type;
    return GestureDetector(
      onTap: () => setState(() {
        _typeFilter = type;
        _categoryFilter = 'All';
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryLight : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

