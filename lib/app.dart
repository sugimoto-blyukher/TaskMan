import 'package:flutter/material.dart';

import 'controllers/task_flow_controller.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key, required this.controller});

  final TaskFlowController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: HomeScreen(controller: controller),
    );
  }
}
