import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:task_management/constants/colors.dart';
import 'package:task_management/screens/AddNewTask/urls.dart';
import './strings.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final int _descriptionLimit = 500;
  int _wordCount = 0;
  final _formKey = GlobalKey<FormState>();

  void _updateWordCount() {
    setState(() {
      _wordCount = _descriptionController.text.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateWordCount);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_updateWordCount);
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      // API request payload
      final taskData = {
        'task_title': _titleController.text,
        'task_description': _descriptionController.text,
      };

      // Load base URL from .env
      final baseUrl = dotenv.env['API_BASE_URL'];

      print(baseUrl);

      if (baseUrl != null) {
        try {
          final response = await http.post(
            Uri.parse('${baseUrl}/${Urls.addTask}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(taskData),
          );

          if (response.statusCode == 201) {
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
          strings.addNewTask,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Form(
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
                        floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_descriptionLimit),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.secondary,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        strings.save,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
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
