import 'package:flutter/material.dart';

class CustomColors {
  static const primary = Color(0xFF0C4E1C);
  static const secondary = Color(0xFFCAD8CD);
  static const whiteSmoky = Color(0xFFF5F5F5);
  static const danger = Color(0xFFC40C0C);
  static const darkGreen = Color(0xFF1A5319);

  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withOpacity(opacity);
  static Color whiteSmokyWithOpacity(double opacity) =>
      whiteSmoky.withOpacity(opacity);
  static Color dangerWithOpacity(double opacity) => danger.withOpacity(opacity);
  static Color darkGreenWithOpacity(double opacity) =>
      darkGreen.withOpacity(opacity);
}
