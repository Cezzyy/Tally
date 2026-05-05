import 'package:json_annotation/json_annotation.dart';
import 'ticket.dart';

part 'ticket_checklist_item.g.dart';

@JsonSerializable()
class TicketChecklistItem {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'ticket_id')
  final String ticketId;
  final String task;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @JsonKey(name: 'user_id')
  final String userId;

  const TicketChecklistItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.ticketId,
    required this.task,
    required this.isCompleted,
    this.completedAt,
    required this.displayOrder,
    required this.userId,
  });

  factory TicketChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$TicketChecklistItemFromJson(json);

  Map<String, dynamic> toJson() => _$TicketChecklistItemToJson(this);

  TicketChecklistItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ticketId,
    String? task,
    bool? isCompleted,
    DateTime? completedAt,
    int? displayOrder,
    String? userId,
  }) {
    return TicketChecklistItem(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ticketId: ticketId ?? this.ticketId,
      task: task ?? this.task,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      displayOrder: displayOrder ?? this.displayOrder,
      userId: userId ?? this.userId,
    );
  }
}

@JsonSerializable()
class CreateTicketChecklistItemDto {
  @JsonKey(name: 'ticket_id')
  final String ticketId;
  final String task;
  @JsonKey(name: 'display_order')
  final int displayOrder;

  const CreateTicketChecklistItemDto({
    required this.ticketId,
    required this.task,
    this.displayOrder = 0,
  });

  factory CreateTicketChecklistItemDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTicketChecklistItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTicketChecklistItemDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class UpdateTicketChecklistItemDto {
  final String? task;
  @JsonKey(name: 'is_completed')
  final bool? isCompleted;
  @JsonKey(name: 'display_order')
  final int? displayOrder;

  const UpdateTicketChecklistItemDto({
    this.task,
    this.isCompleted,
    this.displayOrder,
  });

  factory UpdateTicketChecklistItemDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateTicketChecklistItemDtoFromJson(json);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (task != null) json['task'] = task;
    if (isCompleted != null) json['is_completed'] = isCompleted;
    if (displayOrder != null) json['display_order'] = displayOrder;
    return json;
  }
}

/// Ticket with checklist items
class TicketWithChecklist {
  final Ticket ticket;
  final List<TicketChecklistItem> checklistItems;

  const TicketWithChecklist({
    required this.ticket,
    required this.checklistItems,
  });

  int get totalItems => checklistItems.length;
  
  int get completedItems =>
      checklistItems.where((item) => item.isCompleted).length;

  double get completionPercentage {
    if (totalItems == 0) return 0.0;
    return (completedItems / totalItems) * 100;
  }

  bool get hasChecklist => totalItems > 0;
}
