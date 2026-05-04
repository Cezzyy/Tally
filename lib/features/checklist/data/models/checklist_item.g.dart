// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    ChecklistItem(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      checklistId: json['checklist_id'] as String,
      task: json['task'] as String,
      isCompleted: json['is_completed'] as bool,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      displayOrder: (json['display_order'] as num).toInt(),
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$ChecklistItemToJson(ChecklistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'checklist_id': instance.checklistId,
      'task': instance.task,
      'is_completed': instance.isCompleted,
      'completed_at': instance.completedAt?.toIso8601String(),
      'display_order': instance.displayOrder,
      'user_id': instance.userId,
    };

CreateChecklistItemDto _$CreateChecklistItemDtoFromJson(
  Map<String, dynamic> json,
) => CreateChecklistItemDto(
  checklistId: json['checklist_id'] as String,
  task: json['task'] as String,
  displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CreateChecklistItemDtoToJson(
  CreateChecklistItemDto instance,
) => <String, dynamic>{
  'checklist_id': instance.checklistId,
  'task': instance.task,
  'display_order': instance.displayOrder,
};

UpdateChecklistItemDto _$UpdateChecklistItemDtoFromJson(
  Map<String, dynamic> json,
) => UpdateChecklistItemDto(
  task: json['task'] as String?,
  isCompleted: json['is_completed'] as bool?,
  displayOrder: (json['display_order'] as num?)?.toInt(),
);
