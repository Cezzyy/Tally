import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';
import '../models/ticket.dart';

class TicketRepository {
  final SupabaseClient _supabase;

  TicketRepository(this._supabase);

  Future<List<Ticket>> getTickets({bool includeArchived = false}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final baseQuery = _supabase
          .from('tickets')
          .select()
          .eq('user_id', userId);

      final response = includeArchived
          ? await baseQuery.order('created_at', ascending: false)
          : await baseQuery
                .eq('is_archived', false)
                .order('created_at', ascending: false);

      final tickets = (response as List)
          .map((json) => Ticket.fromJson(json))
          .toList();

      AppLogger.instance.info('Fetched ${tickets.length} tickets');
      return tickets;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to fetch tickets', e, stackTrace);
      rethrow;
    }
  }

  Future<Ticket> getTicketById(String id) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('tickets')
          .select()
          .eq('id', id)
          .eq('user_id', userId)
          .single();

      final ticket = Ticket.fromJson(response);
      AppLogger.instance.info('Fetched ticket: ${ticket.id}');
      return ticket;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to fetch ticket', e, stackTrace);
      rethrow;
    }
  }

  Future<Ticket> createTicket(CreateTicketDto dto) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final data = dto.toJson();
      data['user_id'] = userId;

      final response = await _supabase
          .from('tickets')
          .insert(data)
          .select()
          .single();

      final ticket = Ticket.fromJson(response);
      AppLogger.instance.info('Created ticket: ${ticket.id}');
      return ticket;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to create ticket', e, stackTrace);
      rethrow;
    }
  }

  Future<Ticket> updateTicket(String id, UpdateTicketDto dto) async {
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
          .from('tickets')
          .update(data)
          .eq('id', id)
          .eq('user_id', userId)
          .select()
          .single();

      final ticket = Ticket.fromJson(response);
      AppLogger.instance.info('Updated ticket: ${ticket.id}');
      return ticket;
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to update ticket', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteTicket(String id) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('tickets')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);

      AppLogger.instance.info('Deleted ticket: $id');
    } catch (e, stackTrace) {
      AppLogger.instance.error('Failed to delete ticket', e, stackTrace);
      rethrow;
    }
  }

  Future<Ticket> archiveTicket(String id) async {
    return updateTicket(id, const UpdateTicketDto(isArchived: true));
  }

  Future<Ticket> unarchiveTicket(String id) async {
    return updateTicket(id, const UpdateTicketDto(isArchived: false));
  }

  Stream<List<Ticket>> watchTickets({bool includeArchived = false}) {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return Stream.error(Exception('User not authenticated'));
    }

    return _supabase
        .from('tickets')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) {
          var tickets = data.map((json) => Ticket.fromJson(json)).toList();

          if (!includeArchived) {
            tickets = tickets.where((t) => !t.isArchived).toList();
          }

          return tickets;
        });
  }
}
