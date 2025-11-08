
class Task{
  String title;
  String description;
  bool isDone;

  Task({
   required this.title,
   required this.description,
   this.isDone = false
  });

  void toggleDone() => isDone = !isDone;
}