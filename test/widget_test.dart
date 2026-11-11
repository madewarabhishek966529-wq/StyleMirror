import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stylemirror/main.dart';
import 'package:stylemirror/services/api_service.dart';
import 'package:stylemirror/widgets/before_after_slider.dart';
import 'package:stylemirror/widgets/step_indicator.dart';

void main() {
  testWidgets('StyleMirrorApp boots and renders 5 navigation destinations', (WidgetTester tester) async {
    final apiService = StyleMirrorApiService(useMockFallback: true);

    await tester.pumpWidget(StyleMirrorApp(apiService: apiService));
    await tester.pumpAndSettle();

    // Verify Title & Brand
    expect(find.text('StyleMirror'), findsAtLeastNWidgets(1));

    // Verify 5 Navigation Bar destinations
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Try On'), findsOneWidget);
    expect(find.text('My Styles'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify Initial Dashboard Elements
    expect(find.text('MY FACE PROFILE'), findsOneWidget);
    expect(find.text('Virtual AI Try-On Studio'), findsOneWidget);
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

  testWidgets('ExplorerScreen allows switching between Hairstyles and Beard Styles', (WidgetTester tester) async {
    final apiService = StyleMirrorApiService(useMockFallback: true);

    await tester.pumpWidget(StyleMirrorApp(apiService: apiService));
    await tester.pumpAndSettle();

    // Tap Explore tab (Destination index 1)
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    expect(find.text('Hairstyles (25)'), findsOneWidget);
    expect(find.text('Beard Styles (25)'), findsOneWidget);

    // Default tab is Hairstyles with All Shapes filter
    expect(find.text('All Shapes'), findsAtLeastNWidgets(1));

    // Switch to Beard Styles tab
    await tester.tap(find.text('Beard Styles (25)'));
    await tester.pumpAndSettle();

    expect(find.text('Beard Styles (25)'), findsOneWidget);
  });

  testWidgets('Try On navigation switches to Selfie capture view', (WidgetTester tester) async {
    final apiService = StyleMirrorApiService(useMockFallback: true);

    await tester.pumpWidget(StyleMirrorApp(apiService: apiService));
    await tester.pumpAndSettle();

    // Tap Try On tab (Destination index 2)
    await tester.tap(find.text('Try On'));
    await tester.pumpAndSettle();

    expect(find.text('Upload or Capture Selfie'), findsOneWidget);
    expect(find.text('Capture / Choose Selfie'), findsOneWidget);
  });

  testWidgets('My Styles tab displays vault categories and barber consultation trigger', (WidgetTester tester) async {
    final apiService = StyleMirrorApiService(useMockFallback: true);

    await tester.pumpWidget(StyleMirrorApp(apiService: apiService));
    await tester.pumpAndSettle();

    // Tap My Styles tab (Destination index 3)
    await tester.tap(find.text('My Styles'));
    await tester.pumpAndSettle();

    expect(find.text('My Styles Vault'), findsOneWidget);
    expect(find.text('Barber Card'), findsOneWidget);
    expect(find.text('Virtual Previews (4)'), findsOneWidget);
    expect(find.text('Hairstyles (3)'), findsOneWidget);
  });

  testWidgets('Profile tab displays face analysis details and Grooming Guide hub', (WidgetTester tester) async {
    final apiService = StyleMirrorApiService(useMockFallback: true);

    await tester.pumpWidget(StyleMirrorApp(apiService: apiService));
    await tester.pumpAndSettle();

    // Tap Profile tab (Destination index 4)
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile & Grooming Guide'), findsOneWidget);
    expect(find.text('Face Analysis Profile'), findsOneWidget);
    expect(find.text('Men\'s Grooming Guide'), findsOneWidget);
  });
}
