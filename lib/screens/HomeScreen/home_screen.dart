import 'package:flutter/material.dart';
import 'package:task_management/constants/colors.dart';
import 'package:task_management/constants/strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteSmoky,
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            color: CustomColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: CustomColors.secondary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushNamed(
            context,
            '/addNewTask',
          ),
        },
        backgroundColor: CustomColors.secondary,
        elevation: 5,
        child: const Icon(
          Icons.add,
          size: 28,
          color: CustomColors.primary,
        ),
      ),
    );
  }
}
