import 'package:flutter/foundation.dart';

import '../data/sample_data_factory.dart';
import '../models/assignment.dart';
import '../models/todo_item.dart';
import '../models/today_task.dart';
import '../repositories/task_repository.dart';

class TaskFlowController extends ChangeNotifier {
  TaskFlowController({required this.repository});

  final TaskRepository repository;
  List<Assignment> _assignments = [];
  bool _loading = false;
  String? _errorMessage;

  List<Assignment> get assignments => List.unmodifiable(_assignments);
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  Assignment? assignmentById(String id) {
    for (final assignment in _assignments) {
      if (assignment.id == id) return assignment;
    }
    return null;
  }

  Future<void> load() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _assignments = await repository.loadAssignments();
    } catch (error) {
      _errorMessage = '保存データを読み込めなかったため、サンプルデータを表示しています。';
      _assignments = SampleDataFactory.create();
      try {
        await repository.saveAssignments(_assignments);
      } catch (_) {
        // The sample remains usable in memory when storage is unavailable.
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addAssignment(Assignment assignment) async {
    await _mutate(() => _assignments.add(assignment));
  }

  Future<void> updateAssignment(Assignment assignment) async {
    await _mutate(() {
      final index = _assignments.indexWhere((item) => item.id == assignment.id);
      if (index < 0) throw StateError('Assignment not found');
      _assignments[index] = assignment.copyWith(updatedAt: DateTime.now());
    });
  }

  Future<void> deleteAssignment(String assignmentId) async {
    await _mutate(
      () => _assignments.removeWhere((item) => item.id == assignmentId),
    );
  }

  Future<void> addTodo(String assignmentId, TodoItem todo) async {
    await _mutate(() {
      final index = _indexOf(assignmentId);
      _assignments[index] = _assignments[index].copyWith(
        todos: [..._assignments[index].todos, todo],
        updatedAt: DateTime.now(),
      );
    });
  }

  Future<void> toggleTodo(String assignmentId, String todoId) async {
    await _mutate(() {
      final index = _indexOf(assignmentId);
      final assignment = _assignments[index];
      final todos = assignment.todos.map((todo) {
        if (todo.id != todoId) return todo;
        final completed = !todo.completed;
        return todo.copyWith(
          completed: completed,
          completedAt: completed ? DateTime.now() : null,
          clearCompletedAt: !completed,
        );
      }).toList();
      _assignments[index] = assignment.copyWith(
        todos: todos,
        updatedAt: DateTime.now(),
      );
    });
  }

  Future<void> deleteTodo(String assignmentId, String todoId) async {
    await _mutate(() {
      final index = _indexOf(assignmentId);
      final assignment = _assignments[index];
      _assignments[index] = assignment.copyWith(
        todos: assignment.todos.where((todo) => todo.id != todoId).toList(),
        updatedAt: DateTime.now(),
      );
    });
  }

  TodayTask? getTodayTask() {
    // The earliest deadline wins; each assignment contributes its first pending action.
    for (final assignment in getSortedAssignments()) {
      if (assignment.isCompleted) continue;
      final todo = assignment.nextTodo;
      if (todo != null) return TodayTask(assignment: assignment, todo: todo);
    }
    return null;
  }

  List<Assignment> getSortedAssignments() {
    final result = [..._assignments];
    result.sort((a, b) {
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
      final byDeadline = a.deadline.compareTo(b.deadline);
      return byDeadline != 0 ? byDeadline : a.createdAt.compareTo(b.createdAt);
    });
    return result;
  }

  List<Assignment> getUpcomingAssignments({int limit = 3}) {
    return getSortedAssignments()
        .where((assignment) => !assignment.isCompleted)
        .take(limit)
        .toList();
  }

  Future<void> resetSampleData() async {
    await _replaceAll(SampleDataFactory.create());
  }

  Future<void> clearAll() async {
    await _replaceAll([]);
  }

  int _indexOf(String assignmentId) {
    final index = _assignments.indexWhere((item) => item.id == assignmentId);
    if (index < 0) throw StateError('Assignment not found');
    return index;
  }

  Future<void> _replaceAll(List<Assignment> assignments) async {
    await _mutate(() => _assignments = [...assignments]);
  }

  Future<void> _mutate(VoidCallback change) async {
    final previous = [..._assignments];
    _errorMessage = null;
    try {
      change();
      await repository.saveAssignments(_assignments);
    } catch (error) {
      _assignments = previous;
      _errorMessage = '保存に失敗しました。もう一度お試しください。';
      notifyListeners();
      rethrow;
    }
    notifyListeners();
  }
}
