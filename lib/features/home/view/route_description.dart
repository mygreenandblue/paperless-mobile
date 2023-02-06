import 'package:flutter/material.dart';

class RouteDescription {
  final String label;
  final Icon icon;
  final Icon selectedIcon;
  final Widget Function(Widget icon)? badgeBuilder;

  RouteDescription({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeBuilder,
  });

  NavigationDestination toNavigationDestination() {
    return NavigationDestination(
      label: label,
      icon: badgeBuilder?.call(icon) ?? icon,
      selectedIcon: badgeBuilder?.call(selectedIcon) ?? selectedIcon,
    );
  }

  NavigationRailDestination toNavigationRailDestination() {
    return NavigationRailDestination(
      label: Text(label),
      icon: icon,
      selectedIcon: selectedIcon,
    );
  }

  BottomNavigationBarItem toBottomNavigationBarItem() {
    return BottomNavigationBarItem(
      label: label,
      icon: badgeBuilder?.call(icon) ?? icon,
      activeIcon: badgeBuilder?.call(selectedIcon) ?? selectedIcon,
    );
  }
}
