import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/skeleton_loader.dart';

class TicketDetailsSkeletonLoader extends StatelessWidget {
  const TicketDetailsSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.isMobile ? 16.0 : (context.isTablet ? 20.0 : 24.0);

    return SingleChildScrollView(
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
              _buildHeaderLoader(context),
              SizedBox(height: spacing * 1.5),
              _buildMetadataLoader(context),
              SizedBox(height: spacing * 1.5),
              _buildDescriptionLoader(context),
              SizedBox(height: spacing * 2),
              _buildChecklistLoader(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderLoader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        SkeletonText(
          width: context.isMobile ? 250 : 400,
          height: context.isMobile ? 24 : (context.isTablet ? 28 : 32),
        ),
        const SizedBox(height: 8),
        SkeletonText(
          width: context.isMobile ? 180 : 300,
          height: context.isMobile ? 24 : (context.isTablet ? 28 : 32),
        ),
        SizedBox(height: context.isMobile ? 12 : 16),
        // Badges
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SkeletonLoader(
              width: 80,
              height: context.isMobile ? 28 : 32,
              borderRadius: BorderRadius.circular(20),
            ),
            SkeletonLoader(
              width: 100,
              height: context.isMobile ? 28 : 32,
              borderRadius: BorderRadius.circular(20),
            ),
            SkeletonLoader(
              width: 90,
              height: context.isMobile ? 28 : 32,
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetadataLoader(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 12.0 : 16.0),
        child: Column(
          children: [
            _buildMetadataRowLoader(context),
            Divider(height: context.isMobile ? 20 : 24),
            _buildMetadataRowLoader(context),
            Divider(height: context.isMobile ? 20 : 24),
            _buildMetadataRowLoader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRowLoader(BuildContext context) {
    return Row(
      children: [
        SkeletonLoader.circle(size: context.isMobile ? 18 : 20),
        SizedBox(width: context.isMobile ? 10 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonText(width: context.isMobile ? 60 : 80, height: 12),
              const SizedBox(height: 4),
              SkeletonText(
                width: context.isMobile ? 120 : 160,
                height: context.isMobile ? 14 : 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionLoader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkeletonText(
              width: context.isMobile ? 100 : 120,
              height: context.isMobile ? 18 : 22,
            ),
            SkeletonLoader.circle(size: context.isMobile ? 20 : 22),
          ],
        ),
        SizedBox(height: context.isMobile ? 8 : 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.isMobile ? 16.0 : 20.0),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonText(height: 14),
              const SizedBox(height: 8),
              const SkeletonText(height: 14),
              const SizedBox(height: 8),
              SkeletonText(width: context.isMobile ? 200 : 300, height: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistLoader(BuildContext context) {
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
                  SkeletonText(
                    width: context.isMobile ? 80 : 100,
                    height: context.isMobile ? 18 : 22,
                  ),
                  const SizedBox(height: 4),
                  SkeletonText(width: context.isMobile ? 100 : 120, height: 12),
                ],
              ),
            ),
            SkeletonText(width: 40, height: context.isMobile ? 18 : 22),
          ],
        ),
        SizedBox(height: context.isMobile ? 8 : 12),
        SkeletonLoader(
          height: context.isMobile ? 6 : 8,
          borderRadius: BorderRadius.circular(4),
        ),
        SizedBox(height: context.isMobile ? 12 : 16),
        // Add item card
        Card(
          child: Padding(
            padding: EdgeInsets.all(context.isMobile ? 8.0 : 12.0),
            child: Row(
              children: [
                const Expanded(child: SkeletonText(height: 16)),
                SkeletonLoader.circle(size: context.isMobile ? 20 : 24),
              ],
            ),
          ),
        ),
        SizedBox(height: context.isMobile ? 12 : 16),
        // Checklist items
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) => ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: context.isMobile ? 12 : 16,
                vertical: context.isMobile ? 0 : 4,
              ),
              leading: SkeletonLoader.circle(size: 24),
              title: SkeletonText(
                width: context.isMobile ? 150 : 200,
                height: context.isMobile ? 14 : 16,
              ),
              trailing: SkeletonLoader.circle(size: 24),
            ),
          ),
        ),
      ],
    );
  }
}
