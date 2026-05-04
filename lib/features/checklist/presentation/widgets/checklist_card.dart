import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../data/models/checklist.dart';

class ChecklistCard extends StatelessWidget {
  final ChecklistWithStats checklist;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;

  const ChecklistCard({
    super.key,
    required this.checklist,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: isMobile
            ? _buildMobileLayout(context)
            : _buildGridLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getPriorityColor(checklist.priority),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            checklist.title,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (checklist.isArchived) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  context.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ARCHIVED',
                              style: context.textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                padding: EdgeInsets.zero,
                iconSize: 20,
                itemBuilder: (context) => _buildMenuItems(context),
              ),
            ],
          ),
          if (checklist.description?.isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            Text(
              checklist.description!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          _buildProgressBar(context),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStatusChip(context),
              _buildPriorityBadge(context),
              if (checklist.dueDate != null) _buildDueDateChip(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Expanded(child: _buildContent(context)),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: _getPriorityColor(checklist.priority),
            width: 4,
          ),
          bottom: BorderSide(
            color: context.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        checklist.title,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (checklist.isArchived) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'ARCHIVED',
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            itemBuilder: (context) => _buildMenuItems(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (checklist.description?.isNotEmpty ?? false)
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  checklist.description!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  'No description',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          _buildProgressBar(context),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
        border: Border(
          top: BorderSide(color: context.colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildStatusChip(context)),
              const SizedBox(width: 8),
              _buildPriorityBadge(context),
            ],
          ),
          if (checklist.dueDate != null) ...[
            const SizedBox(height: 8),
            _buildDueDateRow(context),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final percentage = checklist.completionPercentage;
    final progressColor = checklist.isCompleted
        ? Colors.green
        : _getPriorityColor(checklist.priority);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${checklist.completedItems}/${checklist.totalItems} completed',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: context.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    String label;
    Color color;

    switch (checklist.status) {
      case ChecklistStatus.pending:
        label = 'Pending';
        color = Colors.grey;
        break;
      case ChecklistStatus.inProgress:
        label = 'In Progress';
        color = Colors.blue;
        break;
      case ChecklistStatus.completed:
        label = 'Completed';
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    final color = _getPriorityColor(checklist.priority);
    final label = _getPriorityLabel(checklist.priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateChip(BuildContext context) {
    final dueDate = checklist.dueDate!;
    final now = DateTime.now();
    final isOverdue =
        dueDate.isBefore(now) && checklist.status != ChecklistStatus.completed;
    final formattedDate = DateFormat('MMM d').format(dueDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOverdue
            ? Colors.red.withValues(alpha: 0.1)
            : context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        border: isOverdue
            ? Border.all(color: Colors.red.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 12,
            color: isOverdue
                ? Colors.red
                : context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Text(
            formattedDate,
            style: context.textTheme.labelSmall?.copyWith(
              color: isOverdue
                  ? Colors.red
                  : context.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateRow(BuildContext context) {
    final dueDate = checklist.dueDate!;
    final now = DateTime.now();
    final isOverdue =
        dueDate.isBefore(now) && checklist.status != ChecklistStatus.completed;
    final formattedDate = DateFormat('MMM d, y').format(dueDate);

    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 14,
          color: isOverdue
              ? Colors.red
              : context.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 6),
        Text(
          formattedDate,
          style: context.textTheme.labelSmall?.copyWith(
            color: isOverdue
                ? Colors.red
                : context.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (isOverdue) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'OVERDUE',
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 9,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<PopupMenuEntry> _buildMenuItems(BuildContext context) {
    return [
      PopupMenuItem(
        onTap: onEdit,
        child: const Row(
          children: [
            Icon(Icons.edit_outlined, size: 18),
            SizedBox(width: 12),
            Text('Edit'),
          ],
        ),
      ),
      PopupMenuItem(
        onTap: onArchive,
        child: Row(
          children: [
            Icon(
              checklist.isArchived
                  ? Icons.unarchive_outlined
                  : Icons.archive_outlined,
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(checklist.isArchived ? 'Unarchive' : 'Archive'),
          ],
        ),
      ),
      PopupMenuItem(
        onTap: onDelete,
        child: Row(
          children: [
            Icon(
              Icons.delete_outline,
              size: 18,
              color: context.colorScheme.error,
            ),
            const SizedBox(width: 12),
            Text('Delete', style: TextStyle(color: context.colorScheme.error)),
          ],
        ),
      ),
    ];
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

  String _getPriorityLabel(ChecklistPriority priority) {
    switch (priority) {
      case ChecklistPriority.high:
        return 'High';
      case ChecklistPriority.medium:
        return 'Medium';
      case ChecklistPriority.low:
        return 'Low';
    }
  }
}
