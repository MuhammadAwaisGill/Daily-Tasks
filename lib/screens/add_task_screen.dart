import 'package:daily_tasks/models/task_model.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void dispose(){
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  void _saveTask() async {
    final title = _title.text.trim();
    final description = _description.text.trim();

    print('Save button pressed');  // Debug
    print('Title: $title');  // Debug
    print('Description: $description');  // Debug

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a Title!"))
      );
      return;
    }

    try {
      final newTask = Task(title: title, description: description);

      // loading existing tasks
      final tasks = await loadTasksFromPrefs();
      print('Existing tasks before add: ${tasks.length}');  // Debug

      // adding a new task
      tasks.add(newTask);
      print('Tasks after add: ${tasks.length}');  // Debug

      // saving to preferences
      await saveTasksToPrefs(tasks);

      // navigating back
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task saved successfully!"))
      );

      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      Navigator.pop(context, true);  // Pass true to indicate success

    } catch (e) {
      print('Error in _saveTask: $e');  // Debug
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving task: $e"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: const Text("Add a Task"),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _title,
                decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "your task title here",
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    )
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12,),
              TextField(
                controller: _description,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "your task description here",
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    )
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 22,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      )
                  ),
                  child: const Text("Save",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                ),
              )
            ],
          ),
        )
    );
  }
}