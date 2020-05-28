import 'package:flutter/material.dart';

class FloatingNavbarItem {
  final String title;
  final IconData icon;
  final String iconPath;
  final Color selectedColor,
      unselectedIconColor,
      selectedIconColor,
      unselectedLabelColor,
      selectedLabelColor;

  FloatingNavbarItem(
      {this.icon,
      @required this.title,
      this.iconPath = '',
      this.selectedColor = Colors.blueAccent,
      this.unselectedIconColor = Colors.white,
      this.selectedIconColor = Colors.white,
      this.unselectedLabelColor = Colors.white,
      this.selectedLabelColor = Colors.white});
}

class CollapseNotifier extends ValueNotifier<bool> {
  CollapseNotifier(bool value) : super(value);

  void toggle() {
    value = !value;
    notifyListeners();
  }
}
