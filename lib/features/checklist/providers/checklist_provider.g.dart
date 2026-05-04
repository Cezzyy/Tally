// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(checklistRepository)
final checklistRepositoryProvider = ChecklistRepositoryProvider._();

final class ChecklistRepositoryProvider
    extends
        $FunctionalProvider<
          ChecklistRepository,
          ChecklistRepository,
          ChecklistRepository
        >
    with $Provider<ChecklistRepository> {
  ChecklistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checklistRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checklistRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChecklistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChecklistRepository create(Ref ref) {
    return checklistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChecklistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChecklistRepository>(value),
    );
  }
}

String _$checklistRepositoryHash() =>
    r'44d9396f210cc1eb041e7db971531732c6eb9307';

@ProviderFor(ChecklistsNotifier)
final checklistsProvider = ChecklistsNotifierFamily._();

final class ChecklistsNotifierProvider
    extends
        $AsyncNotifierProvider<ChecklistsNotifier, List<ChecklistWithStats>> {
  ChecklistsNotifierProvider._({
    required ChecklistsNotifierFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'checklistsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$checklistsNotifierHash();

  @override
  String toString() {
    return r'checklistsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChecklistsNotifier create() => ChecklistsNotifier();

  @override
  bool operator ==(Object other) {
    return other is ChecklistsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$checklistsNotifierHash() =>
    r'c3b367211842d4bf9ee3dcb0de849bc9c81cadda';

final class ChecklistsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ChecklistsNotifier,
          AsyncValue<List<ChecklistWithStats>>,
          List<ChecklistWithStats>,
          FutureOr<List<ChecklistWithStats>>,
          bool
        > {
  ChecklistsNotifierFamily._()
    : super(
        retry: null,
        name: r'checklistsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChecklistsNotifierProvider call({bool includeArchived = false}) =>
      ChecklistsNotifierProvider._(argument: includeArchived, from: this);

  @override
  String toString() => r'checklistsProvider';
}

abstract class _$ChecklistsNotifier
    extends $AsyncNotifier<List<ChecklistWithStats>> {
  late final _$args = ref.$arg as bool;
  bool get includeArchived => _$args;

  FutureOr<List<ChecklistWithStats>> build({bool includeArchived = false});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ChecklistWithStats>>,
              List<ChecklistWithStats>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ChecklistWithStats>>,
                List<ChecklistWithStats>
              >,
              AsyncValue<List<ChecklistWithStats>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(includeArchived: _$args));
  }
}

@ProviderFor(checklistsStream)
final checklistsStreamProvider = ChecklistsStreamFamily._();

final class ChecklistsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChecklistWithStats>>,
          List<ChecklistWithStats>,
          Stream<List<ChecklistWithStats>>
        >
    with
        $FutureModifier<List<ChecklistWithStats>>,
        $StreamProvider<List<ChecklistWithStats>> {
  ChecklistsStreamProvider._({
    required ChecklistsStreamFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'checklistsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$checklistsStreamHash();

  @override
  String toString() {
    return r'checklistsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ChecklistWithStats>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChecklistWithStats>> create(Ref ref) {
    final argument = this.argument as bool;
    return checklistsStream(ref, includeArchived: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChecklistsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$checklistsStreamHash() => r'523a8dba3056ef5b85a9bf6d6e12b5d60c081042';

final class ChecklistsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ChecklistWithStats>>, bool> {
  ChecklistsStreamFamily._()
    : super(
        retry: null,
        name: r'checklistsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChecklistsStreamProvider call({bool includeArchived = false}) =>
      ChecklistsStreamProvider._(argument: includeArchived, from: this);

  @override
  String toString() => r'checklistsStreamProvider';
}
