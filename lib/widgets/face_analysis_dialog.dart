import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/face_profile_model.dart';

/// Modal dialog providing the complete AI Face Analysis Workflow (Screen 5)
class FaceAnalysisDialog extends StatefulWidget {
  final ValueChanged<FaceProfile> onProfileUpdated;

  const FaceAnalysisDialog({super.key, required this.onProfileUpdated});

  static Future<FaceProfile?> show(BuildContext context, {required ValueChanged<FaceProfile> onProfileUpdated}) {
    return showModalBottomSheet<FaceProfile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FaceAnalysisDialog(onProfileUpdated: onProfileUpdated),
    );
  }

  @override
  State<FaceAnalysisDialog> createState() => _FaceAnalysisDialogState();
}

class _FaceAnalysisDialogState extends State<FaceAnalysisDialog> {
  int _step = 0; // 0: Guide & Capture, 1: Scanning, 2: Analysis Results
  String _selectedShape = 'Oval';
  int _selectedModelIndex = 1;
  late FaceProfile _currentProfile;

  final List<String> _faceShapes = ['Oval', 'Square', 'Round', 'Rectangle', 'Diamond', 'Heart'];

  @override
  void initState() {
    super.initState();
    _currentProfile = FaceProfile.defaultProfile;
  }

  void _startAnalysis() async {
    setState(() => _step = 1);

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final profile = FaceProfile.generateForShape(_selectedShape);
    setState(() {
      _currentProfile = profile;
      _step = 2;
    });
    widget.onProfileUpdated(profile);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppTheme.darkBackground : AppTheme.ivoryBackground;
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: dialogBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: borderColor, width: 1.5)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: secondaryTextColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.deepEmerald.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.face_retouching_natural, color: AppTheme.deepEmerald, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI Face Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor)),
                          Text('Biometric shape, jawline & hairline detection', style: TextStyle(fontSize: 11, color: secondaryTextColor)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: secondaryTextColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(color: borderColor, height: 1),

            // Content
            Expanded(
              child: _buildCurrentStepContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_step) {
      case 1:
        return _buildScanningState();
      case 2:
        return _buildResultsState();
      case 0:
      default:
        return _buildCaptureGuideState();
    }
  }

  Widget _buildCaptureGuideState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Face Viewport Guide Frame
          Container(
            height: 280,
            width: 230,
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primaryAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryAccent.withOpacity(0.18),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/portraits/model_$_selectedModelIndex.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.person, size: 64, color: AppTheme.secondaryText)),
                  ),
                  // Oval Biometric Reticle Guide
                  Center(
                    child: Container(
                      width: 170,
                      height: 220,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primaryAccent.withOpacity(0.8), width: 1.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.background.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('HAIRLINE BOUNDARY', style: TextStyle(fontSize: 8, color: AppTheme.primaryAccent, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.background.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('JAWLINE CONTOUR', style: TextStyle(fontSize: 8, color: AppTheme.secondaryAccent, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Positioning guidance banner
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Align face within oval reticle',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tested Face Preset Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: InkWell(
                    onTap: () => setState(() => _selectedModelIndex = i),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _selectedModelIndex == i ? AppTheme.primaryAccent.withOpacity(0.2) : AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedModelIndex == i ? AppTheme.primaryAccent : AppTheme.border,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/portraits/model_$i.jpg', width: 44, height: 44, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),

          // Face Shape Benchmark selector (Test simulation)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : AppTheme.cardWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune, size: 16, color: AppTheme.copper),
                    const SizedBox(width: 8),
                    Text('Select Face Shape to Calibrate:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTextColor)),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _faceShapes.map((shape) {
                    final isSel = _selectedShape == shape;
                    return ChoiceChip(
                      label: Text(shape),
                      selected: isSel,
                      onSelected: (_) => setState(() => _selectedShape = shape),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Best results checklist
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : AppTheme.ivoryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Front-Facing Photo Requirements:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.deepEmerald)),
                const SizedBox(height: 4),
                Text('• Direct eye-level camera angle with neutral expression', style: TextStyle(fontSize: 11, color: secondaryTextColor)),
                Text('• Uniform balanced lighting; avoid heavy shadows on jawline', style: TextStyle(fontSize: 11, color: secondaryTextColor)),
                Text('• Remove hats and sunglasses to reveal complete forehead & hairline', style: TextStyle(fontSize: 11, color: secondaryTextColor)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Analyze Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startAnalysis,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Analyze My Face'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.deepEmerald.withOpacity(0.12),
                border: Border.all(color: AppTheme.deepEmerald, width: 2),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.deepEmerald, strokeWidth: 3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Scanning Facial Biometrics...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Measuring cheekbone width, jawline taper, hairline symmetry & face proportions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final primaryTextColor = isDark ? AppTheme.darkTextPrimary : AppTheme.inkNavy;
    final secondaryTextColor = isDark ? AppTheme.darkTextSecondary : AppTheme.slate;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.deepEmerald.withOpacity(0.15),
                  AppTheme.copper.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.deepEmerald.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppTheme.deepEmerald,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('DETECTED FACE SHAPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.deepEmerald, letterSpacing: 0.8)),
                      Text('${_currentProfile.faceShape} Face Shape', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor)),
                      Text(_currentProfile.proportions, style: const TextStyle(fontSize: 12, color: AppTheme.copper, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Biometric attributes breakdown
          Text('Facial Feature Analysis:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryTextColor)),
          const SizedBox(height: 10),

          _buildFeatureRow(Icons.crop_portrait, 'Proportions', _currentProfile.proportions, cardBg, borderColor, primaryTextColor, secondaryTextColor),
          _buildFeatureRow(Icons.architecture, 'Jawline', _currentProfile.jawline, cardBg, borderColor, primaryTextColor, secondaryTextColor),
          _buildFeatureRow(Icons.panorama_vertical_outlined, 'Forehead', _currentProfile.forehead, cardBg, borderColor, primaryTextColor, secondaryTextColor),
          _buildFeatureRow(Icons.face, 'Hairline', _currentProfile.hairline, cardBg, borderColor, primaryTextColor, secondaryTextColor),
          _buildFeatureRow(Icons.brush_outlined, 'Facial Hair Suitability', _currentProfile.facialHairSuitability, cardBg, borderColor, primaryTextColor, secondaryTextColor),

          const SizedBox(height: 16),

          // Why this style suits you
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
              boxShadow: const [AppTheme.subtleShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 16, color: AppTheme.copper),
                    SizedBox(width: 8),
                    Text('Stylist Assessment:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.copper)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _currentProfile.matchReason,
                  style: TextStyle(fontSize: 12, color: secondaryTextColor, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _step = 0),
                  child: const Text('Re-Analyze'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _currentProfile);
                  },
                  child: const Text('Save Profile'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
    IconData icon,
    String label,
    String value,
    Color cardBg,
    Color borderColor,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.deepEmerald),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 10, color: secondaryTextColor, fontWeight: FontWeight.bold)),
                  Text(value, style: TextStyle(fontSize: 12, color: primaryTextColor, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

