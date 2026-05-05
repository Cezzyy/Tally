import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/ticket_checklist_item.dart';

part 'ticket_checklist_repository.g.dart';

@riverpod
TicketChecklistRepository ticketChecklistRepository(Ref ref) {
  return TicketChecklistRepository();
}

class TicketChecklistRepository {
  TicketChecklistRepository();

  Future<List<TicketChecklistItem>> getChecklistItems(String ticketId) async {
    final response = await SupabaseService.client
        .from('ticket_checklist_items')
        .select()
        .eq('ticket_id', ticketId)
        .order('display_order', ascending: true)
        .order('created_at', ascending: true);

    return (response as List)
        .map((json) => TicketChecklistItem.fromJson(json))
        .toList();
  }

  Future<TicketChecklistItem> createChecklistItem(
    CreateTicketChecklistItemDto dto,
  ) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await SupabaseService.client
        .from('ticket_checklist_items')
        .insert({...dto.toJson(), 'user_id': userId})
        .select()
        .single();

    return TicketChecklistItem.fromJson(response);
  }

  Future<TicketChecklistItem> updateChecklistItem(
    String id,
    UpdateTicketChecklistItemDto dto,
  ) async {
    final response = await SupabaseService.client
        .from('ticket_checklist_items')
        .update(dto.toJson())
        .eq('id', id)
        .select()
        .single();

    return TicketChecklistItem.fromJson(response);
  }

  Future<void> deleteChecklistItem(String id) async {
    await SupabaseService.client
        .from('ticket_checklist_items')
        .delete()
        .eq('id', id);
  }

  Future<void> toggleChecklistItem(String id, bool isCompleted) async {
    await SupabaseService.client
        .from('ticket_checklist_items')
        .update({'is_completed': isCompleted})
        .eq('id', id);
  }

  Future<void> reorderChecklistItems(
    String ticketId,
    List<String> itemIds,
  ) async {
    for (var i = 0; i < itemIds.length; i++) {
      await SupabaseService.client
          .from('ticket_checklist_items')
          .update({'display_order': i})
          .eq('id', itemIds[i])
          .eq('ticket_id', ticketId);
    }
  }
}
