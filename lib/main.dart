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
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleMirror — AI Hairstyle & Beard Styling',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
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

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppTheme.cardBackground,
          indicatorColor: AppTheme.primaryAccent.withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppTheme.primaryAccent : AppTheme.secondaryText,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 22,
              color: isSelected ? AppTheme.primaryAccent : AppTheme.secondaryText,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: 'Try On',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark),
              label: 'My Styles',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
