import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'core/logging/app_logger.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';

class TallyApp extends ConsumerWidget {
  const TallyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Tally',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      navigatorObservers: [
        TalkerRouteObserver(AppLogger.talker),
      ],
    );
  }
}
