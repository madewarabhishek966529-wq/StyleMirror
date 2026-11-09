import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/catalog_screen.dart';
import 'screens/home_screen.dart';
import 'screens/privacy_screen.dart';
import 'services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = StyleMirrorApiService();
  runApp(StyleMirrorApp(apiService: apiService));
}

class StyleMirrorApp extends StatelessWidget {
  final StyleMirrorApiService apiService;

  const StyleMirrorApp({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleMirror — Hair & Beard AI Try-On',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: MainNavigationScaffold(apiService: apiService),
    );
  }
}

class MainNavigationScaffold extends StatefulWidget {
  final StyleMirrorApiService apiService;

  const MainNavigationScaffold({super.key, required this.apiService});

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(apiService: widget.apiService),
      CatalogScreen(
        onStyleSelected: (style) {
          setState(() => _currentIndex = 0);
        },
      ),
      const PrivacyScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppTheme.surface,
          indicatorColor: AppTheme.primary.withOpacity(0.25),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppTheme.primaryLight : AppTheme.textMuted,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 22,
              color: isSelected ? AppTheme.primaryLight : AppTheme.textMuted,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.auto_fix_high_outlined),
              selectedIcon: Icon(Icons.auto_fix_high),
              label: 'Try-On',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: 'Catalog (50)',
            ),
            NavigationDestination(
              icon: Icon(Icons.shield_outlined),
              selectedIcon: Icon(Icons.shield),
              label: 'Privacy',
            ),
          ],
        ),
      ),
    );
  }
}
