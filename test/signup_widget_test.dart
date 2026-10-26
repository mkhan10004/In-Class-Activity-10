import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';

void main() {
  testWidgets('invalid submission is blocked; valid input shows success', (tester) async {
    await tester.pumpWidget(const MyApp());
    final button = find.byKey(const Key('signup'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);

    await tester.enterText(find.byKey(const Key('name')), 'Demo Student');
    await tester.enterText(find.byKey(const Key('email')), 'demo@example.com');
    await tester.enterText(find.byKey(const Key('password')), 'demo123');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Demo signup complete — your form passed validation!'), findsOneWidget);
  });

  // Run with flutter test --dart-define=USE_MOCK=true to enable this test.
  testWidgets('mock tip shows loading, advice, offline error, and recovery', (tester) async {
    await tester.pumpWidget(const MyApp());
    final action = find.text('Get a signup tip');
    await tester.ensureVisible(action);
    await tester.tap(action);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.byKey(const Key('tip-result')), findsOneWidget);

    final dropdown = find.text('Successful response');
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Offline failure').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(action);
    await tester.tap(action);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('Retry'), findsOneWidget);
    expect(find.byKey(const Key('tip-result')), findsNothing);

    await tester.ensureVisible(find.text('Offline failure'));
    await tester.tap(find.text('Offline failure'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Successful response').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(action);
    await tester.tap(action);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.byKey(const Key('tip-result')), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  }, skip: !const bool.fromEnvironment('USE_MOCK'));
}
