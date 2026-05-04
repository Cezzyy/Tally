import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';
import '../models/checklist.dart';

class ChecklistRepository {
  final SupabaseClient _supabase;

  ChecklistRepository(this._supabase);

  Future<List<ChecklistWithStats>> getChecklists({
    bool includeArchived = false,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Fetch checklists
      final baseQuery = _supabase
          .from('checklists')
          .select()
          .eq('user_id', userId);

      final checklistsResponse = includeArchived
          ? await baseQuery.order('created_at', ascending: false)
          : await baseQuery
                .eq('is_archived', false)
                .order('created_at', ascending: false);

      final checklists = (checklistsResponse as List)
          .map((json) => Checklist.fromJson(json))
          .toList();

      // Fetch item counts for all checklists
      final checklistIds = checklists.map((c) => c.id).toList();

      if (checklistIds.isEmpty) {
        return [];
      }

      final itemsResponse = await _supabase
          .from('checklist_items')
          .select('checklist_id, is_completed')
          .inFilter('checklist_id', checklistIds);

      // Calculate counts per checklist
      final countsMap = <String, Map<String, int>>{};
      for (final item in itemsResponse as List) {
        final checklistId = item['checklist_id'] as String;
        final isCompleted = item['is_completed'] as bool;

        countsMap.putIfAbsent(checklistId, () => {'total': 0, 'completed': 0});
        countsMap[checklistId]!['total'] =
            countsMap[checklistId]!['total']! + 1;
        if (isCompleted) {
          countsMap[checklistId]!['completed'] =
              countsMap[checklistId]!['completed']! + 1;
        }
      }

      // Combine checklists with their stats
      final checklistsWithStats = checklists.map((checklist) {
        final counts = countsMap[checklist.id] ?? {'total': 0, 'completed': 0};
        return ChecklistWithStats(
          checklist: checklist,
          totalItems: counts['total']!,
          completedItems: counts['completed']!,
        );
      }).toList();

      AppLogger.instance.info(
        'Fetched ${checklistsWithStats.length} checklists',
      );
      return checklistsWithStats;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to fetch checklists', e, stackTrace);
      rethrow;
    }
  }

  Future<Checklist> getChecklistById(String id) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('checklists')
          .select()
          .eq('id', id)
          .eq('user_id', userId)
          .single();

      final checklist = Checklist.fromJson(response);
      AppLogger.instance.info('Fetched checklist: ${checklist.id}');
      return checklist;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to fetch checklist', e, stackTrace);
      rethrow;
    }
  }

  Future<Checklist> createChecklist(CreateChecklistDto dto) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final data = dto.toJson();
      data['user_id'] = userId;

      final response = await _supabase
          .from('checklists')
          .insert(data)
          .select()
          .single();

      final checklist = Checklist.fromJson(response);
      AppLogger.instance.info('Created checklist: ${checklist.id}');
      return checklist;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to create checklist', e, stackTrace);
      rethrow;
    }
  }

  Future<Checklist> updateChecklist(String id, UpdateChecklistDto dto) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final data = dto.toJson();
      if (data.isEmpty) {
        throw Exception('No fields to update');
      }

      final response = await _supabase
          .from('checklists')
          .update(data)
          .eq('id', id)
          .eq('user_id', userId)
          .select()
          .single();

      final checklist = Checklist.fromJson(response);
      AppLogger.instance.info('Updated checklist: ${checklist.id}');
      return checklist;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to update checklist', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteChecklist(String id) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('checklists')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);

      AppLogger.instance.info('Deleted checklist: $id');
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to delete checklist', e, stackTrace);
      rethrow;
    }
  }

  Future<Checklist> archiveChecklist(String id) async {
    return updateChecklist(id, const UpdateChecklistDto(isArchived: true));
  }

  Future<Checklist> unarchiveChecklist(String id) async {
    return updateChecklist(id, const UpdateChecklistDto(isArchived: false));
  }

  Stream<List<ChecklistWithStats>> watchChecklists({
    bool includeArchived = false,
  }) {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return Stream.error(Exception('User not authenticated'));
    }

    // Note: This is a simplified version. For real-time updates of counts,
    // you'd need to watch both tables and combine them
    return _supabase
        .from('checklists')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .asyncMap((checklistsData) async {
          var checklists = checklistsData
              .map((json) => Checklist.fromJson(json))
              .toList();

          if (!includeArchived) {
            checklists = checklists.where((c) => !c.isArchived).toList();
          }

          if (checklists.isEmpty) {
            return <ChecklistWithStats>[];
          }

          // Fetch item counts
          final checklistIds = checklists.map((c) => c.id).toList();
          final itemsResponse = await _supabase
              .from('checklist_items')
              .select('checklist_id, is_completed')
              .inFilter('checklist_id', checklistIds);

          // Calculate counts
          final countsMap = <String, Map<String, int>>{};
          for (final item in itemsResponse as List) {
            final checklistId = item['checklist_id'] as String;
            final isCompleted = item['is_completed'] as bool;

            countsMap.putIfAbsent(
              checklistId,
              () => {'total': 0, 'completed': 0},
            );
            countsMap[checklistId]!['total'] =
                countsMap[checklistId]!['total']! + 1;
            if (isCompleted) {
              countsMap[checklistId]!['completed'] =
                  countsMap[checklistId]!['completed']! + 1;
            }
          }

          return checklists.map((checklist) {
            final counts =
                countsMap[checklist.id] ?? {'total': 0, 'completed': 0};
            return ChecklistWithStats(
              checklist: checklist,
              totalItems: counts['total']!,
              completedItems: counts['completed']!,
            );
          }).toList();
        });
  }
}
