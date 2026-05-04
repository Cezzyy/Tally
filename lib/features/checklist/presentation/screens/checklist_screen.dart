import 'package:flutter/material.dart';
import '../../../../shared/extensions/context_extensions.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.isMobile ? 16.0 : 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist_outlined,
              size: context.isMobile ? 64 : 80,
              color: context.colorScheme.primary,
            ),
            SizedBox(height: context.isMobile ? 16 : 24),
            Text(
              'Checklist',
              style: context.isMobile
                  ? context.textTheme.headlineSmall
                  : context.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
