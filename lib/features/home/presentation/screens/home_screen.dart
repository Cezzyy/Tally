import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;

    return Center(
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
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
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
                SizedBox(height: context.isMobile ? 16 : 24),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(context.isMobile ? 16.0 : 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: context.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Quick Start',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _QuickStartItem(
                          icon: Icons.confirmation_number_outlined,
                          title: 'Create Tickets',
                          description:
                              'Navigate to Tickets to create your first task',
                        ),
                        const SizedBox(height: 12),
                        _QuickStartItem(
                          icon: Icons.checklist_outlined,
                          title: 'Add Checklists',
                          description:
                              'Break down tasks into manageable sub-items',
                        ),
                        const SizedBox(height: 12),
                        _QuickStartItem(
                          icon: Icons.sync_outlined,
                          title: 'Real-time Sync',
                          description: 'Your data syncs across all devices',
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
    );
  }
}

class _QuickStartItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _QuickStartItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: context.colorScheme.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
