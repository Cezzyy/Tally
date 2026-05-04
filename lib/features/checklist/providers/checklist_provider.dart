import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/supabase_service.dart';
import '../data/models/checklist.dart';
import '../data/repositories/checklist_repository.dart';

part 'checklist_provider.g.dart';

@riverpod
ChecklistRepository checklistRepository(Ref ref) {
  return ChecklistRepository(SupabaseService.client);
}

@riverpod
class ChecklistsNotifier extends _$ChecklistsNotifier {
  @override
  Future<List<ChecklistWithStats>> build({bool includeArchived = false}) async {
    return ref
        .read(checklistRepositoryProvider)
        .getChecklists(includeArchived: includeArchived);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(checklistRepositoryProvider)
          .getChecklists(includeArchived: includeArchived),
    );
  }

  Future<void> createChecklist(CreateChecklistDto dto) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(checklistRepositoryProvider).createChecklist(dto);
      return ref
          .read(checklistRepositoryProvider)
          .getChecklists(includeArchived: includeArchived);
    });
  }

  Future<void> updateChecklist(String id, UpdateChecklistDto dto) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(checklistRepositoryProvider).updateChecklist(id, dto);
      return ref
          .read(checklistRepositoryProvider)
          .getChecklists(includeArchived: includeArchived);
    });
  }

  Future<void> deleteChecklist(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(checklistRepositoryProvider).deleteChecklist(id);
      return ref
          .read(checklistRepositoryProvider)
          .getChecklists(includeArchived: includeArchived);
    });
  }

  Future<void> archiveChecklist(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(checklistRepositoryProvider).archiveChecklist(id);
      return ref
          .read(checklistRepositoryProvider)
          .getChecklists(includeArchived: includeArchived);
    });
  }

  Future<void> unarchiveChecklist(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(checklistRepositoryProvider).unarchiveChecklist(id);
      return ref
          .read(checklistRepositoryProvider)
          .getChecklists(includeArchived: includeArchived);
    });
  }
}

@riverpod
Stream<List<ChecklistWithStats>> checklistsStream(
  Ref ref, {
  bool includeArchived = false,
}) {
  return ref
      .read(checklistRepositoryProvider)
      .watchChecklists(includeArchived: includeArchived);
}
