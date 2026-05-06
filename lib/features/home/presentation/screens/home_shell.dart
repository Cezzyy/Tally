import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/responsive_layout_shell.dart';

class HomeShell extends ConsumerStatefulWidget {
  final Widget child;
  final int currentIndex;

  const HomeShell({super.key, required this.child, required this.currentIndex});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const NavigationDestination(
      icon: Icon(Icons.confirmation_number_outlined),
      selectedIcon: Icon(Icons.confirmation_number),
      label: 'Tickets',
    ),
    const NavigationDestination(
      icon: Icon(Icons.checklist_outlined),
      selectedIcon: Icon(Icons.checklist),
      label: 'Checklist',
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onDestinationSelected(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/tickets');
        break;
      case 2:
        context.go('/checklist');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: context.isMobile ? 72 : 80,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(context.isMobile ? 10 : 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colorScheme.primaryContainer,
                    context.colorScheme.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.remove_done,
                size: context.isMobile ? 32 : 36,
                color: context.colorScheme.primary,
              ),
            ),
            SizedBox(width: context.isMobile ? 14 : 16),
            Text(
              'Tally',
              style: TextStyle(
                fontSize: context.isMobile ? 28 : 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
        centerTitle: false,
        titleSpacing: context.isMobile ? 16 : 24,
      ),
      body: ResponsiveLayoutShell(
        currentIndex: widget.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
        child: widget.child,
      ),
    );
  }
}
