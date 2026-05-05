// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_checklist_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ticketChecklistRepository)
final ticketChecklistRepositoryProvider = TicketChecklistRepositoryProvider._();

final class TicketChecklistRepositoryProvider
    extends
        $FunctionalProvider<
          TicketChecklistRepository,
          TicketChecklistRepository,
          TicketChecklistRepository
        >
    with $Provider<TicketChecklistRepository> {
  TicketChecklistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketChecklistRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketChecklistRepositoryHash();

  @$internal
  @override
  $ProviderElement<TicketChecklistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TicketChecklistRepository create(Ref ref) {
    return ticketChecklistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketChecklistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketChecklistRepository>(value),
    );
  }
}

String _$ticketChecklistRepositoryHash() =>
    r'b8cbf867378650dfe0789d81291fe6290a23b5e6';
