import 'package:flutter/material.dart';

class FloatingNavbarItem {
  final String title;
  final IconData icon;
  final Color selectedColor,
      unselectedIconColor,
      selectedIconColor,
      unselectedLabelColor,
      selectedLabelColor;

  FloatingNavbarItem(
      {@required this.icon,
      @required this.title,
      this.selectedColor = Colors.blueAccent,
      this.unselectedIconColor = Colors.white,
      this.selectedIconColor = Colors.white,
      this.unselectedLabelColor = Colors.white,
      this.selectedLabelColor = Colors.white});
}
