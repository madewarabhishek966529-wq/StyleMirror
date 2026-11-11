import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stylemirror/main.dart';
import 'package:stylemirror/services/api_service.dart';
import 'package:stylemirror/widgets/before_after_slider.dart';
import 'package:stylemirror/widgets/step_indicator.dart';

void main() {
  testWidgets('StyleMirrorApp boots and renders navigation destinations', (WidgetTester tester) async {
    final apiService = StyleMirrorApiService(useMockFallback: true);

    await tester.pumpWidget(StyleMirrorApp(apiService: apiService));
    await tester.pumpAndSettle();

    // Verify Title & Brand
    expect(find.text('StyleMirror'), findsOneWidget);

    // Verify Navigation Bar items
    expect(find.text('Try-On'), findsOneWidget);
    expect(find.text('Catalog (50)'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);

    // Verify Initial Step 1 Upload view
    expect(find.text('Upload or Capture Selfie'), findsOneWidget);
    expect(find.text('Capture / Choose Selfie'), findsOneWidget);
  });

  testWidgets('StepIndicator highlights current active step', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StepIndicator(currentStep: 1),
        ),
      ),
    );

    expect(find.text('Selfie'), findsOneWidget);
    expect(find.text('Choose Look'), findsOneWidget);
    expect(find.text('Try-On Studio'), findsOneWidget);
  });

  testWidgets('BeforeAfterSlider renders comparison modes and slider divider', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BeforeAfterSlider(
            beforeWidget: Center(child: Text('Before Image')),
            afterWidget: Center(child: Text('After Image')),
            beforeLabel: 'BEFORE',
            afterLabel: 'AFTER',
          ),
        ),
      ),
    );

    // Verify labels and chip options
    expect(find.text('Split Slider'), findsOneWidget);
    expect(find.text('Side-by-Side'), findsOneWidget);
    expect(find.text('Original'), findsOneWidget);
    expect(find.text('Styled'), findsOneWidget);

    expect(find.text('BEFORE'), findsOneWidget);
    expect(find.text('AFTER'), findsOneWidget);
  });

  testWidgets('CatalogScreen filters by hair and beard categories and shows details', (WidgetTester tester) async {
    final apiService = StyleMirrorApiService(useMockFallback: true);

    await tester.pumpWidget(StyleMirrorApp(apiService: apiService));
    await tester.pumpAndSettle();

    // Tap Catalog tab
    await tester.tap(find.text('Catalog (50)'));
    await tester.pumpAndSettle();

    expect(find.text('All 50'), findsOneWidget);
    expect(find.text('Hairstyles (25)'), findsOneWidget);
    expect(find.text('Beard Styles (25)'), findsOneWidget);

    // Switch to Hairstyles
    await tester.tap(find.text('Hairstyles (25)'));
    await tester.pumpAndSettle();
    expect(find.text('Short & Fade'), findsAtLeastNWidgets(1));

    // Switch to Beard Styles
    await tester.tap(find.text('Beard Styles (25)'));
    await tester.pumpAndSettle();
    expect(find.text('Clean & Stubble'), findsAtLeastNWidgets(1));
  });

  testWidgets('PrivacyScreen renders zero training and automated purge commitments', (WidgetTester tester) async {
    final apiService = StyleMirrorApiService(useMockFallback: true);

    await tester.pumpWidget(StyleMirrorApp(apiService: apiService));
    await tester.pumpAndSettle();

    // Tap Privacy tab
    await tester.tap(find.text('Privacy'));
    await tester.pumpAndSettle();

    expect(find.text('Privacy & Security'), findsOneWidget);
    expect(find.text('Zero AI Model Training'), findsOneWidget);
    expect(find.text('24-Hour Automated Purge'), findsOneWidget);
    expect(find.text('Instant Manual Wipe'), findsOneWidget);
  });
}
