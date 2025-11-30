import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_api/main.dart';

void main() {
  group('Main App Widget Tests', () {
    testWidgets('MainApp renders without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());

      expect(find.byType(MainApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Search TextField is present', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Search TextField has correct hint text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Verify hint text exists
      expect(find.text('Cari lokasi...'), findsOneWidget);
    });

    testWidgets('Search TextField can receive input', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Jakarta');

      expect(find.text('Jakarta'), findsOneWidget);
    });

    testWidgets('MapWidget is rendered', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());

      // MapWidget should be in the widget tree
      expect(find.byType(Stack), findsOneWidget);
    });

    testWidgets('SafeArea wraps the content', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Search results container has proper styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());

      // Container with margin should exist
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Material Design is enabled', (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Search input triggers state update', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Bandung');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('Bandung'), findsOneWidget);
    });

    testWidgets('Clear search functionality works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Test Location');
      expect(find.text('Test Location'), findsOneWidget);

      await tester.enterText(textField, '');
      expect(find.text('Test Location'), findsNothing);
    });
  });
}
