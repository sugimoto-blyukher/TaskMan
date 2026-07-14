class TodoItem {
  const TodoItem({
    required this.id,
    required this.title,
    required this.completed,
    required this.order,
    required this.createdAt,
    required this.completedAt,
  });

  final String id;
  final String title;
  final bool completed;
  final int order;
  final DateTime createdAt;
  final DateTime? completedAt;

  TodoItem copyWith({
    String? id,
    String? title,
    bool? completed,
    int? order,
    DateTime? createdAt,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'completed': completed,
        'order': order,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );
  }
}
