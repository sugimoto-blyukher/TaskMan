import 'package:flutter/material.dart';

import '../controllers/task_flow_controller.dart';
import '../theme/app_colors.dart';
import '../utils/date_utils.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/deadline_badge.dart';
import '../widgets/empty_state.dart';
import '../widgets/progress_bar.dart';
import 'assignment_form_screen.dart';
import 'todo_form_screen.dart';

class AssignmentDetailScreen extends StatelessWidget {
  const AssignmentDetailScreen({
    super.key,
    required this.controller,
    required this.assignmentId,
  });

  final TaskFlowController controller;
  final String assignmentId;

  Future<void> _delete(BuildContext context) async {
    if (!await showConfirmDeleteDialog(context) || !context.mounted) return;
    try {
      await controller.deleteAssignment(assignmentId);
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('削除に失敗しました')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final assignment = controller.assignmentById(assignmentId);
        if (assignment == null) {
          return Scaffold(
              appBar: AppBar(),
              body: const EmptyState(
                  title: '課題が見つかりません', message: '削除された可能性があります。'));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(assignment.title),
            actions: [
              IconButton(
                tooltip: '編集',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AssignmentFormScreen(
                          controller: controller, assignment: assignment)),
                ),
              ),
              IconButton(
                  tooltip: '削除',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _delete(context)),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (assignment.subject.isNotEmpty)
                        Text(assignment.subject,
                            style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                            child:
                                Text('締切: ${formatDate(assignment.deadline)}')),
                        DeadlineBadge(deadline: assignment.deadline),
                      ]),
                      if (assignment.description.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Text(assignment.description),
                      ],
                      const SizedBox(height: 20),
                      Text('進捗 ${assignment.progressPercent}%',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      ProgressBar(percent: assignment.progressPercent),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(
                    child: Text('サブタスク',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700))),
                Text('${assignment.todos.length}件',
                    style: const TextStyle(color: AppColors.textSub)),
              ]),
              const SizedBox(height: 12),
              if (assignment.todos.isEmpty)
                const Card(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('サブタスクがありません。次の行動を追加してみましょう。')))
              else
                ...([...assignment.todos]
                      ..sort((a, b) => a.order.compareTo(b.order)))
                    .map(
                  (todo) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (_) async {
                          try {
                            await controller.toggleTodo(assignmentId, todo.id);
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('保存に失敗しました')));
                            }
                          }
                        },
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          color: todo.completed
                              ? AppColors.disabled
                              : AppColors.textMain,
                          decoration: todo.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        tooltip: 'サブタスクを削除',
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () async {
                          try {
                            await controller.deleteTodo(assignmentId, todo.id);
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('削除に失敗しました')));
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TodoFormScreen(
                          controller: controller, assignmentId: assignmentId)),
                ),
                icon: const Icon(Icons.add),
                label: const Text('サブタスクを追加'),
              ),
            ],
          ),
        );
      },
    );
  }
}
