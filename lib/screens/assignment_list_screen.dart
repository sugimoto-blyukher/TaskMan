import 'package:flutter/material.dart';

import '../controllers/task_flow_controller.dart';
import '../widgets/assignment_card.dart';
import '../widgets/empty_state.dart';
import 'assignment_detail_screen.dart';
import 'assignment_form_screen.dart';

class AssignmentListScreen extends StatelessWidget {
  const AssignmentListScreen({super.key, required this.controller});

  final TaskFlowController controller;

  void _add(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AssignmentFormScreen(controller: controller)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('課題一覧')),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final assignments = controller.getSortedAssignments();
          if (assignments.isEmpty) {
            return EmptyState(
              title: '課題がありません',
              message: '右下の＋ボタンから課題を追加してください。',
              buttonLabel: '課題を追加',
              onPressed: () => _add(context),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: assignments.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return AssignmentCard(
                assignment: assignment,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AssignmentDetailScreen(
                          controller: controller, assignmentId: assignment.id)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _add(context), child: const Icon(Icons.add)),
    );
  }
}
