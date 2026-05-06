import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../data/models/checklist.dart';
import '../../data/models/checklist_item.dart';
import '../../providers/checklist_details_provider.dart';
import '../widgets/checklist_form_dialog.dart';
import '../widgets/checklist_details_skeleton_loader.dart';

class ChecklistDetailsScreen extends ConsumerStatefulWidget {
  final String checklistId;

  const ChecklistDetailsScreen({super.key, required this.checklistId});

  @override
  ConsumerState<ChecklistDetailsScreen> createState() =>
      _ChecklistDetailsScreenState();
}

class _ChecklistDetailsScreenState
    extends ConsumerState<ChecklistDetailsScreen> {
  final TextEditingController _itemController = TextEditingController();
  String? _itemError;

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checklistDetailsAsync = ref.watch(
      checklistDetailsProvider(widget.checklistId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist Details'),
        centerTitle: context.isMobile,
        actions: [
          checklistDetailsAsync.when(
            data: (checklistWithItems) => PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditDialog(checklistWithItems.checklist);
                    break;
                  case 'archive':
                    _toggleArchive(checklistWithItems.checklist);
                    break;
                  case 'delete':
                    _confirmDelete(checklistWithItems.checklist);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'archive',
                  child: Row(
                    children: [
                      Icon(
                        checklistWithItems.checklist.isArchived
                            ? Icons.unarchive
                            : Icons.archive,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        checklistWithItems.checklist.isArchived
                            ? 'Unarchive'
                            : 'Archive',
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          if (!context.isMobile) const SizedBox(width: 8),
        ],
      ),
      body: checklistDetailsAsync.when(
        data: (checklistWithItems) =>
            _buildContent(context, checklistWithItems),
        loading: () => const ChecklistDetailsSkeletonLoader(),
        error: (error, stack) => Center(
          child: Padding(
            padding: EdgeInsets.all(context.isMobile ? 16.0 : 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: context.isMobile ? 64 : 80,
                  color: context.colorScheme.error,
                ),
                SizedBox(height: context.isMobile ? 16 : 24),
                Text(
                  'Failed to load checklist',
                  style: context.isMobile
                      ? context.textTheme.titleLarge
                      : context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => ref
                      .read(
                        checklistDetailsProvider(widget.checklistId).notifier,
                      )
                      .refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: checklistDetailsAsync.when(
        data: (checklistWithItems) =>
            _buildFloatingActionButton(context, checklistWithItems.checklist),
        loading: () => null,
        error: (_, _) => null,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ChecklistWithItems checklistWithItems,
  ) {
    final checklist = checklistWithItems.checklist;
    final spacing = context.isMobile ? 16.0 : (context.isTablet ? 20.0 : 24.0);

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(checklistDetailsProvider(widget.checklistId).notifier)
            .refresh();
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.isDesktop
                  ? AppConstants.maxContentWidth
                  : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, checklist),
                SizedBox(height: spacing * 1.5),
                _buildMetadata(context, checklist),
                SizedBox(height: spacing * 1.5),
                _buildDescription(context, checklist),
                SizedBox(height: spacing * 2),
                _buildItemsSection(context, checklistWithItems),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Checklist checklist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          checklist.title,
          style: context.isMobile
              ? context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )
              : (context.isTablet
                    ? context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    : context.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
        ),
        SizedBox(height: context.isMobile ? 12 : 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _buildStatusChip(context, checklist.status),
            _buildPriorityChip(context, checklist.priority),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, ChecklistStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case ChecklistStatus.pending:
        color = Colors.grey;
        label = 'Pending';
        icon = Icons.pending;
        break;
      case ChecklistStatus.inProgress:
        color = Colors.blue;
        label = 'In Progress';
        icon = Icons.pending_actions;
        break;
      case ChecklistStatus.completed:
        color = Colors.green;
        label = 'Completed';
        icon = Icons.check_circle;
        break;
    }

    return InkWell(
      onTap: () => _showStatusPicker(context, status),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.isMobile ? 10 : 12,
          vertical: context.isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: context.isMobile ? 14 : 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style:
                  (context.isMobile
                          ? context.textTheme.labelMedium
                          : context.textTheme.labelLarge)
                      ?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: context.isMobile ? 16 : 18,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(BuildContext context, ChecklistPriority priority) {
    Color color;
    String label;

    switch (priority) {
      case ChecklistPriority.low:
        color = Colors.blue;
        label = 'Low';
        break;
      case ChecklistPriority.medium:
        color = Colors.orange;
        label = 'Medium';
        break;
      case ChecklistPriority.high:
        color = Colors.red;
        label = 'High';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? 10 : 12,
        vertical: context.isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.isMobile ? 8 : 10,
            height: context.isMobile ? 8 : 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style:
                (context.isMobile
                        ? context.textTheme.labelMedium
                        : context.textTheme.labelLarge)
                    ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, Checklist checklist) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 12.0 : 16.0),
        child: Column(
          children: [
            _buildMetadataRow(
              context,
              icon: Icons.calendar_today,
              label: 'Created',
              value: DateFormat(
                context.isMobile ? 'MMM d, y' : 'MMM d, y • h:mm a',
              ).format(checklist.createdAt),
            ),
            Divider(height: context.isMobile ? 20 : 24),
            _buildMetadataRow(
              context,
              icon: Icons.update,
              label: 'Updated',
              value: DateFormat(
                context.isMobile ? 'MMM d, y' : 'MMM d, y • h:mm a',
              ).format(checklist.updatedAt),
            ),
            if (checklist.dueDate != null) ...[
              Divider(height: context.isMobile ? 20 : 24),
              _buildMetadataRow(
                context,
                icon: Icons.event,
                label: 'Due Date',
                value: DateFormat('MMM d, y').format(checklist.dueDate!),
                valueColor: checklist.dueDate!.isBefore(DateTime.now())
                    ? Colors.red
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: context.isMobile ? 18 : 20,
          color: context.colorScheme.primary,
        ),
        SizedBox(width: context.isMobile ? 10 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style:
                    (context.isMobile
                            ? context.textTheme.bodyMedium
                            : context.textTheme.bodyLarge)
                        ?.copyWith(
                          color: valueColor,
                          fontWeight: FontWeight.w500,
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, Checklist checklist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Description',
              style:
                  (context.isMobile
                          ? context.textTheme.titleMedium
                          : context.textTheme.titleLarge)
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
            ),
            IconButton(
              onPressed: () => _editDescription(checklist),
              icon: const Icon(Icons.edit_outlined),
              iconSize: context.isMobile ? 20 : 22,
              tooltip: 'Edit description',
              color: context.colorScheme.primary,
            ),
          ],
        ),
        SizedBox(height: context.isMobile ? 8 : 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.isMobile ? 16.0 : 20.0),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            checklist.description?.isEmpty ?? true
                ? 'No description provided. Click edit to add one.'
                : checklist.description!,
            style:
                (context.isMobile
                        ? context.textTheme.bodyMedium
                        : context.textTheme.bodyLarge)
                    ?.copyWith(
                      height: 1.6,
                      color: checklist.description?.isEmpty ?? true
                          ? context.colorScheme.onSurface.withValues(alpha: 0.5)
                          : context.colorScheme.onSurface.withValues(
                              alpha: 0.87,
                            ),
                      fontStyle: checklist.description?.isEmpty ?? true
                          ? FontStyle.italic
                          : null,
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(
    BuildContext context,
    ChecklistWithItems checklistWithItems,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items',
                    style:
                        (context.isMobile
                                ? context.textTheme.titleMedium
                                : context.textTheme.titleLarge)
                            ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (checklistWithItems.hasItems) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${checklistWithItems.completedItems}/${checklistWithItems.totalItems} completed',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (checklistWithItems.hasItems)
              Text(
                '${checklistWithItems.completionPercentage.toStringAsFixed(0)}%',
                style:
                    (context.isMobile
                            ? context.textTheme.titleMedium
                            : context.textTheme.titleLarge)
                        ?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
              ),
          ],
        ),
        if (checklistWithItems.hasItems) ...[
          SizedBox(height: context.isMobile ? 8 : 12),
          LinearProgressIndicator(
            value: checklistWithItems.completionPercentage / 100,
            backgroundColor: context.colorScheme.primaryContainer.withValues(
              alpha: 0.3,
            ),
            minHeight: context.isMobile ? 6 : 8,
          ),
        ],
        SizedBox(height: context.isMobile ? 12 : 16),
        _buildAddItem(context),
        SizedBox(height: context.isMobile ? 12 : 16),
        _buildItems(context, checklistWithItems.items),
        SizedBox(height: context.isMobile ? 80 : 100),
      ],
    );
  }

  Widget _buildAddItem(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 8.0 : 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      hintText: 'Add an item...',
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: TextStyle(
                        fontSize: context.isMobile ? 14 : 16,
                      ),
                      errorText: null,
                    ),
                    style: TextStyle(fontSize: context.isMobile ? 14 : 16),
                    onChanged: (value) {
                      if (_itemError != null && value.trim().isNotEmpty) {
                        setState(() {
                          _itemError = null;
                        });
                      }
                    },
                    onSubmitted: (value) => _addItem(),
                  ),
                ),
                IconButton(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add item',
                  iconSize: context.isMobile ? 20 : 24,
                ),
              ],
            ),
            if (_itemError != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: context.colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _itemError!,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItems(BuildContext context, List<ChecklistItem> items) {
    if (items.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(context.isMobile ? 24.0 : 32.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.checklist,
                  size: context.isMobile ? 40 : 48,
                  color: context.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                SizedBox(height: context.isMobile ? 8 : 12),
                Text(
                  'No items yet',
                  style:
                      (context.isMobile
                              ? context.textTheme.bodyMedium
                              : context.textTheme.bodyLarge)
                          ?.copyWith(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildItemTile(context, item);
        },
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, ChecklistItem item) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? 12 : 16,
        vertical: context.isMobile ? 0 : 4,
      ),
      leading: Checkbox(
        value: item.isCompleted,
        onChanged: (value) {
          if (value != null) {
            ref
                .read(checklistDetailsProvider(widget.checklistId).notifier)
                .toggleChecklistItem(item.id, value);
          }
        },
      ),
      title: Text(
        item.task,
        style:
            (context.isMobile
                    ? context.textTheme.bodyMedium
                    : context.textTheme.bodyLarge)
                ?.copyWith(
                  decoration: item.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  color: item.isCompleted
                      ? context.colorScheme.onSurface.withValues(alpha: 0.6)
                      : null,
                ),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              _editItem(item);
              break;
            case 'delete':
              _deleteItem(item);
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 20),
                SizedBox(width: 12),
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 20, color: Colors.red),
                SizedBox(width: 12),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addItem() async {
    final task = _itemController.text.trim();

    if (task.isEmpty) {
      setState(() {
        _itemError = 'Please enter an item';
      });
      return;
    }

    setState(() {
      _itemError = null;
    });

    try {
      await ref
          .read(checklistDetailsProvider(widget.checklistId).notifier)
          .addChecklistItem(task);
      _itemController.clear();
    } catch (e) {
      if (mounted) {
        setState(() {
          _itemError = 'Failed to add item. Please try again.';
        });
      }
    }
  }

  Future<void> _editItem(ChecklistItem item) async {
    final controller = TextEditingController(text: item.task);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Task',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != item.task) {
      try {
        await ref
            .read(checklistDetailsProvider(widget.checklistId).notifier)
            .updateChecklistItem(item.id, UpdateChecklistItemDto(task: result));
      } catch (e) {
        if (mounted) {
          context.showSnackBar('Failed to update item', isError: true);
        }
      }
    }
  }

  Future<void> _deleteItem(ChecklistItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(checklistDetailsProvider(widget.checklistId).notifier)
            .deleteChecklistItem(item.id);
      } catch (e) {
        if (mounted) {
          context.showSnackBar('Failed to delete item', isError: true);
        }
      }
    }
  }

  void _showEditDialog(Checklist checklist) {
    ChecklistFormDialog.show(
      context: context,
      checklist: checklist,
      onSubmit: (dto) async {
        final navigator = Navigator.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        await ref
            .read(checklistDetailsProvider(widget.checklistId).notifier)
            .updateChecklist(dto as UpdateChecklistDto);

        if (mounted) {
          navigator.pop();
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Checklist updated successfully')),
          );
        }
      },
    );
  }

  Future<void> _toggleArchive(Checklist checklist) async {
    try {
      await ref
          .read(checklistDetailsProvider(widget.checklistId).notifier)
          .updateChecklist(
            UpdateChecklistDto(isArchived: !checklist.isArchived),
          );
      if (mounted) {
        context.showSnackBar(
          checklist.isArchived ? 'Checklist unarchived' : 'Checklist archived',
        );
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Failed to update checklist', isError: true);
      }
    }
  }

  Future<void> _confirmDelete(Checklist checklist) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Checklist'),
        content: Text('Are you sure you want to delete "${checklist.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.go('/checklist');
      context.showSnackBar('Checklist deleted');
    }
  }

  Future<void> _showStatusPicker(
    BuildContext context,
    ChecklistStatus currentStatus,
  ) async {
    final isMobile = context.isMobile;

    if (isMobile) {
      final selected = await showModalBottomSheet<ChecklistStatus>(
        context: context,
        useRootNavigator: true,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Text(
                  'Change Status',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...ChecklistStatus.values.map((status) {
                final isSelected = status == currentStatus;
                return ListTile(
                  leading: _getStatusIcon(status),
                  title: Text(_getStatusLabel(status)),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: context.colorScheme.primary,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(status),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );

      if (selected != null && selected != currentStatus) {
        await _updateStatus(selected);
      }
    } else {
      final selected = await showMenu<ChecklistStatus>(
        context: context,
        position: _getMenuPosition(context),
        items: ChecklistStatus.values.map((status) {
          final isSelected = status == currentStatus;
          return PopupMenuItem<ChecklistStatus>(
            value: status,
            child: Row(
              children: [
                _getStatusIcon(status),
                const SizedBox(width: 12),
                Text(_getStatusLabel(status)),
                if (isSelected) ...[
                  const Spacer(),
                  Icon(
                    Icons.check,
                    size: 20,
                    color: context.colorScheme.primary,
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      );

      if (selected != null && selected != currentStatus) {
        await _updateStatus(selected);
      }
    }
  }

  RelativeRect _getMenuPosition(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    return RelativeRect.fromLTRB(
      position.dx,
      position.dy + button.size.height,
      position.dx + button.size.width,
      position.dy,
    );
  }

  Icon _getStatusIcon(ChecklistStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case ChecklistStatus.pending:
        color = Colors.grey;
        icon = Icons.pending;
        break;
      case ChecklistStatus.inProgress:
        color = Colors.blue;
        icon = Icons.pending_actions;
        break;
      case ChecklistStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
    }

    return Icon(icon, color: color);
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

  Future<void> _updateStatus(ChecklistStatus newStatus) async {
    try {
      await ref
          .read(checklistDetailsProvider(widget.checklistId).notifier)
          .updateChecklist(UpdateChecklistDto(status: newStatus));
      if (mounted) {
        context.showSnackBar('Status updated to ${_getStatusLabel(newStatus)}');
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Failed to update status', isError: true);
      }
    }
  }

  Future<void> _editDescription(Checklist checklist) async {
    final controller = TextEditingController(text: checklist.description ?? '');
    final isMobile = context.isMobile;

    if (isMobile) {
      final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        showDragHandle: true,
        useSafeArea: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Description',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter checklist description',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 8,
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pop(controller.text.trim()),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (result != null && result != (checklist.description ?? '')) {
        await _updateDescription(result);
      }
    } else {
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Edit Description'),
          content: SizedBox(
            width: 500,
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter checklist description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 8,
              autofocus: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        ),
      );

      if (result != null && result != (checklist.description ?? '')) {
        await _updateDescription(result);
      }
    }
  }

  Future<void> _updateDescription(String newDescription) async {
    try {
      await ref
          .read(checklistDetailsProvider(widget.checklistId).notifier)
          .updateChecklist(UpdateChecklistDto(description: newDescription));
      if (mounted) {
        context.showSnackBar('Description updated');
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Failed to update description', isError: true);
      }
    }
  }

  Widget? _buildFloatingActionButton(
    BuildContext context,
    Checklist checklist,
  ) {
    if (checklist.isArchived) return null;

    final isCompleted = checklist.status == ChecklistStatus.completed;
    final isInProgress = checklist.status == ChecklistStatus.inProgress;

    if (isCompleted) {
      return FloatingActionButton.extended(
        onPressed: () => _updateStatus(ChecklistStatus.inProgress),
        icon: const Icon(Icons.replay),
        label: const Text('Reopen'),
        backgroundColor: Colors.orange,
      );
    } else if (isInProgress) {
      return FloatingActionButton.extended(
        onPressed: () => _updateStatus(ChecklistStatus.completed),
        icon: const Icon(Icons.check_circle),
        label: const Text('Mark as Completed'),
        backgroundColor: Colors.green,
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () => _updateStatus(ChecklistStatus.inProgress),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Working'),
      );
    }
  }
}
