// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ticketRepository)
final ticketRepositoryProvider = TicketRepositoryProvider._();

final class TicketRepositoryProvider
    extends
        $FunctionalProvider<
          TicketRepository,
          TicketRepository,
          TicketRepository
        >
    with $Provider<TicketRepository> {
  TicketRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketRepositoryHash();

  @$internal
  @override
  $ProviderElement<TicketRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TicketRepository create(Ref ref) {
    return ticketRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketRepository>(value),
    );
  }
}

String _$ticketRepositoryHash() => r'8f8e8830a837d238a1fe53a60718f97605f74f37';

@ProviderFor(TicketsNotifier)
final ticketsProvider = TicketsNotifierFamily._();

final class TicketsNotifierProvider
    extends $AsyncNotifierProvider<TicketsNotifier, List<Ticket>> {
  TicketsNotifierProvider._({
    required TicketsNotifierFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'ticketsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketsNotifierHash();

  @override
  String toString() {
    return r'ticketsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TicketsNotifier create() => TicketsNotifier();

  @override
  bool operator ==(Object other) {
    return other is TicketsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketsNotifierHash() => r'b4c9b54f3a50758027199576241d61371ffe2dbc';

final class TicketsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          TicketsNotifier,
          AsyncValue<List<Ticket>>,
          List<Ticket>,
          FutureOr<List<Ticket>>,
          bool
        > {
  TicketsNotifierFamily._()
    : super(
        retry: null,
        name: r'ticketsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TicketsNotifierProvider call({bool includeArchived = false}) =>
      TicketsNotifierProvider._(argument: includeArchived, from: this);

  @override
  String toString() => r'ticketsProvider';
}

abstract class _$TicketsNotifier extends $AsyncNotifier<List<Ticket>> {
  late final _$args = ref.$arg as bool;
  bool get includeArchived => _$args;

  FutureOr<List<Ticket>> build({bool includeArchived = false});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Ticket>>, List<Ticket>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Ticket>>, List<Ticket>>,
              AsyncValue<List<Ticket>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(includeArchived: _$args));
  }
}

@ProviderFor(ticketsStream)
final ticketsStreamProvider = TicketsStreamFamily._();

final class TicketsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Ticket>>,
          List<Ticket>,
          Stream<List<Ticket>>
        >
    with $FutureModifier<List<Ticket>>, $StreamProvider<List<Ticket>> {
  TicketsStreamProvider._({
    required TicketsStreamFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'ticketsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketsStreamHash();

  @override
  String toString() {
    return r'ticketsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Ticket>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Ticket>> create(Ref ref) {
    final argument = this.argument as bool;
    return ticketsStream(ref, includeArchived: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TicketsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketsStreamHash() => r'6dd2ebcbfe568246201a1f3dd6c96531c4932496';

final class TicketsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Ticket>>, bool> {
  TicketsStreamFamily._()
    : super(
        retry: null,
        name: r'ticketsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TicketsStreamProvider call({bool includeArchived = false}) =>
      TicketsStreamProvider._(argument: includeArchived, from: this);

  @override
  String toString() => r'ticketsStreamProvider';
}
