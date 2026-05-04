import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/logging/app_logger.dart';
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

  void _showLogsScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TalkerScreen(talker: AppLogger.talker),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tally'),
        centerTitle: context.isMobile,
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report),
              tooltip: 'View Logs',
              onPressed: _showLogsScreen,
            ),
          if (!context.isMobile) const SizedBox(width: 8),
        ],
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
