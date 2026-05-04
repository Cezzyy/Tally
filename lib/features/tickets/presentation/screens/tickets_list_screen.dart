import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../data/models/ticket.dart';
import '../../providers/ticket_provider.dart';
import '../widgets/ticket_card.dart';
import '../widgets/ticket_form_dialog.dart';

class TicketsListScreen extends ConsumerStatefulWidget {
  const TicketsListScreen({super.key});

  @override
  ConsumerState<TicketsListScreen> createState() => _TicketsListScreenState();
}

class _TicketsListScreenState extends ConsumerState<TicketsListScreen> {
  bool _includeArchived = false;

  @override
  Widget build(BuildContext context) {
    final ticketsAsync = ref.watch(
      ticketsProvider(includeArchived: _includeArchived),
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(ticketsProvider(includeArchived: _includeArchived).notifier)
              .refresh();
        },
        child: ticketsAsync.when(
          data: (tickets) => _buildTicketsList(context, tickets),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: context.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load tickets',
                  style: context.textTheme.titleLarge,
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
                        ticketsProvider(
                          includeArchived: _includeArchived,
                        ).notifier,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTicketDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Ticket'),
      ),
    );
  }

  Widget _buildTicketsList(BuildContext context, List<Ticket> tickets) {
    if (tickets.isEmpty) {
      return EmptyState(
        icon: Icons.confirmation_number_outlined,
        title: _includeArchived ? 'No tickets found' : 'No active tickets',
        message: _includeArchived
            ? 'Create your first ticket to get started'
            : 'Create a ticket or show archived tickets',
        action: _includeArchived
            ? null
            : FilledButton.icon(
                onPressed: () => _showCreateTicketDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Ticket'),
              ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.isMobile ? 16.0 : 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Column(
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
                          'Tickets',
                          style:
                              (context.isMobile
                                      ? context.textTheme.headlineMedium
                                      : context.textTheme.headlineLarge)
                                  ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tickets.length} ${tickets.length == 1 ? 'ticket' : 'tickets'}',
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilterChip(
                    label: const Text('Show Archived'),
                    selected: _includeArchived,
                    onSelected: (value) {
                      setState(() {
                        _includeArchived = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: context.isMobile ? 16 : 24),
              context.isMobile
                  ? _buildListView(context, tickets)
                  : _buildGridView(context, tickets),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<Ticket> tickets) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tickets.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: context.isMobile ? 12 : 16),
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return TicketCard(
          ticket: ticket,
          onTap: () => _showTicketDetails(context, ticket),
          onEdit: () => _showEditTicketDialog(context, ticket),
          onDelete: () => _confirmDelete(context, ticket),
          onArchive: () => _toggleArchive(ticket),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<Ticket> tickets) {
    final crossAxisCount = context.isDesktop ? 4 : (context.isTablet ? 3 : 2);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 280,
      ),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return TicketCard(
          ticket: ticket,
          onTap: () => _showTicketDetails(context, ticket),
          onEdit: () => _showEditTicketDialog(context, ticket),
          onDelete: () => _confirmDelete(context, ticket),
          onArchive: () => _toggleArchive(ticket),
        );
      },
    );
  }

  void _showCreateTicketDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TicketFormDialog(
        onSubmit: (dto) async {
          final navigator = Navigator.of(context);
          final scaffoldMessenger = ScaffoldMessenger.of(context);

          await ref
              .read(ticketsProvider(includeArchived: _includeArchived).notifier)
              .createTicket(dto);

          if (mounted) {
            navigator.pop();
            scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Ticket created successfully')),
            );
          }
        },
      ),
    );
  }

  void _showEditTicketDialog(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) => TicketFormDialog(
        ticket: ticket,
        onSubmit: (dto) async {
          final navigator = Navigator.of(context);
          final scaffoldMessenger = ScaffoldMessenger.of(context);

          await ref
              .read(ticketsProvider(includeArchived: _includeArchived).notifier)
              .updateTicket(ticket.id, dto as UpdateTicketDto);

          if (mounted) {
            navigator.pop();
            scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Ticket updated successfully')),
            );
          }
        },
      ),
    );
  }

  void _showTicketDetails(BuildContext context, Ticket ticket) {
    context.showSnackBar('Ticket details coming soon');
  }

  Future<void> _confirmDelete(BuildContext context, Ticket ticket) async {
    final colorScheme = Theme.of(context).colorScheme;

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
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(ticketsProvider(includeArchived: _includeArchived).notifier)
          .deleteTicket(ticket.id);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ticket deleted')));
      }
    }
  }

  Future<void> _toggleArchive(Ticket ticket) async {
    if (ticket.isArchived) {
      await ref
          .read(ticketsProvider(includeArchived: _includeArchived).notifier)
          .unarchiveTicket(ticket.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ticket unarchived')));
      }
    } else {
      await ref
          .read(ticketsProvider(includeArchived: _includeArchived).notifier)
          .archiveTicket(ticket.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ticket archived')));
      }
    }
  }
}
