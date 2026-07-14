import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/utils/date_utils.dart';

void main() {
  final today = DateTime(2026, 7, 14, 18);

  test('日付差は時刻を無視する', () {
    expect(daysUntil(DateTime(2026, 7, 15, 1), from: today), 1);
  });

  test('締切危険度を判定する', () {
    expect(deadlineStatus(DateTime(2026, 7, 13), from: today),
        DeadlineStatus.overdue);
    expect(deadlineStatus(DateTime(2026, 7, 14), from: today),
        DeadlineStatus.dueToday);
    expect(deadlineStatus(DateTime(2026, 7, 16), from: today),
        DeadlineStatus.urgent);
    expect(deadlineStatus(DateTime(2026, 7, 20), from: today),
        DeadlineStatus.soon);
    expect(
        deadlineStatus(DateTime(2026, 8), from: today), DeadlineStatus.normal);
  });
}
