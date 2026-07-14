import 'package:flutter/material.dart';

import '../controllers/task_flow_controller.dart';
import '../widgets/assignment_card.dart';
import '../widgets/today_task_card.dart';
import 'assignment_detail_screen.dart';
import 'assignment_form_screen.dart';
import 'assignment_list_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});

  final TaskFlowController controller;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  void _addAssignment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                AssignmentFormScreen(controller: widget.controller)));
  }

  void _openDetail(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AssignmentDetailScreen(
              controller: widget.controller, assignmentId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        actions: [
          IconButton(
            tooltip: '設定',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      SettingsScreen(controller: widget.controller)),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          if (widget.controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final todayTask = widget.controller.getTodayTask();
          final upcoming = widget.controller.getUpcomingAssignments();
          return RefreshIndicator(
            onRefresh: widget.controller.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                if (widget.controller.errorMessage != null) ...[
                  MaterialBanner(
                    content: Text(widget.controller.errorMessage!),
                    actions: [
                      TextButton(
                          onPressed: widget.controller.load,
                          child: const Text('再試行'))
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                Text('今日やること',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                TodayTaskCard(
                  todayTask: todayTask,
                  onComplete: () async {
                    if (todayTask == null) return;
                    try {
                      await widget.controller.toggleTodo(
                          todayTask.assignment.id, todayTask.todo.id);
                    } catch (_) {
                      if (mounted) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(content: Text('保存に失敗しました')));
                      }
                    }
                  },
                  onTap: () {
                    if (todayTask != null) {
                      _openDetail(todayTask.assignment.id);
                    }
                  },
                  onAddAssignment: _addAssignment,
                ),
                const SizedBox(height: 28),
                Row(children: [
                  Expanded(
                      child: Text('締切が近い課題',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700))),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AssignmentListScreen(
                              controller: widget.controller)),
                    ),
                    child: const Text('すべて見る'),
                  ),
                ]),
                const SizedBox(height: 8),
                if (upcoming.isEmpty)
                  const Card(
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('未完了の課題はありません。')))
                else
                  ...upcoming.map(
                    (assignment) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AssignmentCard(
                          assignment: assignment,
                          onTap: () => _openDetail(assignment.id)),
                    ),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AssignmentListScreen(
                            controller: widget.controller)),
                  ),
                  icon: const Icon(Icons.list_alt),
                  label: const Text('課題一覧を開く'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _addAssignment, child: const Icon(Icons.add)),
    );
  }
}
