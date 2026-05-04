import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/supabase_service.dart';
import '../data/models/dashboard_analytics.dart';
import '../data/repositories/analytics_repository.dart';

part 'analytics_provider.g.dart';

@riverpod
AnalyticsRepository analyticsRepository(Ref ref) {
  return AnalyticsRepository(SupabaseService.client);
}

@riverpod
class DashboardAnalyticsNotifier extends _$DashboardAnalyticsNotifier {
  @override
  Future<DashboardAnalytics> build() async {
    return ref.read(analyticsRepositoryProvider).getDashboardAnalytics();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(analyticsRepositoryProvider).getDashboardAnalytics(),
    );
  }
}
