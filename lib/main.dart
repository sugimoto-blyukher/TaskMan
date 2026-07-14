import 'package:flutter/widgets.dart';

import 'app.dart';
import 'controllers/task_flow_controller.dart';
import 'repositories/json_task_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = TaskFlowController(repository: JsonTaskRepository());
  runApp(TaskFlowApp(controller: controller));
}
