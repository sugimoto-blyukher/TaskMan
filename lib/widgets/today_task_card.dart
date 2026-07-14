import 'package:flutter/material.dart';

import '../models/today_task.dart';
import '../theme/app_colors.dart';
import '../utils/date_utils.dart';
import 'deadline_badge.dart';
import 'progress_bar.dart';

class TodayTaskCard extends StatelessWidget {
  const TodayTaskCard({
    super.key,
    required this.todayTask,
    required this.onComplete,
    required this.onTap,
    required this.onAddAssignment,
  });

  final TodayTask? todayTask;
  final VoidCallback onComplete;
  final VoidCallback onTap;
  final VoidCallback onAddAssignment;

  @override
  Widget build(BuildContext context) {
    final task = todayTask;
    if (task == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.celebration_outlined,
                  size: 42, color: AppColors.success),
              const SizedBox(height: 12),
              Text('未完了のサブタスクはありません。',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              const Text('課題を追加するか、既存の課題にサブタスクを追加してください。',
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(
                  onPressed: onAddAssignment, child: const Text('課題を追加する')),
            ],
          ),
        ),
      );
    }
    return Card(
      color: AppColors.primaryLight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Text(task.assignment.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700))),
                DeadlineBadge(deadline: task.assignment.deadline),
              ]),
              const SizedBox(height: 20),
              const Text('次の作業', style: TextStyle(color: AppColors.textSub)),
              const SizedBox(height: 6),
              Text(task.todo.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Text('締切: ${formatDate(task.assignment.deadline)}'),
              const SizedBox(height: 12),
              ProgressBar(percent: task.assignment.progressPercent),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.check),
                label: const Text('完了にする'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
