import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../data/models/checklist.dart';

class ChecklistFormDialog extends StatefulWidget {
  final Checklist? checklist;
  final Future<void> Function(dynamic) onSubmit;

  const ChecklistFormDialog({
    super.key,
    this.checklist,
    required this.onSubmit,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    Checklist? checklist,
    required Future<void> Function(dynamic) onSubmit,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        showDragHandle: true,
        useSafeArea: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ChecklistFormDialog(checklist: checklist, onSubmit: onSubmit),
        ),
      );
    } else {
      return showDialog<T>(
        context: context,
        builder: (context) =>
            ChecklistFormDialog(checklist: checklist, onSubmit: onSubmit),
      );
    }
  }

  @override
  State<ChecklistFormDialog> createState() => _ChecklistFormDialogState();
}

class _ChecklistFormDialogState extends State<ChecklistFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late ChecklistStatus _status;
  late ChecklistPriority _priority;
  DateTime? _dueDate;
  bool _isSubmitting = false;

  bool get _isEditing => widget.checklist != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.checklist?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.checklist?.description ?? '',
    );
    _status = widget.checklist?.status ?? ChecklistStatus.pending;
    _priority = widget.checklist?.priority ?? ChecklistPriority.medium;
    _dueDate = widget.checklist?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final content = Padding(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _isEditing ? 'Edit Checklist' : 'Create Checklist',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter checklist title',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: AppConstants.maxTitleLength,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        hintText: 'Enter checklist description',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      maxLength: AppConstants.maxDescriptionLength,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ChecklistStatus>(
                      initialValue: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: ChecklistStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(_getStatusLabel(status)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _status = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ChecklistPriority>(
                      initialValue: _priority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: ChecklistPriority.values.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(priority),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(_getPriorityLabel(priority)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _priority = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _selectDueDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Due Date (Optional)',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(
                          _dueDate == null
                              ? 'Select due date'
                              : DateFormat('MMM d, y').format(_dueDate!),
                          style: _dueDate == null
                              ? context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                )
                              : null,
                        ),
                      ),
                    ),
                    if (_dueDate != null) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => setState(() => _dueDate = null),
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Clear due date'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isSubmitting
                    ? null
                    : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ],
      ),
    );

    if (isMobile) {
      return content;
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppConstants.maxFormWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: content,
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      if (_isEditing) {
        final dto = UpdateChecklistDto(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          status: _status,
          priority: _priority,
          dueDate: _dueDate,
        );
        await widget.onSubmit(dto);
      } else {
        final dto = CreateChecklistDto(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          status: _status,
          priority: _priority,
          dueDate: _dueDate,
        );
        await widget.onSubmit(dto);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        context.showSnackBar(
          'Failed to ${_isEditing ? 'update' : 'create'} checklist',
          isError: true,
        );
      }
    }
  }

  String _getStatusLabel(ChecklistStatus status) {
    switch (status) {
      case ChecklistStatus.pending:
        return 'Pending';
      case ChecklistStatus.inProgress:
        return 'In Progress';
      case ChecklistStatus.completed:
        return 'Completed';
    }
  }

  String _getPriorityLabel(ChecklistPriority priority) {
    switch (priority) {
      case ChecklistPriority.low:
        return 'Low';
      case ChecklistPriority.medium:
        return 'Medium';
      case ChecklistPriority.high:
        return 'High';
    }
  }

  Color _getPriorityColor(ChecklistPriority priority) {
    switch (priority) {
      case ChecklistPriority.high:
        return Colors.red.shade700;
      case ChecklistPriority.medium:
        return Colors.orange;
      case ChecklistPriority.low:
        return Colors.blue;
    }
  }
}
