// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Checklist _$ChecklistFromJson(Map<String, dynamic> json) => Checklist(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  title: json['title'] as String,
  description: json['description'] as String?,
  status: $enumDecode(_$ChecklistStatusEnumMap, json['status']),
  priority: $enumDecode(_$ChecklistPriorityEnumMap, json['priority']),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  isArchived: json['is_archived'] as bool,
  archivedAt: json['archived_at'] == null
      ? null
      : DateTime.parse(json['archived_at'] as String),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ChecklistToJson(Checklist instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'title': instance.title,
  'description': instance.description,
  'status': _$ChecklistStatusEnumMap[instance.status]!,
  'priority': _$ChecklistPriorityEnumMap[instance.priority]!,
  'due_date': instance.dueDate?.toIso8601String(),
  'is_archived': instance.isArchived,
  'archived_at': instance.archivedAt?.toIso8601String(),
  'user_id': instance.userId,
};

const _$ChecklistStatusEnumMap = {
  ChecklistStatus.pending: 'pending',
  ChecklistStatus.inProgress: 'in_progress',
  ChecklistStatus.completed: 'completed',
};

const _$ChecklistPriorityEnumMap = {
  ChecklistPriority.low: 'low',
  ChecklistPriority.medium: 'medium',
  ChecklistPriority.high: 'high',
};

CreateChecklistDto _$CreateChecklistDtoFromJson(Map<String, dynamic> json) =>
    CreateChecklistDto(
      title: json['title'] as String,
      description: json['description'] as String?,
      status:
          $enumDecodeNullable(_$ChecklistStatusEnumMap, json['status']) ??
          ChecklistStatus.pending,
      priority:
          $enumDecodeNullable(_$ChecklistPriorityEnumMap, json['priority']) ??
          ChecklistPriority.medium,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
    );

Map<String, dynamic> _$CreateChecklistDtoToJson(CreateChecklistDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'status': _$ChecklistStatusEnumMap[instance.status]!,
      'priority': _$ChecklistPriorityEnumMap[instance.priority]!,
      'due_date': instance.dueDate?.toIso8601String(),
    };

UpdateChecklistDto _$UpdateChecklistDtoFromJson(Map<String, dynamic> json) =>
    UpdateChecklistDto(
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: $enumDecodeNullable(_$ChecklistStatusEnumMap, json['status']),
      priority: $enumDecodeNullable(
        _$ChecklistPriorityEnumMap,
        json['priority'],
      ),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      isArchived: json['is_archived'] as bool?,
    );
