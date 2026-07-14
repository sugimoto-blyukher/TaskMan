import '../models/assignment.dart';

abstract class TaskRepository {
  Future<List<Assignment>> loadAssignments();
  Future<void> saveAssignments(List<Assignment> assignments);
}
