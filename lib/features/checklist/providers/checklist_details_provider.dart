import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/supabase_service.dart';
import '../data/models/checklist.dart';
import '../data/models/checklist_item.dart';
import '../data/repositories/checklist_item_repository.dart';
import 'checklist_provider.dart';

part 'checklist_details_provider.g.dart';

@riverpod
ChecklistItemRepository checklistItemRepository(Ref ref) {
  return ChecklistItemRepository(SupabaseService.client);
}

/// Combined model for checklist with its items
class ChecklistWithItems {
  final Checklist checklist;
  final List<ChecklistItem> items;

  const ChecklistWithItems({required this.checklist, required this.items});

  int get totalItems => items.length;

  int get completedItems => items.where((item) => item.isCompleted).length;

  double get completionPercentage {
    if (totalItems == 0) return 0.0;
    return (completedItems / totalItems) * 100;
  }

  bool get hasItems => items.isNotEmpty;
}

@riverpod
class ChecklistDetails extends _$ChecklistDetails {
  @override
  Future<ChecklistWithItems> build(String checklistId) async {
    final checklist = await ref
        .read(checklistRepositoryProvider)
        .getChecklistById(checklistId);

    final items = await ref
        .read(checklistItemRepositoryProvider)
        .getChecklistItems(checklistId);

    return ChecklistWithItems(checklist: checklist, items: items);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(checklistId));
  }

  Future<void> updateChecklist(UpdateChecklistDto dto) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    final updatedChecklist = currentState.checklist.copyWith(
      title: dto.title ?? currentState.checklist.title,
      description: dto.description ?? currentState.checklist.description,
      status: dto.status ?? currentState.checklist.status,
      priority: dto.priority ?? currentState.checklist.priority,
      dueDate: dto.dueDate ?? currentState.checklist.dueDate,
      isArchived: dto.isArchived ?? currentState.checklist.isArchived,
      updatedAt: DateTime.now(),
    );

    state = AsyncValue.data(
      ChecklistWithItems(
        checklist: updatedChecklist,
        items: currentState.items,
      ),
    );

    // Perform actual update in background
    try {
      final checklistRepo = ref.read(checklistRepositoryProvider);
      await checklistRepo.updateChecklist(checklistId, dto);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentState);
      rethrow;
    }
  }

  Future<void> addChecklistItem(String task) async {
    final currentState = state.value;
    if (currentState == null) return;

    final displayOrder = currentState.items.length;

    // Create temporary item for optimistic update
    final tempItem = ChecklistItem(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      checklistId: checklistId,
      task: task,
      isCompleted: false,
      completedAt: null,
      displayOrder: displayOrder,
      userId: '', // Will be set by server
    );

    // Optimistic update
    state = AsyncValue.data(
      ChecklistWithItems(
        checklist: currentState.checklist,
        items: [...currentState.items, tempItem],
      ),
    );

    // Perform actual creation in background
    try {
      final itemRepo = ref.read(checklistItemRepositoryProvider);
      final newItem = await itemRepo.createChecklistItem(
        CreateChecklistItemDto(
          checklistId: checklistId,
          task: task,
          displayOrder: displayOrder,
        ),
      );

      // Replace temp item with real item
      final updatedItems = currentState.items.toList()..add(newItem);
      state = AsyncValue.data(
        ChecklistWithItems(
          checklist: currentState.checklist,
          items: updatedItems,
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
    UpdateChecklistItemDto dto,
  ) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    final updatedItems = currentState.items.map((item) {
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
      ChecklistWithItems(
        checklist: currentState.checklist,
        items: updatedItems,
      ),
    );

    // Perform actual update in background
    try {
      final itemRepo = ref.read(checklistItemRepositoryProvider);
      await itemRepo.updateChecklistItem(itemId, dto);
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
    final updatedItems = currentState.items.map((item) {
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
      ChecklistWithItems(
        checklist: currentState.checklist,
        items: updatedItems,
      ),
    );

    // Perform actual update in background
    try {
      final itemRepo = ref.read(checklistItemRepositoryProvider);
      await itemRepo.toggleChecklistItem(itemId, isCompleted);
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
    final updatedItems = currentState.items
        .where((item) => item.id != itemId)
        .toList();

    state = AsyncValue.data(
      ChecklistWithItems(
        checklist: currentState.checklist,
        items: updatedItems,
      ),
    );

    // Perform actual deletion in background
    try {
      final itemRepo = ref.read(checklistItemRepositoryProvider);
      await itemRepo.deleteChecklistItem(itemId);
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentState);
      rethrow;
    }
  }
}
