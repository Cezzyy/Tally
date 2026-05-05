import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tally/shared/extensions/context_extensions.dart';

void main() {
  group('ContextExtensions', () {
    testWidgets('theme returns correct ThemeData', (tester) async {
      late ThemeData capturedTheme;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              capturedTheme = context.theme;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTheme.brightness, Brightness.light);
    });

    testWidgets('colorScheme returns correct ColorScheme', (tester) async {
      late ColorScheme capturedColorScheme;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              capturedColorScheme = context.colorScheme;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedColorScheme, isA<ColorScheme>());
    });

    testWidgets('textTheme returns correct TextTheme', (tester) async {
      late TextTheme capturedTextTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedTextTheme = context.textTheme;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedTextTheme, isA<TextTheme>());
    });

    testWidgets('screenSize returns correct Size', (tester) async {
      late Size capturedSize;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedSize = context.screenSize;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedSize.width, 800.0); // Default test size
      expect(capturedSize.height, 600.0); // Default test size
    });

    testWidgets('screenWidth returns correct width', (tester) async {
      late double capturedWidth;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedWidth = context.screenWidth;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedWidth, 800.0); // Default test size
    });

    testWidgets('screenHeight returns correct height', (tester) async {
      late double capturedHeight;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedHeight = context.screenHeight;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedHeight, 600.0); // Default test size
    });

    testWidgets('isMobile returns true for mobile width', (tester) async {
      late bool isMobile;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(500, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                isMobile = context.isMobile;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(isMobile, true);
    });

    testWidgets('isMobile returns false for desktop width', (tester) async {
      late bool isMobile;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1300, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                isMobile = context.isMobile;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(isMobile, false);
    });

    testWidgets('isTablet returns true for tablet width', (tester) async {
      late bool isTablet;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(700, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                isTablet = context.isTablet;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(isTablet, true);
    });

    testWidgets('isDesktop returns true for desktop width', (tester) async {
      late bool isDesktop;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1300, 800)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                isDesktop = context.isDesktop;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(isDesktop, true);
    });

    testWidgets('showSnackBar displays snackbar with message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    context.showSnackBar('Test message');
                  },
                  child: const Text('Show Snackbar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Snackbar'));
      await tester.pump();

      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('showSnackBar displays error snackbar when isError is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    context.showSnackBar('Error message', isError: true);
                  },
                  child: const Text('Show Error'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pump();

      expect(find.text('Error message'), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, isNotNull);
    });

    testWidgets('showBottomSheet displays bottom sheet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    context.showBottomSheet(const Text('Bottom Sheet Content'));
                  },
                  child: const Text('Show Bottom Sheet'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Bottom Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Bottom Sheet Content'), findsOneWidget);
    });
  });
}
