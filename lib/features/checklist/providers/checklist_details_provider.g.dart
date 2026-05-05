// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(checklistItemRepository)
final checklistItemRepositoryProvider = ChecklistItemRepositoryProvider._();

final class ChecklistItemRepositoryProvider
    extends
        $FunctionalProvider<
          ChecklistItemRepository,
          ChecklistItemRepository,
          ChecklistItemRepository
        >
    with $Provider<ChecklistItemRepository> {
  ChecklistItemRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checklistItemRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checklistItemRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChecklistItemRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChecklistItemRepository create(Ref ref) {
    return checklistItemRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChecklistItemRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChecklistItemRepository>(value),
    );
  }
}

String _$checklistItemRepositoryHash() =>
    r'c0fb7f1c9d7df7d9cc68a446d343dbd539b440a0';

@ProviderFor(ChecklistDetails)
final checklistDetailsProvider = ChecklistDetailsFamily._();

final class ChecklistDetailsProvider
    extends $AsyncNotifierProvider<ChecklistDetails, ChecklistWithItems> {
  ChecklistDetailsProvider._({
    required ChecklistDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'checklistDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$checklistDetailsHash();

  @override
  String toString() {
    return r'checklistDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChecklistDetails create() => ChecklistDetails();

  @override
  bool operator ==(Object other) {
    return other is ChecklistDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$checklistDetailsHash() => r'8d97bb5061e4bfcba8174d626129ff1fb4fafc5d';

final class ChecklistDetailsFamily extends $Family
    with
        $ClassFamilyOverride<
          ChecklistDetails,
          AsyncValue<ChecklistWithItems>,
          ChecklistWithItems,
          FutureOr<ChecklistWithItems>,
          String
        > {
  ChecklistDetailsFamily._()
    : super(
        retry: null,
        name: r'checklistDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChecklistDetailsProvider call(String checklistId) =>
      ChecklistDetailsProvider._(argument: checklistId, from: this);

  @override
  String toString() => r'checklistDetailsProvider';
}

abstract class _$ChecklistDetails extends $AsyncNotifier<ChecklistWithItems> {
  late final _$args = ref.$arg as String;
  String get checklistId => _$args;

  FutureOr<ChecklistWithItems> build(String checklistId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ChecklistWithItems>, ChecklistWithItems>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ChecklistWithItems>, ChecklistWithItems>,
              AsyncValue<ChecklistWithItems>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
