import 'package:flutter/material.dart';

import '../models/assignment.dart';
import '../theme/app_colors.dart';
import '../utils/date_utils.dart';
import 'deadline_badge.dart';
import 'progress_bar.dart';

class AssignmentCard extends StatelessWidget {
  const AssignmentCard(
      {super.key, required this.assignment, required this.onTap});

  final Assignment assignment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      assignment.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: assignment.isCompleted
                                ? AppColors.disabled
                                : null,
                          ),
                    ),
                  ),
                  DeadlineBadge(deadline: assignment.deadline),
                ],
              ),
              if (assignment.subject.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(assignment.subject,
                    style: const TextStyle(color: AppColors.textSub)),
              ],
              const SizedBox(height: 12),
              Text('締切: ${formatDate(assignment.deadline)}'),
              const SizedBox(height: 12),
              ProgressBar(percent: assignment.progressPercent),
              const SizedBox(height: 10),
              Text(
                assignment.isCompleted
                    ? '完了'
                    : '未完了: ${assignment.incompleteCount}件',
                style: const TextStyle(color: AppColors.textSub),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
