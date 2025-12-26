import 'package:daily_tasks/models/task_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filter = "All";
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    print('Loading tasks...');  // Debug
    setState(() {
      _isLoading = true;
    });

    final tasks = await loadTasksFromPrefs();

    print('Tasks loaded: ${tasks.length}');  // Debug
    for (var task in tasks) {
      print('Task: ${task.title}');  // Debug
    }

    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> toggleTaskDone(int index) async {
    setState(() {
      _tasks[index].toggleDone();
    });
    await saveTasksToPrefs(_tasks);
  }

  Future<void> deleteTask(int index) async {
    setState(() => _tasks.removeAt(index));
    await saveTasksToPrefs(_tasks);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task deleted!"))
    );
  }

  Future<void> openAddScreen() async {
    print('Opening add screen...');  // Debug
    final result = await Navigator.pushNamed(context, '/add');
    print('Returned from add screen with result: $result');  // Debug

    if (result == true) {
      print('Reloading tasks...');  // Debug
      await _loadTasks();
    }
  }

  List<Task> _getFilteredTasks() {
    if (filter == "Pending") {
      return _tasks.where((task) => !task.isDone).toList();
    } else if (filter == "Completed") {
      return _tasks.where((task) => task.isDone).toList();
    }
    return _tasks;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text("Today's Tasks"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Filter buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton("All"),
                const SizedBox(width: 12),
                _buildFilterButton("Pending"),
                const SizedBox(width: 12),
                _buildFilterButton("Completed"),
              ],
            ),
            const SizedBox(height: 12),

            // Task list
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
                  : filteredTasks.isEmpty
                  ? Center(
                child: Text(
                  filter == "All"
                      ? "No tasks yet! Tap + to add one."
                      : "No $filter tasks.",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  final originalIndex = _tasks.indexOf(task);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: task.description.isNotEmpty
                          ? Text(task.description)
                          : null,
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (val) => toggleTaskDone(originalIndex),
                        activeColor: Colors.green,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteTask(originalIndex),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddScreen,
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }

  Widget _buildFilterButton(String filterName) {
    return GestureDetector(
      onTap: () => setState(() => filter = filterName),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: filter == filterName ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          filterName,
          style: TextStyle(
            color: filter == filterName ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}