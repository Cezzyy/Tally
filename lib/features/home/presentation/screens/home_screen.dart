import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../providers/analytics_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/home_skeleton_loader.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(dashboardAnalyticsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(dashboardAnalyticsProvider.notifier).refresh();
      },
      child: analyticsAsync.when(
        data: (analytics) => _buildDashboard(context, analytics),
        loading: () => const HomeSkeletonLoader(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: context.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load analytics',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(dashboardAnalyticsProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, analytics) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.isMobile ? 16.0 : 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style:
                    (context.isMobile
                            ? context.textTheme.headlineMedium
                            : context.textTheme.headlineLarge)
                        ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Overview of your tasks and progress',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: context.isMobile ? 20 : 32),
              _buildQuickStats(context, analytics),
              SizedBox(height: context.isMobile ? 20 : 24),
              _buildStatusBreakdown(context, analytics),
              SizedBox(height: context.isMobile ? 20 : 24),
              _buildPriorityBreakdown(context, analytics),
              SizedBox(height: context.isMobile ? 20 : 24),
              _buildProgressSection(context, analytics),
              SizedBox(height: context.isMobile ? 20 : 24),
              _buildDueDatesSection(context, analytics),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, analytics) {
    final crossAxisCount = context.isMobile ? 2 : (context.isTablet ? 3 : 4);
    final childAspectRatio = context.isMobile
        ? 1.4
        : (context.isTablet ? 1.5 : 1.6);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: context.isMobile ? 12 : 16,
      crossAxisSpacing: context.isMobile ? 12 : 16,
      childAspectRatio: childAspectRatio,
      children: [
        StatCard(
          title: 'Total Tickets',
          value: '${analytics.totalTickets}',
          icon: Icons.confirmation_number_outlined,
          color: context.colorScheme.primary,
          onTap: () => context.go('/tickets'),
        ),
        StatCard(
          title: 'In Progress',
          value: '${analytics.inProgressTickets}',
          icon: Icons.pending_actions_outlined,
          color: Colors.blue,
          onTap: () => context.go('/tickets'),
        ),
        StatCard(
          title: 'Completed',
          value: '${analytics.doneTickets}',
          icon: Icons.check_circle_outline,
          color: Colors.green,
          onTap: () => context.go('/tickets'),
        ),
        StatCard(
          title: 'Overdue',
          value: '${analytics.overdueTickets}',
          icon: Icons.warning_amber_outlined,
          color: Colors.red,
          onTap: () => context.go('/tickets'),
        ),
      ],
    );
  }

  Widget _buildStatusBreakdown(BuildContext context, analytics) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.pie_chart_outline,
                  color: context.colorScheme.primary,
                  size: context.isMobile ? 24 : 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Status Breakdown',
                  style:
                      (context.isMobile
                              ? context.textTheme.titleMedium
                              : context.textTheme.titleLarge)
                          ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: context.isMobile ? 16 : 20),
            _buildStatusRow(
              context,
              'Backlog',
              analytics.backlogTickets,
              analytics.totalTickets,
              Colors.grey,
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              context,
              'In Progress',
              analytics.inProgressTickets,
              analytics.totalTickets,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              context,
              'Done',
              analytics.doneTickets,
              analytics.totalTickets,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context,
    String label,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0
        ? (count / total * 100).toStringAsFixed(0)
        : '0';
    final progress = total > 0 ? count / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$count ($percentage%)',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: context.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityBreakdown(BuildContext context, analytics) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  color: context.colorScheme.primary,
                  size: context.isMobile ? 24 : 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Priority Breakdown',
                  style:
                      (context.isMobile
                              ? context.textTheme.titleMedium
                              : context.textTheme.titleLarge)
                          ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: context.isMobile ? 16 : 20),
            _buildPriorityRow(
              context,
              'Urgent',
              analytics.urgentTickets,
              Colors.red.shade700,
            ),
            const SizedBox(height: 12),
            _buildPriorityRow(
              context,
              'High',
              analytics.highPriorityTickets,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildPriorityRow(
              context,
              'Medium',
              analytics.mediumPriorityTickets,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildPriorityRow(
              context,
              'Low',
              analytics.lowPriorityTickets,
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityRow(
    BuildContext context,
    String label,
    int count,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '$count',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context, analytics) {
    return ProgressCard(
      title: 'Checklist Progress',
      completed: analytics.completedChecklistItems,
      total: analytics.totalChecklistItems,
      icon: Icons.checklist_outlined,
      color: context.colorScheme.secondary,
    );
  }

  Widget _buildDueDatesSection(BuildContext context, analytics) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: context.colorScheme.primary,
                  size: context.isMobile ? 24 : 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Due Dates',
                  style:
                      (context.isMobile
                              ? context.textTheme.titleMedium
                              : context.textTheme.titleLarge)
                          ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: context.isMobile ? 16 : 20),
            _buildDueDateRow(
              context,
              'Due Today',
              analytics.dueTodayTickets,
              Icons.today_outlined,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildDueDateRow(
              context,
              'Due This Week',
              analytics.dueThisWeekTickets,
              Icons.date_range_outlined,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildDueDateRow(
              context,
              'Overdue',
              analytics.overdueTickets,
              Icons.warning_amber_outlined,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateRow(
    BuildContext context,
    String label,
    int count,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
