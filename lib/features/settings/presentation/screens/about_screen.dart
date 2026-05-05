import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_info.dart';
import '../../../../core/providers/app_info_provider.dart';
import '../../../../shared/extensions/context_extensions.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Responsive sizing
    final maxWidth = context.isDesktop ? 800.0 : double.infinity;
    final iconSize = context.isMobile ? 80.0 : 100.0;
    final iconInnerSize = context.isMobile ? 48.0 : 60.0;
    final horizontalPadding = context.isMobile
        ? 16.0
        : (context.isTablet ? 32.0 : 48.0);

    // Fetch version dynamically
    final versionAsync = ref.watch(appVersionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: context.isMobile,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: context.isMobile ? 16.0 : 24.0,
            ),
            children: [
              // App Icon and Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        size: iconInnerSize,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppInfo.appName,
                      style:
                          (context.isMobile
                                  ? context.textTheme.headlineSmall
                                  : context.textTheme.headlineMedium)
                              ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    versionAsync.when(
                      data: (version) => Text(
                        'Version $version',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      loading: () => Text(
                        'Version ${AppInfo.defaultVersion} Beta',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      error: (_, _) => Text(
                        'Version ${AppInfo.defaultVersion} Beta',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.isMobile ? 32 : 40),

              // What is Tally Section
              _AboutSection(
                title: 'What is Tally?',
                content:
                    'Tally is your personal productivity companion that helps you stay on top of your tasks and projects. Whether you\'re working solo or with a team, Tally keeps everything organized in one simple, easy-to-use app.',
              ),

              SizedBox(height: context.isMobile ? 20 : 24),

              // Key Features Section
              _AboutSection(
                title: 'Key Features',
                child: context.isDesktop
                    ? _DesktopFeatureGrid()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FeatureItem(
                            icon: Icons.confirmation_number_outlined,
                            title: 'Ticket Management',
                            description:
                                'Keep track of all your tasks and issues in one place. Set priorities and watch your progress.',
                          ),
                          const SizedBox(height: 16),
                          _FeatureItem(
                            icon: Icons.checklist_outlined,
                            title: 'Smart Checklists',
                            description:
                                'Break down big projects into simple steps. Check off items as you go and feel the satisfaction of progress.',
                          ),
                          const SizedBox(height: 16),
                          _FeatureItem(
                            icon: Icons.dashboard_outlined,
                            title: 'Dashboard Overview',
                            description:
                                'See everything at a glance. Your dashboard shows what needs attention and what you\'ve accomplished.',
                          ),
                          const SizedBox(height: 16),
                          _FeatureItem(
                            icon: Icons.palette_outlined,
                            title: 'Personalize Your Experience',
                            description:
                                'Choose light or dark mode to match your style and reduce eye strain.',
                          ),
                          const SizedBox(height: 16),
                          _FeatureItem(
                            icon: Icons.devices_outlined,
                            title: 'Works Everywhere',
                            description:
                                'Use Tally on your phone, tablet, or computer. The interface adapts perfectly to any screen size.',
                          ),
                          const SizedBox(height: 16),
                          _FeatureItem(
                            icon: Icons.cloud_sync_outlined,
                            title: 'Always in Sync',
                            description:
                                'Your data updates instantly across all your devices. Start on your phone, finish on your computer.',
                          ),
                        ],
                      ),
              ),

              SizedBox(height: context.isMobile ? 20 : 24),

              // Purpose Section
              _AboutSection(
                title: 'Our Mission',
                content:
                    'We believe staying organized should be simple, not stressful. Tally is designed to help you focus on what really matters - getting things done and feeling accomplished. No complicated features, no overwhelming options - just a clean, straightforward way to manage your work and life.',
              ),

              SizedBox(height: context.isMobile ? 32 : 40),

              // Footer
              Center(
                child: Text(
                  AppInfo.copyrightText,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? child;

  const _AboutSection({required this.title, this.content, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        if (content != null)
          Text(
            content!,
            textAlign: TextAlign.justify,
            style: context.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: context.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ?child,
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 24, color: context.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.justify,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopFeatureGrid extends StatelessWidget {
  const _DesktopFeatureGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 3,
      children: const [
        _FeatureItem(
          icon: Icons.confirmation_number_outlined,
          title: 'Ticket Management',
          description:
              'Keep track of all your tasks and issues in one place. Set priorities and watch your progress.',
        ),
        _FeatureItem(
          icon: Icons.checklist_outlined,
          title: 'Smart Checklists',
          description:
              'Break down big projects into simple steps. Check off items as you go and feel the satisfaction of progress.',
        ),
        _FeatureItem(
          icon: Icons.dashboard_outlined,
          title: 'Dashboard Overview',
          description:
              'See everything at a glance. Your dashboard shows what needs attention and what you\'ve accomplished.',
        ),
        _FeatureItem(
          icon: Icons.palette_outlined,
          title: 'Personalize Your Experience',
          description:
              'Choose light or dark mode to match your style and reduce eye strain.',
        ),
        _FeatureItem(
          icon: Icons.devices_outlined,
          title: 'Works Everywhere',
          description:
              'Use Tally on your phone, tablet, or computer. The interface adapts perfectly to any screen size.',
        ),
        _FeatureItem(
          icon: Icons.cloud_sync_outlined,
          title: 'Always in Sync',
          description:
              'Your data updates instantly across all your devices. Start on your phone, finish on your computer.',
        ),
      ],
    );
  }
}
