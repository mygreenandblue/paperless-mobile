import 'package:flutter/material.dart';

class RouteDescription {
  final String label;
  final Icon icon;
  final Icon selectedIcon;

  RouteDescription({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  NavigationDestination toNavigationDestination() {
    return NavigationDestination(
      label: label,
      icon: icon,
      selectedIcon: selectedIcon,
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
      icon: icon,
      activeIcon: selectedIcon,
    );
  }
}
