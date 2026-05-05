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
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    final updatedTicket = currentState.ticket.copyWith(
      title: dto.title ?? currentState.ticket.title,
      description: dto.description ?? currentState.ticket.description,
      status: dto.status ?? currentState.ticket.status,
      priority: dto.priority ?? currentState.ticket.priority,
      dueDate: dto.dueDate ?? currentState.ticket.dueDate,
      isArchived: dto.isArchived ?? currentState.ticket.isArchived,
      updatedAt: DateTime.now(),
    );

    state = AsyncValue.data(
      TicketWithChecklist(
        ticket: updatedTicket,
        checklistItems: currentState.checklistItems,
      ),
    );

    // Perform actual update in background
    try {
      final ticketRepo = ref.read(ticketRepositoryProvider);
      await ticketRepo.updateTicket(ticketId, dto);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentState);
      rethrow;
    }
  }

  Future<void> addChecklistItem(String task) async {
    final currentState = state.value;
    if (currentState == null) return;

    final displayOrder = currentState.checklistItems.length;

    // Create temporary item for optimistic update
    final tempItem = TicketChecklistItem(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      ticketId: ticketId,
      task: task,
      isCompleted: false,
      completedAt: null,
      displayOrder: displayOrder,
      userId: '', // Will be set by server
    );

    // Optimistic update
    state = AsyncValue.data(
      TicketWithChecklist(
        ticket: currentState.ticket,
        checklistItems: [...currentState.checklistItems, tempItem],
      ),
    );

    // Perform actual creation in background
    try {
      final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
      final newItem = await checklistRepo.createChecklistItem(
        CreateTicketChecklistItemDto(
          ticketId: ticketId,
          task: task,
          displayOrder: displayOrder,
        ),
      );

      // Replace temp item with real item
      final updatedItems = currentState.checklistItems.toList()..add(newItem);
      state = AsyncValue.data(
        TicketWithChecklist(
          ticket: currentState.ticket,
          checklistItems: updatedItems,
        ),
      );
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentState);
      rethrow;
    }
  }

  Future<void> updateChecklistItem(
    String itemId,
    UpdateTicketChecklistItemDto dto,
  ) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    final updatedItems = currentState.checklistItems.map((item) {
      if (item.id == itemId) {
        return item.copyWith(
          task: dto.task ?? item.task,
          isCompleted: dto.isCompleted ?? item.isCompleted,
          displayOrder: dto.displayOrder ?? item.displayOrder,
          updatedAt: DateTime.now(),
        );
      }
      return item;
    }).toList();

    state = AsyncValue.data(
      TicketWithChecklist(
        ticket: currentState.ticket,
        checklistItems: updatedItems,
      ),
    );

    // Perform actual update in background
    try {
      final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
      await checklistRepo.updateChecklistItem(itemId, dto);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentState);
      rethrow;
    }
  }

  Future<void> toggleChecklistItem(String itemId, bool isCompleted) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    final updatedItems = currentState.checklistItems.map((item) {
      if (item.id == itemId) {
        return item.copyWith(
          isCompleted: isCompleted,
          completedAt: isCompleted ? DateTime.now() : null,
          updatedAt: DateTime.now(),
        );
      }
      return item;
    }).toList();

    state = AsyncValue.data(
      TicketWithChecklist(
        ticket: currentState.ticket,
        checklistItems: updatedItems,
      ),
    );

    // Perform actual update in background
    try {
      final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
      await checklistRepo.toggleChecklistItem(itemId, isCompleted);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentState);
      rethrow;
    }
  }

  Future<void> deleteChecklistItem(String itemId) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    final updatedItems = currentState.checklistItems
        .where((item) => item.id != itemId)
        .toList();

    state = AsyncValue.data(
      TicketWithChecklist(
        ticket: currentState.ticket,
        checklistItems: updatedItems,
      ),
    );

    // Perform actual deletion in background
    try {
      final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
      await checklistRepo.deleteChecklistItem(itemId);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentState);
      rethrow;
    }
  }

  Future<void> reorderChecklistItems(List<String> itemIds) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    final itemsMap = {for (var item in currentState.checklistItems) item.id: item};
    final reorderedItems = itemIds
        .map((id) => itemsMap[id])
        .whereType<TicketChecklistItem>()
        .toList();

    state = AsyncValue.data(
      TicketWithChecklist(
        ticket: currentState.ticket,
        checklistItems: reorderedItems,
      ),
    );

    // Perform actual reorder in background
    try {
      final checklistRepo = ref.read(ticketChecklistRepositoryProvider);
      await checklistRepo.reorderChecklistItems(ticketId, itemIds);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentState);
      rethrow;
    }
  }
}
