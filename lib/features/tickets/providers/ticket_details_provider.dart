import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/ticket.dart';
import '../data/models/ticket_checklist_item.dart';
import '../data/repositories/ticket_checklist_repository.dart';
import 'ticket_provider.dart';

part 'ticket_details_provider.g.dart';

@riverpod
class TicketDetails extends _$TicketDetails {
  @override
  Future<TicketWithChecklist> build(String ticketId) async {
    final ticketRepo = ref.watch(ticketRepositoryProvider);
    final checklistRepo = ref.watch(ticketChecklistRepositoryProvider);

    final ticket = await ticketRepo.getTicketById(ticketId);
    final checklistItems = await checklistRepo.getChecklistItems(ticketId);

    return TicketWithChecklist(ticket: ticket, checklistItems: checklistItems);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(ticketId));
  }

  Future<void> updateTicket(UpdateTicketDto dto) async {
    final ticketRepo = ref.read(ticketRepositoryProvider);
    await ticketRepo.updateTicket(ticketId, dto);
    await refresh();
  }

  Future<void> addChecklistItem(String task) async {
    final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
    final currentState = state.value;

    if (currentState == null) return;

    final displayOrder = currentState.checklistItems.length;

    await checklistRepo.createChecklistItem(
      CreateTicketChecklistItemDto(
        ticketId: ticketId,
        task: task,
        displayOrder: displayOrder,
      ),
    );

    await refresh();
  }

  Future<void> updateChecklistItem(
    String itemId,
    UpdateTicketChecklistItemDto dto,
  ) async {
    final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
    await checklistRepo.updateChecklistItem(itemId, dto);
    await refresh();
  }

  Future<void> toggleChecklistItem(String itemId, bool isCompleted) async {
    final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
    await checklistRepo.toggleChecklistItem(itemId, isCompleted);
    await refresh();
  }

  Future<void> deleteChecklistItem(String itemId) async {
    final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
    await checklistRepo.deleteChecklistItem(itemId);
    await refresh();
  }

  Future<void> reorderChecklistItems(List<String> itemIds) async {
    final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
    await checklistRepo.reorderChecklistItems(ticketId, itemIds);
    await refresh();
  }
}
