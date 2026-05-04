import 'package:json_annotation/json_annotation.dart';

part 'checklist_item.g.dart';

@JsonSerializable()
class ChecklistItem {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'checklist_id')
  final String checklistId;
  final String task;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  @JsonKey(name: 'user_id')
  final String userId;

  const ChecklistItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.checklistId,
    required this.task,
    required this.isCompleted,
    this.completedAt,
    required this.displayOrder,
    required this.userId,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistItemToJson(this);

  ChecklistItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? checklistId,
    String? task,
    bool? isCompleted,
    DateTime? completedAt,
    int? displayOrder,
    String? userId,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      checklistId: checklistId ?? this.checklistId,
      task: task ?? this.task,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      displayOrder: displayOrder ?? this.displayOrder,
      userId: userId ?? this.userId,
    );
  }
}

@JsonSerializable()
class CreateChecklistItemDto {
  @JsonKey(name: 'checklist_id')
  final String checklistId;
  final String task;
  @JsonKey(name: 'display_order')
  final int displayOrder;

  const CreateChecklistItemDto({
    required this.checklistId,
    required this.task,
    this.displayOrder = 0,
  });

  factory CreateChecklistItemDto.fromJson(Map<String, dynamic> json) =>
      _$CreateChecklistItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChecklistItemDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class UpdateChecklistItemDto {
  final String? task;
  @JsonKey(name: 'is_completed')
  final bool? isCompleted;
  @JsonKey(name: 'display_order')
  final int? displayOrder;

  const UpdateChecklistItemDto({
    this.task,
    this.isCompleted,
    this.displayOrder,
  });

  factory UpdateChecklistItemDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateChecklistItemDtoFromJson(json);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (task != null) json['task'] = task;
    if (isCompleted != null) json['is_completed'] = isCompleted;
    if (displayOrder != null) json['display_order'] = displayOrder;
    return json;
  }
}
