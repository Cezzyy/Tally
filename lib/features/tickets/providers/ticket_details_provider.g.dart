// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TicketDetails)
final ticketDetailsProvider = TicketDetailsFamily._();

final class TicketDetailsProvider
    extends $AsyncNotifierProvider<TicketDetails, TicketWithChecklist> {
  TicketDetailsProvider._({
    required TicketDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ticketDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketDetailsHash();

  @override
  String toString() {
    return r'ticketDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TicketDetails create() => TicketDetails();

  @override
  bool operator ==(Object other) {
    return other is TicketDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketDetailsHash() => r'cd85aae04a5d22d1a0f5d0b7230aaa7764f3fdb2';

final class TicketDetailsFamily extends $Family
    with
        $ClassFamilyOverride<
          TicketDetails,
          AsyncValue<TicketWithChecklist>,
          TicketWithChecklist,
          FutureOr<TicketWithChecklist>,
          String
        > {
  TicketDetailsFamily._()
    : super(
        retry: null,
        name: r'ticketDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TicketDetailsProvider call(String ticketId) =>
      TicketDetailsProvider._(argument: ticketId, from: this);

  @override
  String toString() => r'ticketDetailsProvider';
}

abstract class _$TicketDetails extends $AsyncNotifier<TicketWithChecklist> {
  late final _$args = ref.$arg as String;
  String get ticketId => _$args;

  FutureOr<TicketWithChecklist> build(String ticketId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TicketWithChecklist>, TicketWithChecklist>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TicketWithChecklist>, TicketWithChecklist>,
              AsyncValue<TicketWithChecklist>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
