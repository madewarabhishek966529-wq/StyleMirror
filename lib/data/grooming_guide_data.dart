import 'package:flutter/material.dart';
import '../models/grooming_guide_model.dart';

/// Comprehensive Men's Hair and Beard Grooming Knowledge Base
class GroomingGuideData {
  static const List<GroomingArticle> articles = [
    GroomingArticle(
      id: 'g01',
      title: 'The Master Barber Hair Care Routine',
      category: 'Hair Care',
      readTime: '3 min read',
      summary: 'Essential daily shampooing, conditioning, and scalp hydration habits for healthy hair follicles.',
      icon: Icons.water_drop_outlined,
      keyTips: [
        'Shampoo only 2–3 times weekly to avoid stripping natural sebum oils.',
        'Use sulfate-free moisturising conditioner every wash to prevent brittle ends.',
        'Massage the scalp for 60 seconds daily to stimulate micro-circulation and follicle health.',
        'Pat hair dry with a microfiber towel instead of aggressive rubbing.',
      ],
      fullContent:
          'A disciplined hair care routine starts with understanding your scalp sebum balance. Washing hair every day with harsh commercial surfactants strips your hair cuticles, causing dryness, frizz, and compensatory oil overproduction. Opt for nourishing botanical formulas containing tea tree, argan, or jojoba extracts.',
    ),
    GroomingArticle(
      id: 'g02',
      title: 'Beard Trimming & Neckline Sculpting Guide',
      category: 'Beard Maintenance',
      readTime: '4 min read',
      summary: 'How to map your Adam\'s apple neckline, define crisp cheek lines, and fade jawline boundaries.',
      icon: Icons.brush_outlined,
      keyTips: [
        'Place two fingers above your Adam\'s apple — this marks your exact lowest neckline point.',
        'Shape a gentle U-curve up toward the back of each earlobe.',
        'Never trim wet beard hair — dry hair contracts and behaves differently.',
        'Apply 3–4 drops of beard oil immediately post-trim to hydrate skin underneath.',
      ],
      fullContent:
          'The most common beard mistake is trimming the neckline too high, creating an awkward double-chin illusion. Setting the neckline two fingers above the Adam’s apple creates a commanding, masculine jawline contour. Keep cheeks natural or use a straight edge for a razor-crisp diagonal boundary.',
    ),
    GroomingArticle(
      id: 'g03',
      title: 'Selecting the Right Styling Product: Matte Clay vs. Pomade',
      category: 'Styling & Tools',
      readTime: '4 min read',
      summary: 'Choosing between matte clay, water-based pomade, sea salt spray, and paste for your specific haircut.',
      icon: Icons.science_outlined,
      keyTips: [
        'Matte Clay / Paste: Best for textured crops, messy quiffs, and natural non-greasy hold.',
        'Water-Based Pomade: Ideal for slick backs, side parts, and classic professional styles with sheen.',
        'Sea Salt Spray: Perfect pre-styler for adding grit, lift, and volume to fine hair.',
        'Warm a nickel-sized amount between palms before applying from back to front.',
      ],
      fullContent:
          'Product selection depends on hair density and desired finish. For modern textured hairstyles (like the French Crop or Textured Crew Cut), matte clays give pliability without reflection. Classic side-part cuts benefit from high-hold water-soluble pomades that rinse clean without scalp buildup.',
    ),
    GroomingArticle(
      id: 'g04',
      title: 'Beard Itch & Patchiness: Practical Follicle Solutions',
      category: 'Beard Maintenance',
      readTime: '3 min read',
      summary: 'How to conquer the 2-week beard itch phase and cultivate thicker-looking facial hair.',
      icon: Icons.spa_outlined,
      keyTips: [
        'Exfoliate skin beneath the beard with a soft boar-bristle brush daily.',
        'Use dedicated beard wash rather than scalp shampoo which dries out facial skin.',
        'Apply cold-pressed beard oil with jojoba and cedarwood to eliminate flaking.',
        'Allow 4–6 weeks of growth before defining boundaries to see true density patterns.',
      ],
      fullContent:
          'Early-stage beard itch is caused by sharp razor-clipped ends curling back into dry facial skin. Consistent hydration with vitamin-E enriched beard oils calms inflammation and softens the hair shaft, allowing patches to fill in naturally as surrounding follicles grow.',
    ),
  ];
}

