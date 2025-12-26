import 'package:daily_tasks/screens/about_screen.dart';
import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:daily_tasks/screens/home_screen.dart';
import 'package:daily_tasks/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DailyTasks());
}

class DailyTasks extends StatelessWidget{
  const DailyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Daily Tasks",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/about': (context) => const AboutScreen(),
        '/add': (context) => const AddTaskScreen(),
      },
    );
  }
}