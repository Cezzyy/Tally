import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';
import '../models/dashboard_analytics.dart';

class AnalyticsRepository {
  final SupabaseClient _supabase;

  AnalyticsRepository(this._supabase);

  Future<DashboardAnalytics> getDashboardAnalytics() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        AppLogger.instance.error('User not authenticated');
        return DashboardAnalytics.empty();
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final endOfToday = today.add(const Duration(days: 1));
      final endOfWeek = today.add(Duration(days: 7 - now.weekday));

      final ticketsResponse = await _supabase
          .from('tickets')
          .select('id, status, priority, due_date, is_archived')
          .eq('user_id', userId);

      final checklistResponse = await _supabase
          .from('checklist_items')
          .select('id, is_completed')
          .eq('user_id', userId);

      final tickets = ticketsResponse as List<dynamic>;
      final checklistItems = checklistResponse as List<dynamic>;

      int totalTickets = 0;
      int backlogTickets = 0;
      int inProgressTickets = 0;
      int doneTickets = 0;
      int archivedTickets = 0;
      int overdueTickets = 0;
      int dueTodayTickets = 0;
      int dueThisWeekTickets = 0;
      int urgentTickets = 0;
      int highPriorityTickets = 0;
      int mediumPriorityTickets = 0;
      int lowPriorityTickets = 0;

      for (final ticket in tickets) {
        final isArchived = ticket['is_archived'] as bool;
        if (isArchived) {
          archivedTickets++;
          continue;
        }

        totalTickets++;

        final status = ticket['status'] as String;
        switch (status) {
          case 'backlog':
            backlogTickets++;
            break;
          case 'in_progress':
            inProgressTickets++;
            break;
          case 'done':
            doneTickets++;
            break;
        }

        final priority = ticket['priority'] as String;
        switch (priority) {
          case 'urgent':
            urgentTickets++;
            break;
          case 'high':
            highPriorityTickets++;
            break;
          case 'medium':
            mediumPriorityTickets++;
            break;
          case 'low':
            lowPriorityTickets++;
            break;
        }

        final dueDateStr = ticket['due_date'] as String?;
        if (dueDateStr != null) {
          final dueDate = DateTime.parse(dueDateStr);
          if (dueDate.isBefore(now) && status != 'done') {
            overdueTickets++;
          } else if (dueDate.isAfter(today) &&
              dueDate.isBefore(endOfToday) &&
              status != 'done') {
            dueTodayTickets++;
          } else if (dueDate.isAfter(today) &&
              dueDate.isBefore(endOfWeek) &&
              status != 'done') {
            dueThisWeekTickets++;
          }
        }
      }

      final totalChecklistItems = checklistItems.length;
      final completedChecklistItems = checklistItems
          .where((item) => item['is_completed'] as bool)
          .length;

      final completionRate = totalChecklistItems > 0
          ? (completedChecklistItems / totalChecklistItems) * 100
          : 0.0;

      final analytics = DashboardAnalytics(
        totalTickets: totalTickets,
        backlogTickets: backlogTickets,
        inProgressTickets: inProgressTickets,
        doneTickets: doneTickets,
        archivedTickets: archivedTickets,
        totalChecklistItems: totalChecklistItems,
        completedChecklistItems: completedChecklistItems,
        overdueTickets: overdueTickets,
        dueTodayTickets: dueTodayTickets,
        dueThisWeekTickets: dueThisWeekTickets,
        urgentTickets: urgentTickets,
        highPriorityTickets: highPriorityTickets,
        mediumPriorityTickets: mediumPriorityTickets,
        lowPriorityTickets: lowPriorityTickets,
        completionRate: completionRate,
      );

      AppLogger.instance.info('Dashboard analytics fetched successfully');
      return analytics;
    } catch (e, stackTrace) {
      AppLogger.instance.error(
        'Failed to fetch dashboard analytics',
        e,
        stackTrace,
      );
      return DashboardAnalytics.empty();
    }
  }
}
