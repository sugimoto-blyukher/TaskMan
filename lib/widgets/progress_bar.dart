import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: percent.clamp(0, 100) / 100,
              backgroundColor: AppColors.border,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text('$percent%', textAlign: TextAlign.end),
        ),
      ],
    );
  }
}
