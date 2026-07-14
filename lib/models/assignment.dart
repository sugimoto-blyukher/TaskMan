import 'todo_item.dart';

class Assignment {
  const Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.todos,
  });

  final String id;
  final String title;
  final String subject;
  final DateTime deadline;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TodoItem> todos;

  int get progressPercent {
    if (todos.isEmpty) return 0;
    final done = todos.where((todo) => todo.completed).length;
    return ((done / todos.length) * 100).round();
  }

  bool get isCompleted =>
      todos.isNotEmpty && todos.every((todo) => todo.completed);

  int get incompleteCount => todos.where((todo) => !todo.completed).length;

  TodoItem? get nextTodo {
    final pending = todos.where((todo) => !todo.completed).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return pending.isEmpty ? null : pending.first;
  }

  Assignment copyWith({
    String? id,
    String? title,
    String? subject,
    DateTime? deadline,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TodoItem>? todos,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      deadline: deadline ?? this.deadline,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      todos: todos ?? this.todos,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'deadline': deadline.toIso8601String(),
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'todos': todos.map((todo) => todo.toJson()).toList(),
      };

  factory Assignment.fromJson(Map<String, dynamic> json) {
    final todos = json['todos'] as List<dynamic>;
    return Assignment(
      id: json['id'] as String,
      title: json['title'] as String,
      subject: json['subject'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      todos: todos
          .map((item) => TodoItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
