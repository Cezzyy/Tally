import 'package:flutter_test/flutter_test.dart';
import 'package:tally/features/home/data/models/dashboard_analytics.dart';

void main() {
  group('DashboardAnalytics Model', () {
    test('creates instance with all fields', () {
      final analytics = DashboardAnalytics(
        totalTickets: 100,
        backlogTickets: 30,
        inProgressTickets: 50,
        doneTickets: 20,
        archivedTickets: 10,
        totalChecklistItems: 200,
        completedChecklistItems: 150,
        overdueTickets: 5,
        dueTodayTickets: 3,
        dueThisWeekTickets: 10,
        urgentTickets: 8,
        highPriorityTickets: 15,
        mediumPriorityTickets: 50,
        lowPriorityTickets: 27,
        completionRate: 75.0,
      );

      expect(analytics.totalTickets, 100);
      expect(analytics.backlogTickets, 30);
      expect(analytics.inProgressTickets, 50);
      expect(analytics.doneTickets, 20);
      expect(analytics.archivedTickets, 10);
      expect(analytics.totalChecklistItems, 200);
      expect(analytics.completedChecklistItems, 150);
      expect(analytics.overdueTickets, 5);
      expect(analytics.dueTodayTickets, 3);
      expect(analytics.dueThisWeekTickets, 10);
      expect(analytics.urgentTickets, 8);
      expect(analytics.highPriorityTickets, 15);
      expect(analytics.mediumPriorityTickets, 50);
      expect(analytics.lowPriorityTickets, 27);
      expect(analytics.completionRate, 75.0);
    });

    test('empty factory creates analytics with all zeros', () {
      final analytics = DashboardAnalytics.empty();

      expect(analytics.totalTickets, 0);
      expect(analytics.backlogTickets, 0);
      expect(analytics.inProgressTickets, 0);
      expect(analytics.doneTickets, 0);
      expect(analytics.archivedTickets, 0);
      expect(analytics.totalChecklistItems, 0);
      expect(analytics.completedChecklistItems, 0);
      expect(analytics.overdueTickets, 0);
      expect(analytics.dueTodayTickets, 0);
      expect(analytics.dueThisWeekTickets, 0);
      expect(analytics.urgentTickets, 0);
      expect(analytics.highPriorityTickets, 0);
      expect(analytics.mediumPriorityTickets, 0);
      expect(analytics.lowPriorityTickets, 0);
      expect(analytics.completionRate, 0.0);
    });

    test('handles zero values correctly', () {
      final analytics = DashboardAnalytics(
        totalTickets: 0,
        backlogTickets: 0,
        inProgressTickets: 0,
        doneTickets: 0,
        archivedTickets: 0,
        totalChecklistItems: 0,
        completedChecklistItems: 0,
        overdueTickets: 0,
        dueTodayTickets: 0,
        dueThisWeekTickets: 0,
        urgentTickets: 0,
        highPriorityTickets: 0,
        mediumPriorityTickets: 0,
        lowPriorityTickets: 0,
        completionRate: 0.0,
      );

      expect(analytics.totalTickets, 0);
      expect(analytics.completionRate, 0.0);
    });

    test('handles large numbers correctly', () {
      final analytics = DashboardAnalytics(
        totalTickets: 10000,
        backlogTickets: 3000,
        inProgressTickets: 5000,
        doneTickets: 2000,
        archivedTickets: 1000,
        totalChecklistItems: 50000,
        completedChecklistItems: 40000,
        overdueTickets: 500,
        dueTodayTickets: 300,
        dueThisWeekTickets: 1000,
        urgentTickets: 800,
        highPriorityTickets: 1500,
        mediumPriorityTickets: 5000,
        lowPriorityTickets: 2700,
        completionRate: 80.0,
      );

      expect(analytics.totalTickets, 10000);
      expect(analytics.totalChecklistItems, 50000);
      expect(analytics.completedChecklistItems, 40000);
    });

    test('completion rate can be decimal', () {
      final analytics = DashboardAnalytics(
        totalTickets: 100,
        backlogTickets: 30,
        inProgressTickets: 50,
        doneTickets: 20,
        archivedTickets: 0,
        totalChecklistItems: 100,
        completedChecklistItems: 67,
        overdueTickets: 0,
        dueTodayTickets: 0,
        dueThisWeekTickets: 0,
        urgentTickets: 0,
        highPriorityTickets: 0,
        mediumPriorityTickets: 0,
        lowPriorityTickets: 0,
        completionRate: 67.5,
      );

      expect(analytics.completionRate, 67.5);
    });

    test('completion rate can be 100%', () {
      final analytics = DashboardAnalytics(
        totalTickets: 50,
        backlogTickets: 0,
        inProgressTickets: 0,
        doneTickets: 50,
        archivedTickets: 0,
        totalChecklistItems: 100,
        completedChecklistItems: 100,
        overdueTickets: 0,
        dueTodayTickets: 0,
        dueThisWeekTickets: 0,
        urgentTickets: 0,
        highPriorityTickets: 0,
        mediumPriorityTickets: 0,
        lowPriorityTickets: 0,
        completionRate: 100.0,
      );

      expect(analytics.completionRate, 100.0);
      expect(analytics.doneTickets, 50);
      expect(analytics.completedChecklistItems, 100);
    });

    test('ticket status counts sum correctly', () {
      final analytics = DashboardAnalytics(
        totalTickets: 100,
        backlogTickets: 30,
        inProgressTickets: 50,
        doneTickets: 20,
        archivedTickets: 10,
        totalChecklistItems: 0,
        completedChecklistItems: 0,
        overdueTickets: 0,
        dueTodayTickets: 0,
        dueThisWeekTickets: 0,
        urgentTickets: 0,
        highPriorityTickets: 0,
        mediumPriorityTickets: 0,
        lowPriorityTickets: 0,
        completionRate: 0.0,
      );

      // Note: archived tickets are separate from status counts
      final activeTickets = analytics.backlogTickets +
          analytics.inProgressTickets +
          analytics.doneTickets;

      expect(activeTickets, 100);
    });

    test('priority counts can be tracked independently', () {
      final analytics = DashboardAnalytics(
        totalTickets: 100,
        backlogTickets: 30,
        inProgressTickets: 50,
        doneTickets: 20,
        archivedTickets: 0,
        totalChecklistItems: 0,
        completedChecklistItems: 0,
        overdueTickets: 0,
        dueTodayTickets: 0,
        dueThisWeekTickets: 0,
        urgentTickets: 10,
        highPriorityTickets: 20,
        mediumPriorityTickets: 50,
        lowPriorityTickets: 20,
        completionRate: 0.0,
      );

      final totalByPriority = analytics.urgentTickets +
          analytics.highPriorityTickets +
          analytics.mediumPriorityTickets +
          analytics.lowPriorityTickets;

      expect(totalByPriority, 100);
    });
  });
}
