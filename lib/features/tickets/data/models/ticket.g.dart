// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  ticketNumber: (json['ticket_number'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  status: $enumDecode(_$TicketStatusEnumMap, json['status']),
  priority: $enumDecode(_$TicketPriorityEnumMap, json['priority']),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  isArchived: json['is_archived'] as bool,
  archivedAt: json['archived_at'] == null
      ? null
      : DateTime.parse(json['archived_at'] as String),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'ticket_number': instance.ticketNumber,
  'title': instance.title,
  'description': instance.description,
  'status': _$TicketStatusEnumMap[instance.status]!,
  'priority': _$TicketPriorityEnumMap[instance.priority]!,
  'due_date': instance.dueDate?.toIso8601String(),
  'is_archived': instance.isArchived,
  'archived_at': instance.archivedAt?.toIso8601String(),
  'user_id': instance.userId,
};

const _$TicketStatusEnumMap = {
  TicketStatus.backlog: 'backlog',
  TicketStatus.inProgress: 'in_progress',
  TicketStatus.done: 'done',
};

const _$TicketPriorityEnumMap = {
  TicketPriority.low: 'low',
  TicketPriority.medium: 'medium',
  TicketPriority.high: 'high',
  TicketPriority.urgent: 'urgent',
};

CreateTicketDto _$CreateTicketDtoFromJson(Map<String, dynamic> json) =>
    CreateTicketDto(
      title: json['title'] as String,
      description: json['description'] as String,
      status:
          $enumDecodeNullable(_$TicketStatusEnumMap, json['status']) ??
          TicketStatus.backlog,
      priority:
          $enumDecodeNullable(_$TicketPriorityEnumMap, json['priority']) ??
          TicketPriority.medium,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
    );

Map<String, dynamic> _$CreateTicketDtoToJson(CreateTicketDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'status': _$TicketStatusEnumMap[instance.status]!,
      'priority': _$TicketPriorityEnumMap[instance.priority]!,
      'due_date': instance.dueDate?.toIso8601String(),
    };

UpdateTicketDto _$UpdateTicketDtoFromJson(Map<String, dynamic> json) =>
    UpdateTicketDto(
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: $enumDecodeNullable(_$TicketStatusEnumMap, json['status']),
      priority: $enumDecodeNullable(_$TicketPriorityEnumMap, json['priority']),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      isArchived: json['is_archived'] as bool?,
    );
