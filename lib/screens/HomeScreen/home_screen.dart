import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task_management/constants/colors.dart';
import 'package:task_management/constants/strings.dart';
import 'package:http/http.dart' as http;
import 'package:task_management/screens/HomeScreen/components/TaskCard.dart';
import 'package:task_management/screens/HomeScreen/strings.dart';
import 'package:task_management/screens/HomeScreen/task_response.dart';
import 'package:task_management/screens/HomeScreen/urls.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<TaskList?> data;
  var nextPage = null;

  @override
  void initState() {
    super.initState();
    fetchTasks(1);
  }

  void fetchTasks(pageNumber) {
    fetchTask(context, pageNumber).then((taskList) {
      setState(() {
        if (taskList != null) {
          print(taskList.next);
          nextPage = taskList.next;
          data = Future.value(taskList);
        } else {
          print("Failed to fetch tasks");
        }
      });
    }).catchError((error) {
      setState(() {
        print("Failed to load tasks: $error");
        data = Future.error(error);
      });
    });
  }

  Future<TaskList?> fetchTask(BuildContext context, pageNumber) async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl != null) {
      final response = await http.get(
        Uri.parse(
            '${baseUrl}/${Urls.getTask}?${pageNumber != null ? 'page=$pageNumber' : ''}'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return TaskList.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API base URL not found')),
      );
      return null; // Return null to indicate failure
    }
  }

  Future<void> _handleRefresh() async {
    // Simulate network fetch or database query
    fetchTasks(nextPage);
  }

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
      body: Center(
        child: FutureBuilder<TaskList?>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              final taskList = snapshot.data!;
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    _handleRefresh();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    itemCount: taskList.results?.length ?? 0,
                    itemBuilder: (context, index) {
                      final task = taskList.results![index];
                      return Taskcard(
                        title: task.taskTitle ?? 'No Title',
                        description: task.taskDescription ?? 'No Description',
                      );
                    },
                  ),
                ),
              );
            } else {
              return Text(strings.noData);
            }
          },
        ),
      ),
    );
  }
}
