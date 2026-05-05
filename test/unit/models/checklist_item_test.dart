import 'package:flutter_test/flutter_test.dart';
import 'package:tally/features/checklist/data/models/checklist_item.dart';

void main() {
  group('ChecklistItem Model', () {
    final testDate = DateTime(2024, 1, 1);
    final completedDate = DateTime(2024, 1, 5);

    final testItem = ChecklistItem(
      id: 'item-id',
      createdAt: testDate,
      updatedAt: testDate,
      checklistId: 'checklist-id',
      task: 'Test Task',
      isCompleted: false,
      completedAt: null,
      displayOrder: 0,
      userId: 'user-123',
    );

    group('JSON Serialization', () {
      test('fromJson creates valid ChecklistItem object', () {
        final json = {
          'id': 'item-id',
          'created_at': testDate.toIso8601String(),
          'updated_at': testDate.toIso8601String(),
          'checklist_id': 'checklist-id',
          'task': 'Test Task',
          'is_completed': false,
          'completed_at': null,
          'display_order': 0,
          'user_id': 'user-123',
        };

        final item = ChecklistItem.fromJson(json);

        expect(item.id, 'item-id');
        expect(item.checklistId, 'checklist-id');
        expect(item.task, 'Test Task');
        expect(item.isCompleted, false);
        expect(item.completedAt, null);
        expect(item.displayOrder, 0);
        expect(item.userId, 'user-123');
      });

      test('toJson creates valid JSON map', () {
        final json = testItem.toJson();

        expect(json['id'], 'item-id');
        expect(json['checklist_id'], 'checklist-id');
        expect(json['task'], 'Test Task');
        expect(json['is_completed'], false);
        expect(json['completed_at'], null);
        expect(json['display_order'], 0);
        expect(json['user_id'], 'user-123');
      });

      test('fromJson handles completed item with completedAt', () {
        final json = {
          'id': 'item-id',
          'created_at': testDate.toIso8601String(),
          'updated_at': testDate.toIso8601String(),
          'checklist_id': 'checklist-id',
          'task': 'Test Task',
          'is_completed': true,
          'completed_at': completedDate.toIso8601String(),
          'display_order': 0,
          'user_id': 'user-123',
        };

        final item = ChecklistItem.fromJson(json);

        expect(item.isCompleted, true);
        expect(item.completedAt, completedDate);
      });

      test('toJson includes completedAt when present', () {
        final completedItem = testItem.copyWith(
          isCompleted: true,
          completedAt: completedDate,
        );

        final json = completedItem.toJson();

        expect(json['is_completed'], true);
        expect(json['completed_at'], completedDate.toIso8601String());
      });
    });

    group('copyWith Method', () {
      test('copyWith creates new instance with updated fields', () {
        final updated = testItem.copyWith(
          task: 'Updated Task',
          isCompleted: true,
        );

        expect(updated.task, 'Updated Task');
        expect(updated.isCompleted, true);
        expect(updated.id, testItem.id);
        expect(updated.checklistId, testItem.checklistId);
      });

      test('copyWith without parameters returns identical values', () {
        final copy = testItem.copyWith();

        expect(copy.id, testItem.id);
        expect(copy.task, testItem.task);
        expect(copy.isCompleted, testItem.isCompleted);
        expect(copy.displayOrder, testItem.displayOrder);
      });

      test('copyWith can update all fields', () {
        final newDate = DateTime(2024, 2, 1);
        final updated = testItem.copyWith(
          id: 'new-id',
          createdAt: newDate,
          updatedAt: newDate,
          checklistId: 'new-checklist-id',
          task: 'New Task',
          isCompleted: true,
          completedAt: newDate,
          displayOrder: 5,
          userId: 'user-456',
        );

        expect(updated.id, 'new-id');
        expect(updated.createdAt, newDate);
        expect(updated.updatedAt, newDate);
        expect(updated.checklistId, 'new-checklist-id');
        expect(updated.task, 'New Task');
        expect(updated.isCompleted, true);
        expect(updated.completedAt, newDate);
        expect(updated.displayOrder, 5);
        expect(updated.userId, 'user-456');
      });
    });

    group('Display Order', () {
      test('items can have different display orders', () {
        final item1 = testItem.copyWith(displayOrder: 0);
        final item2 = testItem.copyWith(displayOrder: 1);
        final item3 = testItem.copyWith(displayOrder: 2);

        expect(item1.displayOrder, 0);
        expect(item2.displayOrder, 1);
        expect(item3.displayOrder, 2);
      });
    });
  });

  group('CreateChecklistItemDto', () {
    test('toJson creates valid JSON with all fields', () {
      final dto = CreateChecklistItemDto(
        checklistId: 'checklist-id',
        task: 'New Task',
        displayOrder: 5,
      );

      final json = dto.toJson();

      expect(json['checklist_id'], 'checklist-id');
      expect(json['task'], 'New Task');
      expect(json['display_order'], 5);
    });

    test('toJson uses default display order when not provided', () {
      final dto = CreateChecklistItemDto(
        checklistId: 'checklist-id',
        task: 'New Task',
      );

      final json = dto.toJson();

      expect(json['display_order'], 0);
    });

    test('fromJson creates valid DTO', () {
      final json = {
        'checklist_id': 'checklist-id',
        'task': 'New Task',
        'display_order': 3,
      };

      final dto = CreateChecklistItemDto.fromJson(json);

      expect(dto.checklistId, 'checklist-id');
      expect(dto.task, 'New Task');
      expect(dto.displayOrder, 3);
    });
  });

  group('UpdateChecklistItemDto', () {
    test('toJson only includes non-null fields', () {
      final dto = UpdateChecklistItemDto(
        task: 'Updated Task',
        isCompleted: true,
      );

      final json = dto.toJson();

      expect(json.containsKey('task'), true);
      expect(json.containsKey('is_completed'), true);
      expect(json.containsKey('display_order'), false);
      expect(json['task'], 'Updated Task');
      expect(json['is_completed'], true);
    });

    test('toJson returns empty map when all fields are null', () {
      const dto = UpdateChecklistItemDto();

      final json = dto.toJson();

      expect(json.isEmpty, true);
    });

    test('toJson includes all fields when provided', () {
      final dto = UpdateChecklistItemDto(
        task: 'Updated Task',
        isCompleted: true,
        displayOrder: 10,
      );

      final json = dto.toJson();

      expect(json['task'], 'Updated Task');
      expect(json['is_completed'], true);
      expect(json['display_order'], 10);
    });

    test('fromJson creates valid DTO', () {
      final json = {
        'task': 'Updated Task',
        'is_completed': false,
        'display_order': 7,
      };

      final dto = UpdateChecklistItemDto.fromJson(json);

      expect(dto.task, 'Updated Task');
      expect(dto.isCompleted, false);
      expect(dto.displayOrder, 7);
    });

    test('can toggle completion status', () {
      final dto = UpdateChecklistItemDto(isCompleted: true);
      final json = dto.toJson();

      expect(json['is_completed'], true);
      expect(json.containsKey('task'), false);
    });
  });
}
