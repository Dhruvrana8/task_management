import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final VoidCallback onDidPopNext;

  CustomNavigatorObserver({required this.onDidPopNext});

  @override
  void didPopNext() {
    onDidPopNext();
  }
}
