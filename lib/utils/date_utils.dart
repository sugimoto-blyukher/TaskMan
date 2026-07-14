import 'package:intl/intl.dart';

enum DeadlineStatus { overdue, dueToday, urgent, soon, normal }

DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

int daysUntil(DateTime deadline, {DateTime? from}) {
  return dateOnly(deadline).difference(dateOnly(from ?? DateTime.now())).inDays;
}

DeadlineStatus deadlineStatus(DateTime deadline, {DateTime? from}) {
  final days = daysUntil(deadline, from: from);
  if (days < 0) return DeadlineStatus.overdue;
  if (days == 0) return DeadlineStatus.dueToday;
  if (days <= 2) return DeadlineStatus.urgent;
  if (days <= 7) return DeadlineStatus.soon;
  return DeadlineStatus.normal;
}

String formatDate(DateTime date) => DateFormat('yyyy/MM/dd').format(date);

String deadlineLabel(DateTime deadline, {DateTime? from}) {
  final days = daysUntil(deadline, from: from);
  if (days < 0) return '${-days}日超過';
  if (days == 0) return '今日まで';
  return '残り$days日';
}
