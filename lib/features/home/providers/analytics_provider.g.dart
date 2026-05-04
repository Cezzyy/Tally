// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(analyticsRepository)
final analyticsRepositoryProvider = AnalyticsRepositoryProvider._();

final class AnalyticsRepositoryProvider
    extends
        $FunctionalProvider<
          AnalyticsRepository,
          AnalyticsRepository,
          AnalyticsRepository
        >
    with $Provider<AnalyticsRepository> {
  AnalyticsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnalyticsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsRepository create(Ref ref) {
    return analyticsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsRepository>(value),
    );
  }
}

String _$analyticsRepositoryHash() =>
    r'0e125aedad86c27b1f88ad9168815cb3e1ae8050';

@ProviderFor(DashboardAnalyticsNotifier)
final dashboardAnalyticsProvider = DashboardAnalyticsNotifierProvider._();

final class DashboardAnalyticsNotifierProvider
    extends
        $AsyncNotifierProvider<DashboardAnalyticsNotifier, DashboardAnalytics> {
  DashboardAnalyticsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardAnalyticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardAnalyticsNotifierHash();

  @$internal
  @override
  DashboardAnalyticsNotifier create() => DashboardAnalyticsNotifier();
}

String _$dashboardAnalyticsNotifierHash() =>
    r'803c837ccfb103ccde1c85bbbbdb99a318d08844';

abstract class _$DashboardAnalyticsNotifier
    extends $AsyncNotifier<DashboardAnalytics> {
  FutureOr<DashboardAnalytics> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DashboardAnalytics>, DashboardAnalytics>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DashboardAnalytics>, DashboardAnalytics>,
              AsyncValue<DashboardAnalytics>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
