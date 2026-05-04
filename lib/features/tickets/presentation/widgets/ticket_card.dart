import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../data/models/ticket.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.isMobile ? 12.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildPriorityIndicator(context),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '#${ticket.ticketNumber}',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            if (ticket.isArchived) ...[
                              const SizedBox(width: 8),
                              Chip(
                                label: const Text('Archived'),
                                labelStyle: context.textTheme.labelSmall,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ticket.title,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: onEdit,
                        child: const Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20),
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
                              ticket.isArchived
                                  ? Icons.unarchive_outlined
                                  : Icons.archive_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(ticket.isArchived ? 'Unarchive' : 'Archive'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: onDelete,
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: context.colorScheme.error,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: context.colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (ticket.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  ticket.description,
                  style: context.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatusChip(context),
                  if (ticket.dueDate != null) _buildDueDateChip(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(BuildContext context) {
    Color color;
    switch (ticket.priority) {
      case TicketPriority.urgent:
        color = Colors.red.shade700;
        break;
      case TicketPriority.high:
        color = Colors.orange;
        break;
      case TicketPriority.medium:
        color = Colors.blue;
        break;
      case TicketPriority.low:
        color = Colors.grey;
        break;
    }

    return Container(
      width: 4,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    String label;
    Color color;

    switch (ticket.status) {
      case TicketStatus.backlog:
        label = 'Backlog';
        color = Colors.grey;
        break;
      case TicketStatus.inProgress:
        label = 'In Progress';
        color = Colors.blue;
        break;
      case TicketStatus.done:
        label = 'Done';
        color = Colors.green;
        break;
    }

    return Chip(
      label: Text(label),
      labelStyle: context.textTheme.labelSmall?.copyWith(color: color),
      side: BorderSide(color: color),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildDueDateChip(BuildContext context) {
    final dueDate = ticket.dueDate!;
    final now = DateTime.now();
    final isOverdue =
        dueDate.isBefore(now) && ticket.status != TicketStatus.done;
    final formattedDate = DateFormat('MMM d, y').format(dueDate);

    return Chip(
      avatar: Icon(
        Icons.calendar_today_outlined,
        size: 16,
        color: isOverdue ? Colors.red : context.colorScheme.onSurface,
      ),
      label: Text(formattedDate),
      labelStyle: context.textTheme.labelSmall?.copyWith(
        color: isOverdue ? Colors.red : null,
      ),
      side: BorderSide(
        color: isOverdue ? Colors.red : context.colorScheme.outline,
      ),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
