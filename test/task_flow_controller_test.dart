import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/controllers/task_flow_controller.dart';
import 'package:taskflow/models/assignment.dart';
import 'package:taskflow/models/todo_item.dart';
import 'package:taskflow/repositories/task_repository.dart';

class MemoryRepository implements TaskRepository {
  MemoryRepository([List<Assignment>? initial]) : values = [...?initial];
  List<Assignment> values;

  @override
  Future<List<Assignment>> loadAssignments() async => [...values];

  @override
  Future<void> saveAssignments(List<Assignment> assignments) async {
    values = [...assignments];
  }
}

TodoItem makeTodo(String id, int order) => TodoItem(
      id: id,
      title: id,
      completed: false,
      order: order,
      createdAt: DateTime(2026),
      completedAt: null,
    );

Assignment makeAssignment(String id, int deadlineDay,
        {List<TodoItem> todos = const []}) =>
    Assignment(
      id: id,
      title: id,
      subject: '',
      deadline: DateTime(2026, 7, deadlineDay),
      description: '',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
      todos: todos,
    );

void main() {
  late MemoryRepository repository;
  late TaskFlowController controller;

  setUp(() async {
    repository = MemoryRepository();
    controller = TaskFlowController(repository: repository);
    await controller.load();
  });

  test('課題の追加と削除', () async {
    await controller.addAssignment(makeAssignment('a', 20));
    expect(controller.assignments, hasLength(1));
    await controller.deleteAssignment('a');
    expect(controller.assignments, isEmpty);
  });

  test('Todoの追加と完了切替', () async {
    await controller.addAssignment(makeAssignment('a', 20));
    await controller.addTodo('a', makeTodo('t', 1));
    expect(controller.assignmentById('a')?.todos, hasLength(1));
    await controller.toggleTodo('a', 't');
    expect(controller.assignmentById('a')?.todos.single.completed, isTrue);
  });

  test('今日やることは締切最短課題のorder最小Todo', () async {
    await controller.addAssignment(
        makeAssignment('later', 22, todos: [makeTodo('later-todo', 1)]));
    await controller.addAssignment(makeAssignment('soon', 16,
        todos: [makeTodo('second', 2), makeTodo('first', 1)]));
    expect(controller.getTodayTask()?.assignment.id, 'soon');
    expect(controller.getTodayTask()?.todo.id, 'first');
  });

  test('clearAllで空になる', () async {
    await controller.addAssignment(makeAssignment('a', 20));
    await controller.clearAll();
    expect(controller.assignments, isEmpty);
    expect(repository.values, isEmpty);
  });
}
