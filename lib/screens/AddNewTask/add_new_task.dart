import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management/constants/colors.dart';
import './strings.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final int _wordLimit = 500;
  int _wordCount = 0;
  final _formKey = GlobalKey<FormState>();

  void _updateWordCount() {
    setState(() {
      _wordCount = _controllerDescription.text.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerDescription.addListener(_updateWordCount);
  }

  @override
  void dispose() {
    _controllerDescription.removeListener(_updateWordCount);
    _controllerDescription.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform save operation
      // For example, save to a database or call an API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task Saved')),
      );
      Navigator.pop(context);
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
                      controller: _controllerTitle,
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
                      controller: _controllerDescription,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: strings.taskHint,
                        labelText: strings.task,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_wordLimit),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Task description is a required field';
                        }
                        return null;
                      },
                    ),
                    Text(
                      '$_wordCount / $_wordLimit',
                      style: TextStyle(
                        color: _wordCount > _wordLimit
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
