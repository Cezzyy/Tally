import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final user = ref.watch(authRepositoryProvider).currentUser;

    return ListView(
      padding: EdgeInsets.all(context.isMobile ? 16.0 : 24.0),
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: context.isMobile
                    ? context.textTheme.headlineSmall
                    : context.textTheme.headlineMedium,
              ),
              if (user?.email != null) ...[
                const SizedBox(height: 8),
                Text(
                  user!.email!,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Appearance Section
        _SettingsSection(
          title: 'Appearance',
          children: [
            _ThemeModeSelector(
              currentMode: currentThemeMode,
              onModeChanged: (mode) {
                ref.read(themeModeProvider.notifier).setThemeMode(mode);
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // About Section
        _SettingsSection(
          title: 'About',
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Tally'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/about'),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Account Section
        _SettingsSection(
          title: 'Account',
          children: [
            _SignOutButton(
              onSignOut: () async {
                final confirmed = await _showSignOutDialog(context);
                if (confirmed == true) {
                  await ref.read(authControllerProvider.notifier).signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<bool?> _showSignOutDialog(BuildContext context) {
    if (context.isMobile) {
      return _showSignOutBottomSheet(context);
    } else {
      return _showSignOutAlertDialog(context);
    }
  }

  Future<bool?> _showSignOutAlertDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showSignOutBottomSheet(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign Out',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to sign out?',
                style: context.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sign Out'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(child: Column(children: children)),
      ],
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  final ThemeModeEnum currentMode;
  final ValueChanged<ThemeModeEnum> onModeChanged;

  const _ThemeModeSelector({
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ThemeModeEnum.values.map((mode) {
        final isSelected = currentMode == mode;
        final isLast = mode == ThemeModeEnum.values.last;

        return Column(
          children: [
            ListTile(
              leading: Icon(mode.icon),
              title: Text(mode.displayName),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: context.colorScheme.primary)
                  : null,
              onTap: () => onModeChanged(mode),
            ),
            if (!isLast) const Divider(height: 1),
          ],
        );
      }).toList(),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  final VoidCallback onSignOut;

  const _SignOutButton({required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
      onTap: onSignOut,
    );
  }
}
