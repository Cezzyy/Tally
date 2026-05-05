import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../data/models/ticket.dart';
import '../../data/models/ticket_checklist_item.dart';
import '../../providers/ticket_details_provider.dart';
import '../widgets/ticket_form_dialog.dart';

class TicketDetailsScreen extends ConsumerStatefulWidget {
  final String ticketId;

  const TicketDetailsScreen({super.key, required this.ticketId});

  @override
  ConsumerState<TicketDetailsScreen> createState() =>
      _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends ConsumerState<TicketDetailsScreen> {
  final TextEditingController _checklistItemController =
      TextEditingController();

  @override
  void dispose() {
    _checklistItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticketDetailsAsync = ref.watch(ticketDetailsProvider(widget.ticketId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
        centerTitle: context.isMobile,
        actions: [
          ticketDetailsAsync.when(
            data: (ticketWithChecklist) => PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditDialog(ticketWithChecklist.ticket);
                    break;
                  case 'archive':
                    _toggleArchive(ticketWithChecklist.ticket);
                    break;
                  case 'delete':
                    _confirmDelete(ticketWithChecklist.ticket);
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
                      Icon(ticketWithChecklist.ticket.isArchived
                          ? Icons.unarchive
                          : Icons.archive),
                      const SizedBox(width: 12),
                      Text(ticketWithChecklist.ticket.isArchived
                          ? 'Unarchive'
                          : 'Archive'),
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
            error: (_, __) => const SizedBox.shrink(),
          ),
          if (!context.isMobile) const SizedBox(width: 8),
        ],
      ),
      body: ticketDetailsAsync.when(
        data: (ticketWithChecklist) =>
            _buildContent(context, ticketWithChecklist),
        loading: () => const Center(child: CircularProgressIndicator()),
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
                  'Failed to load ticket',
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
                      .read(ticketDetailsProvider(widget.ticketId).notifier)
                      .refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TicketWithChecklist ticketWithChecklist,
  ) {
    final ticket = ticketWithChecklist.ticket;
    final spacing = context.isMobile ? 16.0 : (context.isTablet ? 20.0 : 24.0);

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(ticketDetailsProvider(widget.ticketId).notifier)
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
                _buildHeader(context, ticket),
                SizedBox(height: spacing * 1.5),
                _buildMetadata(context, ticket),
                if (ticket.description.isNotEmpty) ...[
                  SizedBox(height: spacing * 1.5),
                  _buildDescription(context, ticket),
                ],
                SizedBox(height: spacing * 2),
                _buildChecklistSection(context, ticketWithChecklist),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Ticket ticket) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title first
        Text(
          ticket.title,
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
        // Badges below
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Ticket number badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.isMobile ? 12 : 14,
                vertical: context.isMobile ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tag,
                    size: context.isMobile ? 14 : 16,
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${ticket.ticketNumber}',
                    style: (context.isMobile
                            ? context.textTheme.labelMedium
                            : context.textTheme.labelLarge)
                        ?.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Status chip
            _buildStatusChip(context, ticket.status),
            // Priority chip
            _buildPriorityChip(context, ticket.priority),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, TicketStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case TicketStatus.backlog:
        color = Colors.grey;
        label = 'Backlog';
        icon = Icons.inbox;
        break;
      case TicketStatus.inProgress:
        color = Colors.blue;
        label = 'In Progress';
        icon = Icons.pending_actions;
        break;
      case TicketStatus.done:
        color = Colors.green;
        label = 'Done';
        icon = Icons.check_circle;
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
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: context.isMobile ? 14 : 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: (context.isMobile
                    ? context.textTheme.labelMedium
                    : context.textTheme.labelLarge)
                ?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(BuildContext context, TicketPriority priority) {
    Color color;
    String label;

    switch (priority) {
      case TicketPriority.low:
        color = Colors.blue;
        label = 'Low';
        break;
      case TicketPriority.medium:
        color = Colors.orange;
        label = 'Medium';
        break;
      case TicketPriority.high:
        color = Colors.red;
        label = 'High';
        break;
      case TicketPriority.urgent:
        color = Colors.red.shade900;
        label = 'Urgent';
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
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.isMobile ? 8 : 10,
            height: context.isMobile ? 8 : 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: (context.isMobile
                    ? context.textTheme.labelMedium
                    : context.textTheme.labelLarge)
                ?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, Ticket ticket) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 12.0 : 16.0),
        child: Column(
          children: [
            _buildMetadataRow(
              context,
              icon: Icons.calendar_today,
              label: 'Created',
              value: DateFormat(context.isMobile ? 'MMM d, y' : 'MMM d, y • h:mm a')
                  .format(ticket.createdAt),
            ),
            Divider(height: context.isMobile ? 20 : 24),
            _buildMetadataRow(
              context,
              icon: Icons.update,
              label: 'Updated',
              value: DateFormat(context.isMobile ? 'MMM d, y' : 'MMM d, y • h:mm a')
                  .format(ticket.updatedAt),
            ),
            if (ticket.dueDate != null) ...[
              Divider(height: context.isMobile ? 20 : 24),
              _buildMetadataRow(
                context,
                icon: Icons.event,
                label: 'Due Date',
                value: DateFormat('MMM d, y').format(ticket.dueDate!),
                valueColor: ticket.dueDate!.isBefore(DateTime.now())
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
                style: (context.isMobile
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

  Widget _buildDescription(BuildContext context, Ticket ticket) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: (context.isMobile
                  ? context.textTheme.titleMedium
                  : context.textTheme.titleLarge)
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.isMobile ? 8 : 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(context.isMobile ? 12.0 : 16.0),
            child: Text(
              ticket.description,
              style: context.isMobile
                  ? context.textTheme.bodyMedium
                  : context.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistSection(
    BuildContext context,
    TicketWithChecklist ticketWithChecklist,
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
                    'Checklist',
                    style: (context.isMobile
                            ? context.textTheme.titleMedium
                            : context.textTheme.titleLarge)
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (ticketWithChecklist.hasChecklist) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${ticketWithChecklist.completedItems}/${ticketWithChecklist.totalItems} completed',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (ticketWithChecklist.hasChecklist)
              Text(
                '${ticketWithChecklist.completionPercentage.toStringAsFixed(0)}%',
                style: (context.isMobile
                        ? context.textTheme.titleMedium
                        : context.textTheme.titleLarge)
                    ?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        if (ticketWithChecklist.hasChecklist) ...[
          SizedBox(height: context.isMobile ? 8 : 12),
          LinearProgressIndicator(
            value: ticketWithChecklist.completionPercentage / 100,
            backgroundColor:
                context.colorScheme.primaryContainer.withValues(alpha: 0.3),
            minHeight: context.isMobile ? 6 : 8,
          ),
        ],
        SizedBox(height: context.isMobile ? 12 : 16),
        _buildAddChecklistItem(context),
        SizedBox(height: context.isMobile ? 12 : 16),
        _buildChecklistItems(context, ticketWithChecklist.checklistItems),
      ],
    );
  }

  Widget _buildAddChecklistItem(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 8.0 : 12.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _checklistItemController,
                decoration: InputDecoration(
                  hintText: 'Add a checklist item...',
                  border: InputBorder.none,
                  isDense: true,
                  hintStyle: TextStyle(
                    fontSize: context.isMobile ? 14 : 16,
                  ),
                ),
                style: TextStyle(fontSize: context.isMobile ? 14 : 16),
                onSubmitted: (value) => _addChecklistItem(),
              ),
            ),
            IconButton(
              onPressed: _addChecklistItem,
              icon: const Icon(Icons.add),
              tooltip: 'Add item',
              iconSize: context.isMobile ? 20 : 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItems(
    BuildContext context,
    List<TicketChecklistItem> items,
  ) {
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
                  'No checklist items yet',
                  style: (context.isMobile
                          ? context.textTheme.bodyMedium
                          : context.textTheme.bodyLarge)
                      ?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
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
          return _buildChecklistItemTile(context, item);
        },
      ),
    );
  }

  Widget _buildChecklistItemTile(
    BuildContext context,
    TicketChecklistItem item,
  ) {
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
                .read(ticketDetailsProvider(widget.ticketId).notifier)
                .toggleChecklistItem(item.id, value);
          }
        },
      ),
      title: Text(
        item.task,
        style: (context.isMobile
                ? context.textTheme.bodyMedium
                : context.textTheme.bodyLarge)
            ?.copyWith(
          decoration:
              item.isCompleted ? TextDecoration.lineThrough : null,
          color: item.isCompleted
              ? context.colorScheme.onSurface.withValues(alpha: 0.6)
              : null,
        ),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              _editChecklistItem(item);
              break;
            case 'delete':
              _deleteChecklistItem(item);
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

  Future<void> _addChecklistItem() async {
    final task = _checklistItemController.text.trim();
    if (task.isEmpty) return;

    try {
      await ref
          .read(ticketDetailsProvider(widget.ticketId).notifier)
          .addChecklistItem(task);
      _checklistItemController.clear();
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Failed to add checklist item', isError: true);
      }
    }
  }

  Future<void> _editChecklistItem(TicketChecklistItem item) async {
    final controller = TextEditingController(text: item.task);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Checklist Item'),
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
            .read(ticketDetailsProvider(widget.ticketId).notifier)
            .updateChecklistItem(
              item.id,
              UpdateTicketChecklistItemDto(task: result),
            );
      } catch (e) {
        if (mounted) {
          context.showSnackBar('Failed to update checklist item',
              isError: true);
        }
      }
    }
  }

  Future<void> _deleteChecklistItem(TicketChecklistItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Checklist Item'),
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
            .read(ticketDetailsProvider(widget.ticketId).notifier)
            .deleteChecklistItem(item.id);
      } catch (e) {
        if (mounted) {
          context.showSnackBar('Failed to delete checklist item',
              isError: true);
        }
      }
    }
  }

  void _showEditDialog(Ticket ticket) {
    TicketFormDialog.show(
      context: context,
      ticket: ticket,
      onSubmit: (dto) async {
        final navigator = Navigator.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        await ref
            .read(ticketDetailsProvider(widget.ticketId).notifier)
            .updateTicket(dto as UpdateTicketDto);

        if (mounted) {
          navigator.pop();
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Ticket updated successfully')),
          );
        }
      },
    );
  }

  Future<void> _toggleArchive(Ticket ticket) async {
    try {
      await ref
          .read(ticketDetailsProvider(widget.ticketId).notifier)
          .updateTicket(
            UpdateTicketDto(isArchived: !ticket.isArchived),
          );
      if (mounted) {
        context.showSnackBar(
          ticket.isArchived ? 'Ticket unarchived' : 'Ticket archived',
        );
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Failed to update ticket', isError: true);
      }
    }
  }

  Future<void> _confirmDelete(Ticket ticket) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Ticket'),
        content: Text('Are you sure you want to delete "${ticket.title}"?'),
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
      // Delete via repository and navigate back
      context.go('/tickets');
      context.showSnackBar('Ticket deleted');
    }
  }
}
