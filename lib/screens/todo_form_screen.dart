import 'package:flutter/material.dart';

import '../controllers/task_flow_controller.dart';
import '../models/todo_item.dart';
import '../utils/id_generator.dart';

class TodoFormScreen extends StatefulWidget {
  const TodoFormScreen({
    super.key,
    required this.controller,
    required this.assignmentId,
  });

  final TaskFlowController controller;
  final String assignmentId;

  @override
  State<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final assignment = widget.controller.assignmentById(widget.assignmentId);
    if (assignment == null) return;
    setState(() => _saving = true);
    final maxOrder = assignment.todos
        .fold<int>(0, (max, todo) => todo.order > max ? todo.order : max);
    final todo = TodoItem(
      id: IdGenerator.create(),
      title: _titleController.text.trim(),
      completed: false,
      order: maxOrder + 1,
      createdAt: DateTime.now(),
      completedAt: null,
    );
    try {
      await widget.controller.addTodo(widget.assignmentId, todo);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('保存に失敗しました')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignment = widget.controller.assignmentById(widget.assignmentId);
    return Scaffold(
      appBar: AppBar(title: const Text('サブタスク追加')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('対象課題', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              Text(assignment?.title ?? '',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: 'サブタスク名 *', hintText: '参考文献を2本探す'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'サブタスク名を入力してください'
                    : null,
                onFieldSubmitted: (_) => _saving ? null : _save(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? '保存中…' : '保存')),
            ],
          ),
        ),
      ),
    );
  }
}
