import 'package:flutter/material.dart';
import 'package:task_management/constants/colors.dart';

class Taskcard extends StatelessWidget {
  final String title;
  final String description;
  final int id;
  final bool isCompleted;
  final function;

  const Taskcard({
    super.key,
    required this.title,
    required this.description,
    required this.id,
    required this.isCompleted,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Card(
            elevation: 5,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/editTask', arguments: id)
                    .then((_) {
                  function();
                });
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CustomColors.secondaryWithOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.black),
                      Expanded(
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 16,
                            color: isCompleted ? Colors.grey : Colors.black,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isCompleted)
            Positioned(
              top: 8,
              right: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check_circle,
                  color: CustomColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
