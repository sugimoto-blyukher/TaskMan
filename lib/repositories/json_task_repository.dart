import '../models/assignment.dart';
import 'json_task_repository_stub.dart'
    if (dart.library.io) 'json_task_repository_io.dart'
    if (dart.library.html) 'json_task_repository_web.dart';
import 'task_repository.dart';

class JsonTaskRepository implements TaskRepository {
  JsonTaskRepository() : _delegate = createJsonTaskRepository();

  final TaskRepository _delegate;

  @override
  Future<List<Assignment>> loadAssignments() => _delegate.loadAssignments();

  @override
  Future<void> saveAssignments(List<Assignment> assignments) =>
      _delegate.saveAssignments(assignments);
}
