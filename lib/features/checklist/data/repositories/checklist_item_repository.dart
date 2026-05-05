import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';
import '../models/checklist_item.dart';

class ChecklistItemRepository {
  final SupabaseClient _supabase;

  ChecklistItemRepository(this._supabase);

  Future<List<ChecklistItem>> getChecklistItems(String checklistId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('checklist_items')
          .select()
          .eq('checklist_id', checklistId)
          .eq('user_id', userId)
          .order('display_order', ascending: true)
          .order('created_at', ascending: true);

      final items = (response as List)
          .map((json) => ChecklistItem.fromJson(json))
          .toList();

      AppLogger.instance.info(
        'Fetched ${items.length} items for checklist $checklistId',
      );
      return items;
    } catch (e, stackTrace) {
      AppLogger.instance.error(
        'Failed to fetch checklist items',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<ChecklistItem> createChecklistItem(CreateChecklistItemDto dto) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final data = dto.toJson();
      data['user_id'] = userId;

      final response = await _supabase
          .from('checklist_items')
          .insert(data)
          .select()
          .single();

      final item = ChecklistItem.fromJson(response);
      AppLogger.instance.info('Created checklist item: ${item.id}');
      return item;
    } catch (e, stackTrace) {
      AppLogger.instance.error(
        'Failed to create checklist item',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<ChecklistItem> updateChecklistItem(
    String id,
    UpdateChecklistItemDto dto,
  ) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final data = dto.toJson();
      if (data.isEmpty) {
        throw Exception('No fields to update');
      }

      // If marking as completed, set completed_at
      if (dto.isCompleted == true) {
        data['completed_at'] = DateTime.now().toIso8601String();
      } else if (dto.isCompleted == false) {
        data['completed_at'] = null;
      }

      final response = await _supabase
          .from('checklist_items')
          .update(data)
          .eq('id', id)
          .eq('user_id', userId)
          .select()
          .single();

      final item = ChecklistItem.fromJson(response);
      AppLogger.instance.info('Updated checklist item: ${item.id}');
      return item;
    } catch (e, stackTrace) {
      AppLogger.instance.error(
        'Failed to update checklist item',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> deleteChecklistItem(String id) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('checklist_items')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);

      AppLogger.instance.info('Deleted checklist item: $id');
    } catch (e, stackTrace) {
      AppLogger.instance.error(
        'Failed to delete checklist item',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<ChecklistItem> toggleChecklistItem(String id, bool isCompleted) async {
    return updateChecklistItem(
      id,
      UpdateChecklistItemDto(isCompleted: isCompleted),
    );
  }
}
