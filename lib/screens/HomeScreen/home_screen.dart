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
  late List<Result?>? data = [];
  dynamic nextPage = 1;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchTasks(nextPage);
  }

  void fetchTasks(int pageNumber) {
    if (nextPage) {
      fetchTask(context, pageNumber).then((response) {
        print(response);
        setState(() {
          if (response != null) {
            nextPage = response.next == null ? null : response.next;
            data?..addAll(response.results ?? []);
            nextPage = response?.next ?? null;
          } else {
            print("Failed to fetch tasks");
          }
          isFetching = false;
        });
      }).catchError((error) {
        setState(() {
          print("Failed to load tasks: $error");
          data = error;
        });
      });
    }
  }

  Future<TaskList?> fetchTask(BuildContext context, int pageNumber) async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl != null) {
      final response = await http.get(
        Uri.parse(
            '${baseUrl}/${Urls.getTask}?${pageNumber != null ? 'page=$pageNumber' : ''}'),
      );
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return TaskList.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load task');
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
    setState(() {
      nextPage = 1;
      data = []; // Clear the existing data
    });
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
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/addNewTask',
          );
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
        child: data == null
            ? Text(
                strings.emptyScreen,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      !isFetching) {
                    setState(() {
                      isFetching = true;
                    });
                    if (nextPage) fetchTasks(nextPage);
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    itemCount: data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final task = data![index];
                      return Taskcard(
                        title: task?.taskTitle ?? strings.title,
                        description:
                            task?.taskDescription ?? strings.description,
                        id: task?.id ?? 0,
                        isCompleted: task?.isCompleted ?? false,
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
