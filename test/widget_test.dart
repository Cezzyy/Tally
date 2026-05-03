import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tally/app.dart';
import 'package:tally/core/logging/app_logger.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await AppLogger.initialize();
    await dotenv.load(fileName: '.env');
  });

  testWidgets('App smoke test - renders home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TallyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Tally'), findsOneWidget);
    expect(find.text('Welcome to Tally'), findsOneWidget);
    expect(find.text('Your personal ticketing system'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });

  testWidgets('Debug mode shows log viewer button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TallyApp()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.bug_report), findsOneWidget);
  });
}
