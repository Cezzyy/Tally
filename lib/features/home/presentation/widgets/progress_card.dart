import 'package:flutter/material.dart';
import '../../../../shared/extensions/context_extensions.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final int completed;
  final int total;
  final IconData icon;
  final Color? color;

  const ProgressCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? context.colorScheme.primary;
    final progress = total > 0 ? completed / total : 0.0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: progressColor,
                  size: context.isMobile ? 20 : 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style:
                        (context.isMobile
                                ? context.textTheme.titleMedium
                                : context.textTheme.titleLarge)
                            ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.isMobile ? 12 : 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completed / $total',
                  style:
                      (context.isMobile
                              ? context.textTheme.titleSmall
                              : context.textTheme.titleMedium)
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: progressColor,
                          ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style:
                      (context.isMobile
                              ? context.textTheme.titleSmall
                              : context.textTheme.titleMedium)
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: context.isMobile ? 6 : 8,
                backgroundColor: context.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
