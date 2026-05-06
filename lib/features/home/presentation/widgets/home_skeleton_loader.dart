import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/skeleton_loader.dart';

class HomeSkeletonLoader extends StatelessWidget {
  const HomeSkeletonLoader({super.key});

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
              SkeletonText(
                width: context.isMobile ? 150 : 200,
                height: context.isMobile ? 28 : 36,
              ),
              const SizedBox(height: 8),
              SkeletonText(width: context.isMobile ? 200 : 280, height: 16),
              SizedBox(height: context.isMobile ? 20 : 32),

              // Quick Stats Grid
              _buildQuickStatsLoader(context),
              SizedBox(height: context.isMobile ? 20 : 24),

              // Status Breakdown Card
              _buildCardLoader(context, hasProgressBars: true),
              SizedBox(height: context.isMobile ? 20 : 24),

              // Priority Breakdown Card
              _buildCardLoader(context, hasProgressBars: false),
              SizedBox(height: context.isMobile ? 20 : 24),

              // Progress Section Card
              _buildCardLoader(context, hasProgressBars: true),
              SizedBox(height: context.isMobile ? 20 : 24),

              // Due Dates Card
              _buildCardLoader(context, hasProgressBars: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsLoader(BuildContext context) {
    final crossAxisCount = context.isMobile ? 2 : (context.isTablet ? 3 : 4);
    final childAspectRatio = context.isMobile
        ? 1.4
        : (context.isTablet ? 1.5 : 1.6);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: context.isMobile ? 12 : 16,
      crossAxisSpacing: context.isMobile ? 12 : 16,
      childAspectRatio: childAspectRatio,
      children: List.generate(
        4,
        (index) => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: SkeletonText(height: 14)),
                    const SizedBox(width: 8),
                    SkeletonLoader.circle(size: 24),
                  ],
                ),
                const SizedBox(height: 8),
                SkeletonText(width: 60, height: context.isMobile ? 28 : 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardLoader(
    BuildContext context, {
    required bool hasProgressBars,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                SkeletonLoader.circle(size: context.isMobile ? 24 : 28),
                const SizedBox(width: 12),
                SkeletonText(
                  width: context.isMobile ? 120 : 160,
                  height: context.isMobile ? 18 : 22,
                ),
              ],
            ),
            SizedBox(height: context.isMobile ? 16 : 20),

            // Card Content
            ...List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: index < 2 ? 12 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonText(
                          width: context.isMobile ? 80 : 100,
                          height: 16,
                        ),
                        SkeletonText(
                          width: context.isMobile ? 40 : 60,
                          height: 16,
                        ),
                      ],
                    ),
                    if (hasProgressBars) ...[
                      const SizedBox(height: 8),
                      const SkeletonLoader(
                        height: 6,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
