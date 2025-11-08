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
    super.dispose();
    _title.dispose();
    _description.dispose();
  }

  void _saveTask() {
    final title = _title.text.trim();
    final description = _description.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a Title!"))
      );
      return;
    }

    final newTask = Task(title: title, description: description);
    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text("Add a Task"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "your task title here",
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12,),
            TextField(
              controller: _description,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "your task description here",
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 22,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
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
