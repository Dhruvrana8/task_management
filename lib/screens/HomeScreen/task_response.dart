// To parse this JSON data, do
//
//     final taskList = taskListFromJson(jsonString);

import 'dart:convert';

TaskList taskListFromJson(String str) => TaskList.fromJson(json.decode(str));

String taskListToJson(TaskList data) => json.encode(data.toJson());

class TaskList {
  int? count;
  dynamic next;
  dynamic previous;
  List<Result>? results;

  TaskList({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  int? id;
  int? pk;
  String? taskTitle;
  DateTime? createdAt;
  bool? isCompleted;
  bool? isDeleted;
  String? taskDescription;

  Result({
    this.id,
    this.pk,
    this.taskTitle,
    this.createdAt,
    this.isCompleted,
    this.isDeleted,
    this.taskDescription,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        pk: json["pk"],
        taskTitle: json["task_title"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isCompleted: json["is_completed"],
        isDeleted: json["is_deleted"],
        taskDescription: json["task_description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pk": pk,
        "task_title": taskTitle,
        "created_at": createdAt?.toIso8601String(),
        "is_completed": isCompleted,
        "is_deleted": isDeleted,
        "task_description": taskDescription,
      };
}
