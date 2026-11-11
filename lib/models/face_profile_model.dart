/// Model representing the AI-detected face shape & facial feature analysis
class FaceProfile {
  final String faceShape; // Oval, Round, Square, Rectangle, Diamond, Heart
  final String proportions;
  final String jawline;
  final String forehead;
  final String hairline;
  final String facialHairSuitability;
  final List<String> recommendedHairStyleIds;
  final List<String> recommendedBeardStyleIds;
  final String matchReason;

  const FaceProfile({
    required this.faceShape,
    required this.proportions,
    required this.jawline,
    required this.forehead,
    required this.hairline,
    required this.facialHairSuitability,
    required this.recommendedHairStyleIds,
    required this.recommendedBeardStyleIds,
    required this.matchReason,
  });

  /// Default verified profile for demo & initial state
  static const FaceProfile defaultProfile = FaceProfile(
    faceShape: 'Oval',
    proportions: 'Balanced 1:1.4 Ratio',
    jawline: 'Softly Rounded & Defined',
    forehead: 'Proportional Width, Gentle Curve',
    hairline: 'Symmetrical Natural Hairline',
    facialHairSuitability: 'Universal Suitability for Stubble, Short Boxed Beard & Goatee',
    recommendedHairStyleIds: ['H01', 'H03', 'H12', 'H07'],
    recommendedBeardStyleIds: ['B02', 'B05', 'B10'],
    matchReason: 'Oval faces possess balanced proportions with a soft jaw. Fades, textured crops, and well-groomed short beards naturally accentuate your cheekbones without adding unwanted elongation.',
  );

  /// Helper factory to generate calibrated profile based on detected shape
  static FaceProfile generateForShape(String shape) {
    switch (shape.toLowerCase()) {
      case 'square':
        return const FaceProfile(
          faceShape: 'Square',
          proportions: 'Even 1:1 Width-to-Height',
          jawline: 'Sharp, Angular & Prominent',
          forehead: 'Wide, Straight Across',
          hairline: 'Broad Straight Hairline',
          facialHairSuitability: 'Excellent for Light/Medium Stubble & Rounded Goatees',
          recommendedHairStyleIds: ['H01', 'H02', 'H12', 'H16'],
          recommendedBeardStyleIds: ['B02', 'B08', 'B10'],
          matchReason: 'Square faces feature a strong angular jaw. Textured volume on top (Quiff, Crew Cut) softens edges, while neatly trimmed stubble maintains masculine definition without adding bulk.',
        );
      case 'round':
        return const FaceProfile(
          faceShape: 'Round',
          proportions: 'Equal Width & Height with Soft Curves',
          jawline: 'Soft Rounded Curve without Angles',
          forehead: 'Curved and Broad',
          hairline: 'Rounded Contour',
          facialHairSuitability: 'High Suitability for Angular Beards (Short Boxed, Van Dyke)',
          recommendedHairStyleIds: ['H03', 'H07', 'H12', 'H20'],
          recommendedBeardStyleIds: ['B05', 'B07', 'B11'],
          matchReason: 'Round faces benefit from vertical volume and structured cheek lines. High-fade pompadours and tapered boxed beards create slimming angles and elongate the jawline.',
        );
      case 'rectangle':
        return const FaceProfile(
          faceShape: 'Rectangle',
          proportions: 'Longer than Wide with Straight Cheeks',
          jawline: 'Square & Defined',
          forehead: 'Tall & Symmetrical',
          hairline: 'High Horizontal Hairline',
          facialHairSuitability: 'Fuller Cheek Stubble & Medium Beard to Add Width',
          recommendedHairStyleIds: ['H03', 'H04', 'H09', 'H14'],
          recommendedBeardStyleIds: ['B03', 'B05', 'B06'],
          matchReason: 'Rectangle faces have great vertical presence. French crops with forward fringes reduce forehead height, while fuller side beards bring horizontal balance.',
        );
      case 'diamond':
        return const FaceProfile(
          faceShape: 'Diamond',
          proportions: 'Widest at Cheekbones, Narrow Forehead & Jaw',
          jawline: 'Narrow & Pointed Chin',
          forehead: 'Tapered Narrow Forehead',
          hairline: 'Slight Peak Hairline',
          facialHairSuitability: 'Full Chin Beards & Textured Sides',
          recommendedHairStyleIds: ['H06', 'H08', 'H15', 'H22'],
          recommendedBeardStyleIds: ['B04', 'B05', 'B12'],
          matchReason: 'Diamond faces feature high, striking cheekbones. Medium textured hairstyles with fringe and fuller chin beards soften the pointed jaw and widen the forehead.',
        );
      case 'heart':
        return const FaceProfile(
          faceShape: 'Heart',
          proportions: 'Broad Forehead Tapering to a Pointed Chin',
          jawline: 'Slender Delicate Chin',
          forehead: 'Prominent & Broad',
          hairline: 'Widow\'s Peak or Wide Top',
          facialHairSuitability: 'Fuller Rounded Beards to Balance Narrow Chin',
          recommendedHairStyleIds: ['H04', 'H10', 'H13', 'H18'],
          recommendedBeardStyleIds: ['B05', 'B06', 'B08'],
          matchReason: 'Heart-shaped faces benefit from side-swept medium haircuts and thick, well-shaped beards that add visual weight to the jawline.',
        );
      case 'oval':
      default:
        return defaultProfile;
    }
  }
}

