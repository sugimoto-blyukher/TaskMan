// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:convert';

import '../models/assignment.dart';
import 'task_repository.dart';

TaskRepository createJsonTaskRepository() => JsonTaskRepositoryWeb();

class JsonTaskRepositoryWeb implements TaskRepository {
  static const _storageKey = 'taskflow_data.json';

  @override
  Future<List<Assignment>> loadAssignments() async {
    final raw = html.window.localStorage[_storageKey];
    if (raw == null) throw StateError('Data not found');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final items = decoded['assignments'] as List<dynamic>;
    return items
        .map((item) => Assignment.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAssignments(List<Assignment> assignments) async {
    final data = {
      'assignments': assignments.map((item) => item.toJson()).toList()
    };
    html.window.localStorage[_storageKey] = jsonEncode(data);
  }
}
