import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/supabase_service.dart';
import '../data/models/ticket.dart';
import '../data/repositories/ticket_repository.dart';

part 'ticket_provider.g.dart';

@riverpod
TicketRepository ticketRepository(Ref ref) {
  return TicketRepository(SupabaseService.client);
}

@riverpod
class TicketsNotifier extends _$TicketsNotifier {
  @override
  Future<List<Ticket>> build({bool includeArchived = false}) async {
    return ref
        .read(ticketRepositoryProvider)
        .getTickets(includeArchived: includeArchived);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(ticketRepositoryProvider)
          .getTickets(includeArchived: includeArchived),
    );
  }

  Future<void> createTicket(CreateTicketDto dto) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(ticketRepositoryProvider).createTicket(dto);
      return ref
          .read(ticketRepositoryProvider)
          .getTickets(includeArchived: includeArchived);
    });
  }

  Future<void> updateTicket(String id, UpdateTicketDto dto) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(ticketRepositoryProvider).updateTicket(id, dto);
      return ref
          .read(ticketRepositoryProvider)
          .getTickets(includeArchived: includeArchived);
    });
  }

  Future<void> deleteTicket(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(ticketRepositoryProvider).deleteTicket(id);
      return ref
          .read(ticketRepositoryProvider)
          .getTickets(includeArchived: includeArchived);
    });
  }

  Future<void> archiveTicket(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(ticketRepositoryProvider).archiveTicket(id);
      return ref
          .read(ticketRepositoryProvider)
          .getTickets(includeArchived: includeArchived);
    });
  }

  Future<void> unarchiveTicket(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(ticketRepositoryProvider).unarchiveTicket(id);
      return ref
          .read(ticketRepositoryProvider)
          .getTickets(includeArchived: includeArchived);
    });
  }
}

@riverpod
Stream<List<Ticket>> ticketsStream(Ref ref, {bool includeArchived = false}) {
  return ref
      .read(ticketRepositoryProvider)
      .watchTickets(includeArchived: includeArchived);
}
