import 'package:flutter_test/flutter_test.dart';
import 'package:tally/features/tickets/data/models/ticket.dart';

void main() {
  group('Ticket Model', () {
    final testDate = DateTime(2024, 1, 1);
    final testDueDate = DateTime(2024, 1, 15);

    final testTicket = Ticket(
      id: 'test-id',
      createdAt: testDate,
      updatedAt: testDate,
      ticketNumber: 1,
      title: 'Test Ticket',
      description: 'Test Description',
      status: TicketStatus.backlog,
      priority: TicketPriority.medium,
      dueDate: testDueDate,
      isArchived: false,
      archivedAt: null,
      userId: 'user-123',
    );

    group('JSON Serialization', () {
      test('fromJson creates valid Ticket object', () {
        final json = {
          'id': 'test-id',
          'created_at': testDate.toIso8601String(),
          'updated_at': testDate.toIso8601String(),
          'ticket_number': 1,
          'title': 'Test Ticket',
          'description': 'Test Description',
          'status': 'backlog',
          'priority': 'medium',
          'due_date': testDueDate.toIso8601String(),
          'is_archived': false,
          'archived_at': null,
          'user_id': 'user-123',
        };

        final ticket = Ticket.fromJson(json);

        expect(ticket.id, 'test-id');
        expect(ticket.ticketNumber, 1);
        expect(ticket.title, 'Test Ticket');
        expect(ticket.description, 'Test Description');
        expect(ticket.status, TicketStatus.backlog);
        expect(ticket.priority, TicketPriority.medium);
        expect(ticket.dueDate, testDueDate);
        expect(ticket.isArchived, false);
        expect(ticket.archivedAt, null);
        expect(ticket.userId, 'user-123');
      });

      test('toJson creates valid JSON map', () {
        final json = testTicket.toJson();

        expect(json['id'], 'test-id');
        expect(json['ticket_number'], 1);
        expect(json['title'], 'Test Ticket');
        expect(json['description'], 'Test Description');
        expect(json['status'], 'backlog');
        expect(json['priority'], 'medium');
        expect(json['due_date'], testDueDate.toIso8601String());
        expect(json['is_archived'], false);
        expect(json['archived_at'], null);
        expect(json['user_id'], 'user-123');
      });

      test('fromJson handles null optional fields', () {
        final json = {
          'id': 'test-id',
          'created_at': testDate.toIso8601String(),
          'updated_at': testDate.toIso8601String(),
          'ticket_number': 1,
          'title': 'Test Ticket',
          'description': 'Test Description',
          'status': 'backlog',
          'priority': 'medium',
          'due_date': null,
          'is_archived': false,
          'archived_at': null,
          'user_id': 'user-123',
        };

        final ticket = Ticket.fromJson(json);

        expect(ticket.dueDate, null);
        expect(ticket.archivedAt, null);
      });
    });

    group('Enum Mapping', () {
      test('TicketStatus enum values map correctly', () {
        expect(TicketStatus.backlog.name, 'backlog');
        expect(TicketStatus.inProgress.name, 'inProgress');
        expect(TicketStatus.done.name, 'done');
      });

      test('TicketPriority enum values map correctly', () {
        expect(TicketPriority.low.name, 'low');
        expect(TicketPriority.medium.name, 'medium');
        expect(TicketPriority.high.name, 'high');
        expect(TicketPriority.urgent.name, 'urgent');
      });

      test('fromJson correctly parses all status values', () {
        final statuses = ['backlog', 'in_progress', 'done'];
        final expectedStatuses = [
          TicketStatus.backlog,
          TicketStatus.inProgress,
          TicketStatus.done,
        ];

        for (var i = 0; i < statuses.length; i++) {
          final json = {
            'id': 'test-id',
            'created_at': testDate.toIso8601String(),
            'updated_at': testDate.toIso8601String(),
            'ticket_number': 1,
            'title': 'Test',
            'description': 'Test',
            'status': statuses[i],
            'priority': 'medium',
            'is_archived': false,
            'user_id': 'user-123',
          };

          final ticket = Ticket.fromJson(json);
          expect(ticket.status, expectedStatuses[i]);
        }
      });

      test('fromJson correctly parses all priority values', () {
        final priorities = ['low', 'medium', 'high', 'urgent'];
        final expectedPriorities = [
          TicketPriority.low,
          TicketPriority.medium,
          TicketPriority.high,
          TicketPriority.urgent,
        ];

        for (var i = 0; i < priorities.length; i++) {
          final json = {
            'id': 'test-id',
            'created_at': testDate.toIso8601String(),
            'updated_at': testDate.toIso8601String(),
            'ticket_number': 1,
            'title': 'Test',
            'description': 'Test',
            'status': 'backlog',
            'priority': priorities[i],
            'is_archived': false,
            'user_id': 'user-123',
          };

          final ticket = Ticket.fromJson(json);
          expect(ticket.priority, expectedPriorities[i]);
        }
      });
    });

    group('copyWith Method', () {
      test('copyWith creates new instance with updated fields', () {
        final updated = testTicket.copyWith(
          title: 'Updated Title',
          status: TicketStatus.inProgress,
        );

        expect(updated.title, 'Updated Title');
        expect(updated.status, TicketStatus.inProgress);
        expect(updated.id, testTicket.id);
        expect(updated.description, testTicket.description);
      });

      test('copyWith without parameters returns identical values', () {
        final copy = testTicket.copyWith();

        expect(copy.id, testTicket.id);
        expect(copy.title, testTicket.title);
        expect(copy.description, testTicket.description);
        expect(copy.status, testTicket.status);
        expect(copy.priority, testTicket.priority);
      });

      test('copyWith can update all fields', () {
        final newDate = DateTime(2024, 2, 1);
        final updated = testTicket.copyWith(
          id: 'new-id',
          createdAt: newDate,
          updatedAt: newDate,
          ticketNumber: 2,
          title: 'New Title',
          description: 'New Description',
          status: TicketStatus.done,
          priority: TicketPriority.urgent,
          dueDate: newDate,
          isArchived: true,
          archivedAt: newDate,
          userId: 'user-456',
        );

        expect(updated.id, 'new-id');
        expect(updated.createdAt, newDate);
        expect(updated.updatedAt, newDate);
        expect(updated.ticketNumber, 2);
        expect(updated.title, 'New Title');
        expect(updated.description, 'New Description');
        expect(updated.status, TicketStatus.done);
        expect(updated.priority, TicketPriority.urgent);
        expect(updated.dueDate, newDate);
        expect(updated.isArchived, true);
        expect(updated.archivedAt, newDate);
        expect(updated.userId, 'user-456');
      });
    });
  });

  group('CreateTicketDto', () {
    test('toJson creates valid JSON with all fields', () {
      final dueDate = DateTime(2024, 1, 15);
      final dto = CreateTicketDto(
        title: 'New Ticket',
        description: 'New Description',
        status: TicketStatus.backlog,
        priority: TicketPriority.high,
        dueDate: dueDate,
      );

      final json = dto.toJson();

      expect(json['title'], 'New Ticket');
      expect(json['description'], 'New Description');
      expect(json['status'], 'backlog');
      expect(json['priority'], 'high');
      expect(json['due_date'], dueDate.toIso8601String());
    });

    test('toJson uses default values when not provided', () {
      final dto = CreateTicketDto(
        title: 'New Ticket',
        description: 'New Description',
      );

      final json = dto.toJson();

      expect(json['status'], 'backlog');
      expect(json['priority'], 'medium');
      expect(json['due_date'], null);
    });

    test('fromJson creates valid DTO', () {
      final dueDate = DateTime(2024, 1, 15);
      final json = {
        'title': 'New Ticket',
        'description': 'New Description',
        'status': 'in_progress',
        'priority': 'urgent',
        'due_date': dueDate.toIso8601String(),
      };

      final dto = CreateTicketDto.fromJson(json);

      expect(dto.title, 'New Ticket');
      expect(dto.description, 'New Description');
      expect(dto.status, TicketStatus.inProgress);
      expect(dto.priority, TicketPriority.urgent);
      expect(dto.dueDate, dueDate);
    });
  });

  group('UpdateTicketDto', () {
    test('toJson only includes non-null fields', () {
      final dto = UpdateTicketDto(
        title: 'Updated Title',
        status: TicketStatus.done,
      );

      final json = dto.toJson();

      expect(json.containsKey('title'), true);
      expect(json.containsKey('status'), true);
      expect(json.containsKey('description'), false);
      expect(json.containsKey('priority'), false);
      expect(json.containsKey('due_date'), false);
      expect(json['title'], 'Updated Title');
      expect(json['status'], 'done');
    });

    test('toJson returns empty map when all fields are null', () {
      const dto = UpdateTicketDto();

      final json = dto.toJson();

      expect(json.isEmpty, true);
    });

    test('toJson includes all fields when provided', () {
      final dueDate = DateTime(2024, 1, 15);
      final dto = UpdateTicketDto(
        title: 'Updated',
        description: 'Updated Description',
        status: TicketStatus.inProgress,
        priority: TicketPriority.urgent,
        dueDate: dueDate,
        isArchived: true,
      );

      final json = dto.toJson();

      expect(json['title'], 'Updated');
      expect(json['description'], 'Updated Description');
      expect(json['status'], 'in_progress');
      expect(json['priority'], 'urgent');
      expect(json['due_date'], dueDate.toIso8601String());
      expect(json['is_archived'], true);
    });

    test('fromJson creates valid DTO', () {
      final json = {
        'title': 'Updated',
        'status': 'done',
        'priority': 'high',
      };

      final dto = UpdateTicketDto.fromJson(json);

      expect(dto.title, 'Updated');
      expect(dto.status, TicketStatus.done);
      expect(dto.priority, TicketPriority.high);
    });
  });
}
