import '../models/assignment.dart';
import '../models/todo_item.dart';

abstract final class SampleDataFactory {
  static List<Assignment> create({DateTime? now}) {
    final current = now ?? DateTime.now();
    return [
      Assignment(
        id: 'sample-assignment-1',
        title: '情報数学レポート',
        subject: '情報数学',
        deadline: DateTime(current.year, current.month, current.day + 6),
        description: '線形代数に関するレポート課題',
        createdAt: current,
        updatedAt: current,
        todos: [
          TodoItem(
            id: 'sample-todo-1',
            title: '課題文を読む',
            completed: true,
            order: 1,
            createdAt: current,
            completedAt: current,
          ),
          TodoItem(
            id: 'sample-todo-2',
            title: 'テーマを決める',
            completed: true,
            order: 2,
            createdAt: current,
            completedAt: current,
          ),
          TodoItem(
            id: 'sample-todo-3',
            title: '参考文献を2本探す',
            completed: false,
            order: 3,
            createdAt: current,
            completedAt: null,
          ),
          TodoItem(
            id: 'sample-todo-4',
            title: '構成を書く',
            completed: false,
            order: 4,
            createdAt: current,
            completedAt: null,
          ),
        ],
      ),
    ];
  }
}
