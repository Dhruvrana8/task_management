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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late List<Result?>? data = [];
  dynamic nextPage = 1;
  bool isCompletedTask = false;
  bool isFetching = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchTasks(nextPage);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _handleRefresh();
  }

  void _handleTabChange() {
    setState(() {
      isCompletedTask = (_tabController.index == 0);
    });
    _handleRefresh();
  }

  void fetchTasks(int pageNumber) {
    if (nextPage != null) {
      fetchTask(context, pageNumber).then((response) {
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
            '${baseUrl}/${Urls.getTask}?${pageNumber != null ? 'page=$pageNumber' : ''}&status_code=${isCompletedTask ? 'INCOMPLETE' : 'COMPLETED'}'),
      );
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        return TaskList.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
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
    setState(() {
      nextPage = 1;
      data = []; // Clear the existing data
    });
    fetchTasks(nextPage);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CustomColors.whiteSmoky,
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.pending)),
              Tab(icon: Icon(Icons.done_all)),
            ],
            onTap: (value) {
              setState(() {
                isCompletedTask = value == 0;
              });
              _handleRefresh();
            },
          ),
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
            ).then((_) {
              setState(() {
                isCompletedTask = _tabController.index == 0;
              });
              _handleRefresh();
            });
          },
          backgroundColor: CustomColors.secondary,
          elevation: 5,
          child: const Icon(
            Icons.add,
            size: 28,
            color: CustomColors.primary,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTaskListView(),
            _buildTaskListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskListView() {
    return Center(
      child: data == null
          ? const Text(
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
                  if (nextPage != null) fetchTasks(nextPage);
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
                      title: task?.taskTitle ?? '',
                      description: task?.taskDescription ?? '',
                      id: task?.id ?? 0,
                      isCompleted: task?.isCompleted ?? false,
                      function: () {
                        setState(() {
                          isCompletedTask = _tabController.index == 0;
                        });
                        _handleRefresh();
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }
}
