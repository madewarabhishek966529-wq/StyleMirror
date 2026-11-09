import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:stylemirror/data/style_catalog_data.dart';

void main() {
  group('StyleCatalogData Tests', () {
    test('contains exactly 50 styles (25 hair + 25 beard)', () {
      expect(StyleCatalogData.allStyles.length, 50);
      expect(StyleCatalogData.hairstyles.length, 25);
      expect(StyleCatalogData.beardStyles.length, 25);
    });

    test('all style IDs are unique', () {
      final ids = StyleCatalogData.allStyles.map((s) => s.id).toSet();
      expect(ids.length, 50);
    });

    test('all 50 style asset images exist on disk', () {
      for (final style in StyleCatalogData.allStyles) {
        expect(style.assetPath.isNotEmpty, true);
        final file = File(style.assetPath);
        expect(file.existsSync(), true, reason: 'Asset image missing: ${style.assetPath}');
      }
    });

    test('hairstyles have valid H01-H25 IDs and non-empty prompt hints', () {
      for (int i = 1; i <= 25; i++) {
        final expectedId = 'H${i.toString().padLeft(2, '0')}';
        final style = StyleCatalogData.findById(expectedId);
        expect(style != null, true, reason: 'Missing hairstyle $expectedId');
        expect(style!.isHair, true);
        expect(style.promptHint.isNotEmpty, true);
        expect(style.name.isNotEmpty, true);
      }
    });

    test('beards have valid B01-B25 IDs and non-empty prompt hints', () {
      for (int i = 1; i <= 25; i++) {
        final expectedId = 'B${i.toString().padLeft(2, '0')}';
        final style = StyleCatalogData.findById(expectedId);
        expect(style != null, true, reason: 'Missing beard $expectedId');
        expect(style!.isBeard, true);
        expect(style.promptHint.isNotEmpty, true);
        expect(style.name.isNotEmpty, true);
      }
    });

    test('categories are populated', () {
      expect(StyleCatalogData.hairCategories.contains('Fade'), true);
      expect(StyleCatalogData.hairCategories.contains('Classic & Parted'), true);
      expect(StyleCatalogData.beardCategories.contains('Clean & Stubble'), true);
      expect(StyleCatalogData.beardCategories.contains('Full & Long'), true);
    });
  });
}
