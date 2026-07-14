import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/models/assignment.dart';
import 'package:taskflow/models/todo_item.dart';

TodoItem todo(int order, {bool completed = false}) => TodoItem(
      id: 't$order',
      title: 'Todo $order',
      completed: completed,
      order: order,
      createdAt: DateTime(2026),
      completedAt: completed ? DateTime(2026) : null,
    );

Assignment assignment(List<TodoItem> todos) => Assignment(
      id: 'a1',
      title: '課題',
      subject: '',
      deadline: DateTime(2026, 7, 20),
      description: '',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
      todos: todos,
    );

void main() {
  test('todosが空の場合の進捗は0で未完了', () {
    final target = assignment([]);
    expect(target.progressPercent, 0);
    expect(target.isCompleted, isFalse);
  });

  test('2/4完了の場合の進捗は50', () {
    final target = assignment(
        [todo(1, completed: true), todo(2, completed: true), todo(3), todo(4)]);
    expect(target.progressPercent, 50);
  });

  test('全Todo完了の場合は課題完了', () {
    expect(assignment([todo(1, completed: true)]).isCompleted, isTrue);
  });

  test('nextTodoはorder最小の未完了Todo', () {
    final target = assignment([todo(5), todo(1, completed: true), todo(3)]);
    expect(target.nextTodo?.id, 't3');
  });

  test('JSONで往復できる', () {
    final target = assignment([todo(1)]);
    final restored = Assignment.fromJson(target.toJson());
    expect(restored.title, target.title);
    expect(restored.todos.single.id, 't1');
  });
}
