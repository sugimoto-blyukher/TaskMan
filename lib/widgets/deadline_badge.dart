import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/date_utils.dart';

class DeadlineBadge extends StatelessWidget {
  const DeadlineBadge({super.key, required this.deadline});

  final DateTime deadline;

  @override
  Widget build(BuildContext context) {
    final status = deadlineStatus(deadline);
    final color = switch (status) {
      DeadlineStatus.overdue => AppColors.danger,
      DeadlineStatus.dueToday || DeadlineStatus.urgent => AppColors.warning,
      DeadlineStatus.soon => AppColors.primary,
      DeadlineStatus.normal => AppColors.textSub,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        deadlineLabel(deadline),
        style:
            TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
