import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task_management/constants/colors.dart';
import 'package:task_management/screens/EditTask/components/Custombutton.dart';
import 'package:task_management/screens/EditTask/strings.dart';
import 'package:http/http.dart' as http;
import 'package:task_management/screens/HomeScreen/task_response.dart';

import './urls.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  bool isFetching = true;
  late int id;
  late bool isCompleted;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final int _descriptionLimit = 500;
  int _wordCount = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateWordCount);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id = ModalRoute.of(context)!.settings.arguments as int;
    fetchTasks();
  }

  void _updateWordCount() {
    setState(() {
      _wordCount = _descriptionController.text.length;
    });
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_updateWordCount);
    _descriptionController.dispose();
    super.dispose();
  }

  Future<TaskList?> fetchTask(BuildContext context) async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    if (baseUrl != null) {
      final response = await http.get(
        Uri.parse('${baseUrl}/${Urls.editTask}?id=$id'),
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

  void fetchTasks() {
    fetchTask(context).then((response) {
      setState(() {
        if (response != null) {
          _titleController.text = response.results?.first?.taskTitle ?? '';
          _descriptionController.text =
              response.results?.first?.taskDescription ?? '';
          isCompleted = response.results?.first?.isCompleted ?? false;
        } else {
          print("Failed to fetch tasks");
        }
        isFetching = false;
      });
    }).catchError((error) {
      setState(() {
        print("Failed to load tasks: $error");
        isFetching = false;
      });
    });
  }

  Future<void> _onedtit(String operation) async {
    if (_formKey.currentState?.validate() ?? false) {
      var taskData = {};

      switch (operation) {
        case 'Delete':
          taskData = {
            'id': id,
            'is_deleted': true,
          };
          break;
        case 'Complete':
          taskData = {
            'id': id,
            'is_completed': isCompleted,
          };
          break;
        case 'Edit':
          taskData = {
            'id': id,
            'task_title': _titleController.text,
            'task_description': _descriptionController.text,
          };
          break;
      }

      // Load base URL from .env
      final baseUrl = dotenv.env['API_BASE_URL'];

      if (baseUrl != null) {
        try {
          final response = await http.put(
            Uri.parse('${baseUrl}/${Urls.editTask}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(taskData),
          );

          if (response.statusCode >= 200 || response.statusCode <= 300) {
            // Success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Task Saved Successfully',
                  style: TextStyle(
                    color: CustomColors.primary,
                  ),
                ),
                backgroundColor: CustomColors.secondary,
              ),
            );
            Navigator.pop(context);
          } else {
            // Error
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to save task')),
            );
          }
        } catch (e) {
          // Exception
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('API base URL not found')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteSmoky,
      appBar: AppBar(
        title: const Text(
          strings.editTask,
          style: TextStyle(
            color: CustomColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: CustomColors.primary,
        ),
        backgroundColor: CustomColors.secondary,
        actions: <Widget>[
          IconButton(
            onPressed: () => _onedtit('Delete'),
            icon: Icon(Icons.delete_forever),
            color: Colors.grey.shade700,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: isFetching
              ? CircularProgressIndicator()
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: strings.titleHint,
                              labelText: strings.title,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Title is a required field';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: strings.taskHint,
                              labelText: strings.task,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(
                                  _descriptionLimit),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Task description is a required field';
                              }
                              return null;
                            },
                          ),
                          Text(
                            '$_wordCount / $_descriptionLimit',
                            style: TextStyle(
                              color: _wordCount > _descriptionLimit
                                  ? CustomColors.danger
                                  : CustomColors.darkGreen,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomButton(
                              onPress: () => _onedtit('Complete'),
                              withSideBorder: true,
                              title: strings.completed,
                            ),
                            CustomButton(
                              onPress: () => _onedtit('Edit'),
                              withSideBorder: false,
                              title: strings.save,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
