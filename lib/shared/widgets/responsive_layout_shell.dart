import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

class ResponsiveLayoutShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onDestinationSelected;
  final List<NavigationDestination> destinations;

  const ResponsiveLayoutShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(
        children: [
          Expanded(child: child),
          NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: destinations,
          ),
        ],
      );
    }

    return Row(
      children: [
        NavigationRail(
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          labelType: context.isDesktop
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.all,
          extended: context.isDesktop,
          destinations: destinations
              .map(
                (dest) => NavigationRailDestination(
                  icon: dest.icon,
                  selectedIcon: dest.selectedIcon,
                  label: Text(dest.label),
                ),
              )
              .toList(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: child),
      ],
    );
  }
}
