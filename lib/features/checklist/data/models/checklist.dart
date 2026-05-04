import 'package:json_annotation/json_annotation.dart';

part 'checklist.g.dart';

enum ChecklistStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
}

enum ChecklistPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
}

@JsonSerializable()
class Checklist {
  final String id;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String title;
  final String? description;
  final ChecklistStatus status;
  final ChecklistPriority priority;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @JsonKey(name: 'is_archived')
  final bool isArchived;
  @JsonKey(name: 'archived_at')
  final DateTime? archivedAt;
  @JsonKey(name: 'user_id')
  final String userId;

  const Checklist({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.isArchived,
    this.archivedAt,
    required this.userId,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) =>
      _$ChecklistFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistToJson(this);

  Checklist copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? description,
    ChecklistStatus? status,
    ChecklistPriority? priority,
    DateTime? dueDate,
    bool? isArchived,
    DateTime? archivedAt,
    String? userId,
  }) {
    return Checklist(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
class CreateChecklistDto {
  final String title;
  final String? description;
  final ChecklistStatus status;
  final ChecklistPriority priority;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;

  const CreateChecklistDto({
    required this.title,
    this.description,
    this.status = ChecklistStatus.pending,
    this.priority = ChecklistPriority.medium,
    this.dueDate,
  });

  factory CreateChecklistDto.fromJson(Map<String, dynamic> json) =>
      _$CreateChecklistDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChecklistDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class UpdateChecklistDto {
  final String? title;
  final String? description;
  final ChecklistStatus? status;
  final ChecklistPriority? priority;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @JsonKey(name: 'is_archived')
  final bool? isArchived;

  const UpdateChecklistDto({
    this.title,
    this.description,
    this.status,
    this.priority,
    this.dueDate,
    this.isArchived,
  });

  factory UpdateChecklistDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateChecklistDtoFromJson(json);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (title != null) json['title'] = title;
    if (description != null) json['description'] = description;
    if (status != null) json['status'] = _$ChecklistStatusEnumMap[status];
    if (priority != null) {
      json['priority'] = _$ChecklistPriorityEnumMap[priority];
    }
    if (dueDate != null) json['due_date'] = dueDate!.toIso8601String();
    if (isArchived != null) json['is_archived'] = isArchived;
    return json;
  }
}

/// Checklist with computed statistics from checklist_items
class ChecklistWithStats {
  final Checklist checklist;
  final int totalItems;
  final int completedItems;

  const ChecklistWithStats({
    required this.checklist,
    required this.totalItems,
    required this.completedItems,
  });

  double get completionPercentage {
    if (totalItems == 0) return 0.0;
    return (completedItems / totalItems) * 100;
  }

  bool get isCompleted => totalItems > 0 && completedItems == totalItems;

  String get id => checklist.id;
  DateTime get createdAt => checklist.createdAt;
  DateTime get updatedAt => checklist.updatedAt;
  String get title => checklist.title;
  String? get description => checklist.description;
  ChecklistStatus get status => checklist.status;
  ChecklistPriority get priority => checklist.priority;
  DateTime? get dueDate => checklist.dueDate;
  bool get isArchived => checklist.isArchived;
  DateTime? get archivedAt => checklist.archivedAt;
  String get userId => checklist.userId;
}
