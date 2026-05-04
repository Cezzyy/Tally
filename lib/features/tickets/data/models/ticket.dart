import 'package:json_annotation/json_annotation.dart';

part 'ticket.g.dart';

enum TicketStatus {
  @JsonValue('backlog')
  backlog,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('done')
  done,
}

enum TicketPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

@JsonSerializable()
class Ticket {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'ticket_number')
  final int ticketNumber;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @JsonKey(name: 'is_archived')
  final bool isArchived;
  @JsonKey(name: 'archived_at')
  final DateTime? archivedAt;
  @JsonKey(name: 'user_id')
  final String userId;

  const Ticket({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.ticketNumber,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.isArchived,
    this.archivedAt,
    required this.userId,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);

  Ticket copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? ticketNumber,
    String? title,
    String? description,
    TicketStatus? status,
    TicketPriority? priority,
    DateTime? dueDate,
    bool? isArchived,
    DateTime? archivedAt,
    String? userId,
  }) {
    return Ticket(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
      userId: userId ?? this.userId,
    );
  }
}

@JsonSerializable()
class CreateTicketDto {
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;

  const CreateTicketDto({
    required this.title,
    required this.description,
    this.status = TicketStatus.backlog,
    this.priority = TicketPriority.medium,
    this.dueDate,
  });

  factory CreateTicketDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTicketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTicketDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class UpdateTicketDto {
  final String? title;
  final String? description;
  final TicketStatus? status;
  final TicketPriority? priority;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @JsonKey(name: 'is_archived')
  final bool? isArchived;

  const UpdateTicketDto({
    this.title,
    this.description,
    this.status,
    this.priority,
    this.dueDate,
    this.isArchived,
  });

  factory UpdateTicketDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTicketDtoFromJson(json);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (title != null) json['title'] = title;
    if (description != null) json['description'] = description;
    if (status != null) json['status'] = _$TicketStatusEnumMap[status];
    if (priority != null) json['priority'] = _$TicketPriorityEnumMap[priority];
    if (dueDate != null) json['due_date'] = dueDate!.toIso8601String();
    if (isArchived != null) json['is_archived'] = isArchived;
    return json;
  }
}
