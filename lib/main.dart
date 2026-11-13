import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'models/face_profile_model.dart';
import 'screens/dashboard_screen.dart';
import 'screens/explorer_screen.dart';
import 'screens/home_screen.dart';
import 'screens/my_styles_screen.dart';
import 'screens/profile_screen.dart';
import 'services/api_service.dart';
import 'services/backend_launcher.dart';
import 'widgets/border_beam_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Automatically start Python backend if running on desktop and not already active
  await BackendLauncher.ensureBackendRunning();

  final apiService = StyleMirrorApiService();
  runApp(StyleMirrorApp(apiService: apiService));
}

class StyleMirrorApp extends StatefulWidget {
  final StyleMirrorApiService apiService;

  const StyleMirrorApp({super.key, required this.apiService});

  @override
  State<StyleMirrorApp> createState() => _StyleMirrorAppState();
}

class _StyleMirrorAppState extends State<StyleMirrorApp> {
  bool _isDarkMode = false; // Default: Warm Ivory Editorial SaaS Barbershop

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleMirror — AI Hairstyle & Beard Virtual Try-On',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainNavigationScaffold(
        apiService: widget.apiService,
        onThemeToggle: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class MainNavigationScaffold extends StatefulWidget {
  final StyleMirrorApiService apiService;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const MainNavigationScaffold({
    super.key,
    required this.apiService,
    required this.onThemeToggle,
    this.isDarkMode = true,
  });

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  FaceProfile _faceProfile = FaceProfile.defaultProfile;

  void _onProfileUpdated(FaceProfile profile) {
    setState(() => _faceProfile = profile);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      // 1. Home Dashboard
      DashboardScreen(
        faceProfile: _faceProfile,
        onProfileUpdated: _onProfileUpdated,
        onStyleSelected: (style) {
          _homeKey.currentState?.selectStyleFromExternal(style);
          setState(() => _currentIndex = 2); // Switch to Try-On
        },
        onNavigateToTryOn: () => setState(() => _currentIndex = 2),
        onNavigateToExplore: () => setState(() => _currentIndex = 1),
      ),

      // 2. Hairstyle & Beard Explorer
      ExplorerScreen(
        faceProfile: _faceProfile,
        onStyleSelected: (style) {
          _homeKey.currentState?.selectStyleFromExternal(style);
          setState(() => _currentIndex = 2); // Switch to Try-On
        },
      ),

      // 3. AI Virtual Try-On Studio
      HomeScreen(key: _homeKey, apiService: widget.apiService),

      // 4. My Styles Vault & Barber Card
      MyStylesScreen(
        faceProfile: _faceProfile,
        onStyleSelected: (style) {
          _homeKey.currentState?.selectStyleFromExternal(style);
          setState(() => _currentIndex = 2); // Switch to Try-On
        },
        onNavigateToTryOn: () => setState(() => _currentIndex = 2),
      ),

      // 5. Profile, Face Profile & Grooming Guide Hub
      ProfileScreen(
        faceProfile: _faceProfile,
        onProfileUpdated: _onProfileUpdated,
        onThemeToggle: widget.onThemeToggle,
        isDarkMode: widget.isDarkMode,
      ),
    ];

    final isDark = widget.isDarkMode;
    final navBg = isDark ? AppTheme.darkCard : AppTheme.cardWhite;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderIvory;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(top: BorderSide(color: borderColor, width: 1)),
          boxShadow: const [AppTheme.subtleShadow],
        ),
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
                index: 0,
                isSelected: _currentIndex == 0,
              ),
              _buildNavItem(
                icon: Icons.explore_outlined,
                selectedIcon: Icons.explore,
                label: 'Explore',
                index: 1,
                isSelected: _currentIndex == 1,
              ),

              // CENTER: "+" Symbol Border Beam Button for Try-On
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: BorderBeamButton(
                  size: 54,
                  beamWidth: 2.8,
                  label: 'Try On',
                  tooltip: 'Try On Hair & Beard',
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ),

              _buildNavItem(
                icon: Icons.bookmark_outline,
                selectedIcon: Icons.bookmark,
                label: 'My Styles',
                index: 3,
                isSelected: _currentIndex == 3,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profile',
                index: 4,
                isSelected: _currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    final isDark = widget.isDarkMode;
    final color = isSelected
        ? AppTheme.deepEmerald
        : (isDark ? AppTheme.darkTextSecondary : AppTheme.slate);

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? selectedIcon : icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
