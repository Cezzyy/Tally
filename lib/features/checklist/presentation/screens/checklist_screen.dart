import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../data/models/checklist.dart';
import '../../providers/checklist_provider.dart';
import '../widgets/checklist_card.dart';
import '../widgets/checklist_form_dialog.dart';

class ChecklistScreen extends ConsumerStatefulWidget {
  const ChecklistScreen({super.key});

  @override
  ConsumerState<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends ConsumerState<ChecklistScreen> {
  bool _includeArchived = false;

  @override
  Widget build(BuildContext context) {
    final checklistsAsync = ref.watch(
      checklistsProvider(includeArchived: _includeArchived),
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(
                checklistsProvider(includeArchived: _includeArchived).notifier,
              )
              .refresh();
        },
        child: checklistsAsync.when(
          data: (checklists) => _buildChecklistsList(context, checklists),
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
                  'Failed to load checklists',
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
                        checklistsProvider(
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
        onPressed: () => _showCreateChecklistDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Checklist'),
      ),
    );
  }

  Widget _buildChecklistsList(
    BuildContext context,
    List<ChecklistWithStats> checklists,
  ) {
    if (checklists.isEmpty) {
      return EmptyState(
        icon: Icons.checklist_outlined,
        title: _includeArchived
            ? 'No checklists found'
            : 'No active checklists',
        message: _includeArchived
            ? 'Create your first checklist to get started'
            : 'Create a checklist or show archived checklists',
        action: _includeArchived
            ? null
            : FilledButton.icon(
                onPressed: () => _showCreateChecklistDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Create Checklist'),
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
                          'Checklists',
                          style:
                              (context.isMobile
                                      ? context.textTheme.headlineMedium
                                      : context.textTheme.headlineLarge)
                                  ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${checklists.length} ${checklists.length == 1 ? 'checklist' : 'checklists'}',
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
                  ? _buildListView(context, checklists)
                  : _buildGridView(context, checklists),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(
    BuildContext context,
    List<ChecklistWithStats> checklists,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: checklists.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: context.isMobile ? 12 : 16),
      itemBuilder: (context, index) {
        final checklist = checklists[index];
        return ChecklistCard(
          checklist: checklist,
          onTap: () => _showChecklistDetails(context, checklist),
          onEdit: () => _showEditChecklistDialog(context, checklist),
          onDelete: () => _confirmDelete(context, checklist),
          onArchive: () => _toggleArchive(checklist),
        );
      },
    );
  }

  Widget _buildGridView(
    BuildContext context,
    List<ChecklistWithStats> checklists,
  ) {
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
      itemCount: checklists.length,
      itemBuilder: (context, index) {
        final checklist = checklists[index];
        return ChecklistCard(
          checklist: checklist,
          onTap: () => _showChecklistDetails(context, checklist),
          onEdit: () => _showEditChecklistDialog(context, checklist),
          onDelete: () => _confirmDelete(context, checklist),
          onArchive: () => _toggleArchive(checklist),
        );
      },
    );
  }

  void _showCreateChecklistDialog(BuildContext context) {
    ChecklistFormDialog.show(
      context: context,
      onSubmit: (dto) async {
        final navigator = Navigator.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        await ref
            .read(
              checklistsProvider(includeArchived: _includeArchived).notifier,
            )
            .createChecklist(dto);

        if (mounted) {
          navigator.pop();
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Checklist created successfully')),
          );
        }
      },
    );
  }

  void _showEditChecklistDialog(
    BuildContext context,
    ChecklistWithStats checklistWithStats,
  ) {
    ChecklistFormDialog.show(
      context: context,
      checklist: checklistWithStats.checklist,
      onSubmit: (dto) async {
        final navigator = Navigator.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        await ref
            .read(
              checklistsProvider(includeArchived: _includeArchived).notifier,
            )
            .updateChecklist(checklistWithStats.id, dto as UpdateChecklistDto);

        if (mounted) {
          navigator.pop();
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Checklist updated successfully')),
          );
        }
      },
    );
  }

  void _showChecklistDetails(
    BuildContext context,
    ChecklistWithStats checklist,
  ) {
    context.showSnackBar('Checklist details coming soon');
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ChecklistWithStats checklistWithStats,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Checklist'),
        content: Text(
          'Are you sure you want to delete "${checklistWithStats.title}"?',
        ),
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
          .read(checklistsProvider(includeArchived: _includeArchived).notifier)
          .deleteChecklist(checklistWithStats.id);

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Checklist deleted')),
        );
      }
    }
  }

  Future<void> _toggleArchive(ChecklistWithStats checklistWithStats) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (checklistWithStats.isArchived) {
      await ref
          .read(checklistsProvider(includeArchived: _includeArchived).notifier)
          .unarchiveChecklist(checklistWithStats.id);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Checklist unarchived')),
        );
      }
    } else {
      await ref
          .read(checklistsProvider(includeArchived: _includeArchived).notifier)
          .archiveChecklist(checklistWithStats.id);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Checklist archived')),
        );
      }
    }
  }
}
