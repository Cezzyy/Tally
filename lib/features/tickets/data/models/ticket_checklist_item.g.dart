// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_checklist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketChecklistItem _$TicketChecklistItemFromJson(Map<String, dynamic> json) =>
    TicketChecklistItem(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      ticketId: json['ticket_id'] as String,
      task: json['task'] as String,
      isCompleted: json['is_completed'] as bool,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      displayOrder: (json['display_order'] as num).toInt(),
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$TicketChecklistItemToJson(
  TicketChecklistItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'ticket_id': instance.ticketId,
  'task': instance.task,
  'is_completed': instance.isCompleted,
  'completed_at': instance.completedAt?.toIso8601String(),
  'display_order': instance.displayOrder,
  'user_id': instance.userId,
};

CreateTicketChecklistItemDto _$CreateTicketChecklistItemDtoFromJson(
  Map<String, dynamic> json,
) => CreateTicketChecklistItemDto(
  ticketId: json['ticket_id'] as String,
  task: json['task'] as String,
  displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CreateTicketChecklistItemDtoToJson(
  CreateTicketChecklistItemDto instance,
) => <String, dynamic>{
  'ticket_id': instance.ticketId,
  'task': instance.task,
  'display_order': instance.displayOrder,
};

UpdateTicketChecklistItemDto _$UpdateTicketChecklistItemDtoFromJson(
  Map<String, dynamic> json,
) => UpdateTicketChecklistItemDto(
  task: json['task'] as String?,
  isCompleted: json['is_completed'] as bool?,
  displayOrder: (json['display_order'] as num?)?.toInt(),
);
