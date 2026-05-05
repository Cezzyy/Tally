import 'package:flutter_test/flutter_test.dart';
import 'package:tally/features/checklist/data/models/checklist.dart';

void main() {
  group('Checklist Model', () {
    final testDate = DateTime(2024, 1, 1);
    final testDueDate = DateTime(2024, 1, 15);

    final testChecklist = Checklist(
      id: 'checklist-id',
      createdAt: testDate,
      updatedAt: testDate,
      title: 'Test Checklist',
      description: 'Test Description',
      status: ChecklistStatus.pending,
      priority: ChecklistPriority.medium,
      dueDate: testDueDate,
      isArchived: false,
      archivedAt: null,
      userId: 'user-123',
    );

    group('JSON Serialization', () {
      test('fromJson creates valid Checklist object', () {
        final json = {
          'id': 'checklist-id',
          'created_at': testDate.toIso8601String(),
          'updated_at': testDate.toIso8601String(),
          'title': 'Test Checklist',
          'description': 'Test Description',
          'status': 'pending',
          'priority': 'medium',
          'due_date': testDueDate.toIso8601String(),
          'is_archived': false,
          'archived_at': null,
          'user_id': 'user-123',
        };

        final checklist = Checklist.fromJson(json);

        expect(checklist.id, 'checklist-id');
        expect(checklist.title, 'Test Checklist');
        expect(checklist.description, 'Test Description');
        expect(checklist.status, ChecklistStatus.pending);
        expect(checklist.priority, ChecklistPriority.medium);
        expect(checklist.dueDate, testDueDate);
        expect(checklist.isArchived, false);
        expect(checklist.archivedAt, null);
        expect(checklist.userId, 'user-123');
      });

      test('toJson creates valid JSON map', () {
        final json = testChecklist.toJson();

        expect(json['id'], 'checklist-id');
        expect(json['title'], 'Test Checklist');
        expect(json['description'], 'Test Description');
        expect(json['status'], 'pending');
        expect(json['priority'], 'medium');
        expect(json['due_date'], testDueDate.toIso8601String());
        expect(json['is_archived'], false);
        expect(json['archived_at'], null);
        expect(json['user_id'], 'user-123');
      });

      test('fromJson handles null optional fields', () {
        final json = {
          'id': 'checklist-id',
          'created_at': testDate.toIso8601String(),
          'updated_at': testDate.toIso8601String(),
          'title': 'Test Checklist',
          'description': null,
          'status': 'pending',
          'priority': 'medium',
          'due_date': null,
          'is_archived': false,
          'archived_at': null,
          'user_id': 'user-123',
        };

        final checklist = Checklist.fromJson(json);

        expect(checklist.description, null);
        expect(checklist.dueDate, null);
        expect(checklist.archivedAt, null);
      });
    });

    group('Enum Mapping', () {
      test('ChecklistStatus enum values map correctly', () {
        expect(ChecklistStatus.pending.name, 'pending');
        expect(ChecklistStatus.inProgress.name, 'inProgress');
        expect(ChecklistStatus.completed.name, 'completed');
      });

      test('ChecklistPriority enum values map correctly', () {
        expect(ChecklistPriority.low.name, 'low');
        expect(ChecklistPriority.medium.name, 'medium');
        expect(ChecklistPriority.high.name, 'high');
      });

      test('fromJson correctly parses all status values', () {
        final statuses = ['pending', 'in_progress', 'completed'];
        final expectedStatuses = [
          ChecklistStatus.pending,
          ChecklistStatus.inProgress,
          ChecklistStatus.completed,
        ];

        for (var i = 0; i < statuses.length; i++) {
          final json = {
            'id': 'test-id',
            'created_at': testDate.toIso8601String(),
            'updated_at': testDate.toIso8601String(),
            'title': 'Test',
            'status': statuses[i],
            'priority': 'medium',
            'is_archived': false,
            'user_id': 'user-123',
          };

          final checklist = Checklist.fromJson(json);
          expect(checklist.status, expectedStatuses[i]);
        }
      });

      test('fromJson correctly parses all priority values', () {
        final priorities = ['low', 'medium', 'high'];
        final expectedPriorities = [
          ChecklistPriority.low,
          ChecklistPriority.medium,
          ChecklistPriority.high,
        ];

        for (var i = 0; i < priorities.length; i++) {
          final json = {
            'id': 'test-id',
            'created_at': testDate.toIso8601String(),
            'updated_at': testDate.toIso8601String(),
            'title': 'Test',
            'status': 'pending',
            'priority': priorities[i],
            'is_archived': false,
            'user_id': 'user-123',
          };

          final checklist = Checklist.fromJson(json);
          expect(checklist.priority, expectedPriorities[i]);
        }
      });
    });

    group('copyWith Method', () {
      test('copyWith creates new instance with updated fields', () {
        final updated = testChecklist.copyWith(
          title: 'Updated Title',
          status: ChecklistStatus.inProgress,
        );

        expect(updated.title, 'Updated Title');
        expect(updated.status, ChecklistStatus.inProgress);
        expect(updated.id, testChecklist.id);
        expect(updated.description, testChecklist.description);
      });

      test('copyWith without parameters returns identical values', () {
        final copy = testChecklist.copyWith();

        expect(copy.id, testChecklist.id);
        expect(copy.title, testChecklist.title);
        expect(copy.description, testChecklist.description);
        expect(copy.status, testChecklist.status);
        expect(copy.priority, testChecklist.priority);
      });

      test('copyWith can update all fields', () {
        final newDate = DateTime(2024, 2, 1);
        final updated = testChecklist.copyWith(
          id: 'new-id',
          createdAt: newDate,
          updatedAt: newDate,
          title: 'New Title',
          description: 'New Description',
          status: ChecklistStatus.completed,
          priority: ChecklistPriority.high,
          dueDate: newDate,
          isArchived: true,
          archivedAt: newDate,
          userId: 'user-456',
        );

        expect(updated.id, 'new-id');
        expect(updated.createdAt, newDate);
        expect(updated.updatedAt, newDate);
        expect(updated.title, 'New Title');
        expect(updated.description, 'New Description');
        expect(updated.status, ChecklistStatus.completed);
        expect(updated.priority, ChecklistPriority.high);
        expect(updated.dueDate, newDate);
        expect(updated.isArchived, true);
        expect(updated.archivedAt, newDate);
        expect(updated.userId, 'user-456');
      });
    });
  });

  group('CreateChecklistDto', () {
    test('toJson creates valid JSON with all fields', () {
      final dueDate = DateTime(2024, 1, 15);
      final dto = CreateChecklistDto(
        title: 'New Checklist',
        description: 'New Description',
        status: ChecklistStatus.pending,
        priority: ChecklistPriority.high,
        dueDate: dueDate,
      );

      final json = dto.toJson();

      expect(json['title'], 'New Checklist');
      expect(json['description'], 'New Description');
      expect(json['status'], 'pending');
      expect(json['priority'], 'high');
      expect(json['due_date'], dueDate.toIso8601String());
    });

    test('toJson uses default values when not provided', () {
      final dto = CreateChecklistDto(
        title: 'New Checklist',
      );

      final json = dto.toJson();

      expect(json['status'], 'pending');
      expect(json['priority'], 'medium');
      expect(json['description'], null);
      expect(json['due_date'], null);
    });

    test('fromJson creates valid DTO', () {
      final dueDate = DateTime(2024, 1, 15);
      final json = {
        'title': 'New Checklist',
        'description': 'New Description',
        'status': 'in_progress',
        'priority': 'high',
        'due_date': dueDate.toIso8601String(),
      };

      final dto = CreateChecklistDto.fromJson(json);

      expect(dto.title, 'New Checklist');
      expect(dto.description, 'New Description');
      expect(dto.status, ChecklistStatus.inProgress);
      expect(dto.priority, ChecklistPriority.high);
      expect(dto.dueDate, dueDate);
    });
  });

  group('UpdateChecklistDto', () {
    test('toJson only includes non-null fields', () {
      final dto = UpdateChecklistDto(
        title: 'Updated Title',
        status: ChecklistStatus.completed,
      );

      final json = dto.toJson();

      expect(json.containsKey('title'), true);
      expect(json.containsKey('status'), true);
      expect(json.containsKey('description'), false);
      expect(json.containsKey('priority'), false);
      expect(json.containsKey('due_date'), false);
      expect(json['title'], 'Updated Title');
      expect(json['status'], 'completed');
    });

    test('toJson returns empty map when all fields are null', () {
      const dto = UpdateChecklistDto();

      final json = dto.toJson();

      expect(json.isEmpty, true);
    });

    test('toJson includes all fields when provided', () {
      final dueDate = DateTime(2024, 1, 15);
      final dto = UpdateChecklistDto(
        title: 'Updated',
        description: 'Updated Description',
        status: ChecklistStatus.inProgress,
        priority: ChecklistPriority.high,
        dueDate: dueDate,
        isArchived: true,
      );

      final json = dto.toJson();

      expect(json['title'], 'Updated');
      expect(json['description'], 'Updated Description');
      expect(json['status'], 'in_progress');
      expect(json['priority'], 'high');
      expect(json['due_date'], dueDate.toIso8601String());
      expect(json['is_archived'], true);
    });

    test('fromJson creates valid DTO', () {
      final json = {
        'title': 'Updated',
        'status': 'completed',
        'priority': 'high',
      };

      final dto = UpdateChecklistDto.fromJson(json);

      expect(dto.title, 'Updated');
      expect(dto.status, ChecklistStatus.completed);
      expect(dto.priority, ChecklistPriority.high);
    });
  });

  group('ChecklistWithStats', () {
    final testDate = DateTime(2024, 1, 1);
    final testChecklist = Checklist(
      id: 'checklist-id',
      createdAt: testDate,
      updatedAt: testDate,
      title: 'Test Checklist',
      description: 'Test Description',
      status: ChecklistStatus.pending,
      priority: ChecklistPriority.medium,
      dueDate: null,
      isArchived: false,
      archivedAt: null,
      userId: 'user-123',
    );

    test('completionPercentage calculates correctly', () {
      final stats = ChecklistWithStats(
        checklist: testChecklist,
        totalItems: 10,
        completedItems: 5,
      );

      expect(stats.completionPercentage, 50.0);
    });

    test('completionPercentage returns 0 when totalItems is 0', () {
      final stats = ChecklistWithStats(
        checklist: testChecklist,
        totalItems: 0,
        completedItems: 0,
      );

      expect(stats.completionPercentage, 0.0);
    });

    test('completionPercentage handles 100% completion', () {
      final stats = ChecklistWithStats(
        checklist: testChecklist,
        totalItems: 5,
        completedItems: 5,
      );

      expect(stats.completionPercentage, 100.0);
    });

    test('isCompleted returns true when all items completed', () {
      final stats = ChecklistWithStats(
        checklist: testChecklist,
        totalItems: 5,
        completedItems: 5,
      );

      expect(stats.isCompleted, true);
    });

    test('isCompleted returns false when not all items completed', () {
      final stats = ChecklistWithStats(
        checklist: testChecklist,
        totalItems: 5,
        completedItems: 3,
      );

      expect(stats.isCompleted, false);
    });

    test('isCompleted returns false when totalItems is 0', () {
      final stats = ChecklistWithStats(
        checklist: testChecklist,
        totalItems: 0,
        completedItems: 0,
      );

      expect(stats.isCompleted, false);
    });

    test('delegates properties to underlying checklist', () {
      final stats = ChecklistWithStats(
        checklist: testChecklist,
        totalItems: 5,
        completedItems: 3,
      );

      expect(stats.id, testChecklist.id);
      expect(stats.title, testChecklist.title);
      expect(stats.description, testChecklist.description);
      expect(stats.status, testChecklist.status);
      expect(stats.priority, testChecklist.priority);
      expect(stats.userId, testChecklist.userId);
      expect(stats.isArchived, testChecklist.isArchived);
    });
  });
}
