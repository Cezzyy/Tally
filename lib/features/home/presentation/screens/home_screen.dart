import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tally'),
        centerTitle: context.isMobile,
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report),
              tooltip: 'View Logs',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        TalkerScreen(talker: AppLogger.talker),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (!context.mounted) return;
              context.go('/login');
            },
          ),
          if (!context.isMobile) const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.isMobile ? 16.0 : 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.isMobile ? double.infinity : 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: context.isMobile ? 64 : 80,
                  color: context.colorScheme.primary,
                ),
                SizedBox(height: context.isMobile ? 16 : 24),
                Text(
                  'Welcome to Tally',
                  style: context.isMobile
                      ? context.textTheme.headlineSmall
                      : context.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your personal ticketing system',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (user != null) ...[
                  SizedBox(height: context.isMobile ? 16 : 24),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(context.isMobile ? 16.0 : 24.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: context.isMobile ? 32 : 40,
                            color: context.colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Signed in as:',
                            style: context.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email ?? 'Unknown',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
