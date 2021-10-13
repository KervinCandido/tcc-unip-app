import 'package:flutter/material.dart';

class Gender {
  final String value;
  final IconData icon;
  Color color;
  Color selectedColor;
  bool isSelected;

  Gender(
      this.value, this.icon, this.isSelected, this.color, this.selectedColor);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gender &&
          runtimeType == other.runtimeType &&
          other.value == value;

  @override
  int get hashCode => super.hashCode;
}
