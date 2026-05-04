class DashboardAnalytics {
  final int totalTickets;
  final int backlogTickets;
  final int inProgressTickets;
  final int doneTickets;
  final int archivedTickets;
  final int totalChecklistItems;
  final int completedChecklistItems;
  final int overdueTickets;
  final int dueTodayTickets;
  final int dueThisWeekTickets;
  final int urgentTickets;
  final int highPriorityTickets;
  final int mediumPriorityTickets;
  final int lowPriorityTickets;
  final double completionRate;

  const DashboardAnalytics({
    required this.totalTickets,
    required this.backlogTickets,
    required this.inProgressTickets,
    required this.doneTickets,
    required this.archivedTickets,
    required this.totalChecklistItems,
    required this.completedChecklistItems,
    required this.overdueTickets,
    required this.dueTodayTickets,
    required this.dueThisWeekTickets,
    required this.urgentTickets,
    required this.highPriorityTickets,
    required this.mediumPriorityTickets,
    required this.lowPriorityTickets,
    required this.completionRate,
  });

  factory DashboardAnalytics.empty() => const DashboardAnalytics(
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
}
