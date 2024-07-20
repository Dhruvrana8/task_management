import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task_management/NavigatorObserver.dart';
import 'package:task_management/constants/colors.dart';
import 'package:task_management/screens/AddNewTask/add_new_task.dart';
import 'package:task_management/screens/EditTask/edit_task.dart';
import 'package:task_management/screens/HomeScreen/home_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CustomColors.whiteSmoky),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomeScreen(),
        '/addNewTask': (context) => const AddNewTask(),
        '/editTask': (context) => const EditTask(),
      },
    );
  }
}
