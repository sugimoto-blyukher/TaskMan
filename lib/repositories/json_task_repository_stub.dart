import '../models/assignment.dart';
import 'task_repository.dart';

TaskRepository createJsonTaskRepository() => _UnsupportedRepository();

class _UnsupportedRepository implements TaskRepository {
  @override
  Future<List<Assignment>> loadAssignments() {
    throw UnsupportedError('This platform does not support local storage.');
  }

  @override
  Future<void> saveAssignments(List<Assignment> assignments) {
    throw UnsupportedError('This platform does not support local storage.');
  }
}
