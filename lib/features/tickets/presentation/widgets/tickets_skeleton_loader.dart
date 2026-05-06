import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/skeleton_loader.dart';

class TicketsSkeletonLoader extends StatelessWidget {
  const TicketsSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(
                          width: context.isMobile ? 120 : 150,
                          height: context.isMobile ? 28 : 36,
                        ),
                        const SizedBox(height: 4),
                        SkeletonText(
                          width: context.isMobile ? 80 : 100,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  SkeletonLoader(
                    width: 140,
                    height: 32,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ],
              ),
              SizedBox(height: context.isMobile ? 16 : 24),

              // Tickets List/Grid
              context.isMobile
                  ? _buildListLoader(context)
                  : _buildGridLoader(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListLoader(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (context, index) =>
          SizedBox(height: context.isMobile ? 12 : 16),
      itemBuilder: (context, index) => _buildTicketCardLoader(context),
    );
  }

  Widget _buildGridLoader(BuildContext context) {
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
      itemCount: 8,
      itemBuilder: (context, index) => _buildTicketCardLoader(context),
    );
  }

  Widget _buildTicketCardLoader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority Badge and Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader(
                  width: 60,
                  height: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
                SkeletonLoader.circle(size: 24),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            const SkeletonText(height: 20),
            const SizedBox(height: 8),

            // Description
            const SkeletonText(height: 14),
            const SizedBox(height: 4),
            SkeletonText(width: context.isMobile ? 200 : 250, height: 14),
            const SizedBox(height: 16),

            // Status Badge
            SkeletonLoader(
              width: 80,
              height: 24,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 12),

            // Footer (Due Date and Checklist Progress)
            Row(
              children: [
                SkeletonLoader.circle(size: 16),
                const SizedBox(width: 6),
                const SkeletonText(width: 80, height: 12),
                const Spacer(),
                SkeletonLoader.circle(size: 16),
                const SizedBox(width: 6),
                const SkeletonText(width: 40, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
