import 'package:flutter/material.dart';

/*
class DrawerItem {
  final String title;
  final IconData icon;

  const DrawerItem({
    required this.title,
    required this.icon,
  });
}
*/
class DrawerItem {
  final String title;
  final IconData icon;
  final Widget? badge;

  DrawerItem({
    required this.title,
    required this.icon,
    this.badge,
  });
}
