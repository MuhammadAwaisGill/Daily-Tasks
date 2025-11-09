import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String tasksKey = 'tasks_list';

class Task {
  String title;
  String description;
  bool isDone;

  Task({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

}

Future<List<Task>> loadTasksFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? stringList = prefs.getStringList(tasksKey);

  if (stringList == null) return <Task>[];

  return stringList.map((s) {
    try {
      return Task.fromJson(s);
    } catch (e) {
      print('Error decoding task: $e');
      return null;
    }
  }).whereType<Task>().toList();
}

Future<void> saveTasksToPrefs(List<Task> tasks) async {

  final prefs = await SharedPreferences.getInstance();

  final List<String> stringList = tasks.map((t) => t.toJson()).toList();

  await prefs.setStringList(tasksKey, stringList);
}

