import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/assignment.dart';
import 'task_repository.dart';

TaskRepository createJsonTaskRepository() => JsonTaskRepositoryIo();

class JsonTaskRepositoryIo implements TaskRepository {
  Future<File> _getDataFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/taskflow_data.json');
  }

  @override
  Future<List<Assignment>> loadAssignments() async {
    final file = await _getDataFile();
    if (!await file.exists()) {
      throw const FileSystemException('Data file not found');
    }
    final decoded =
        jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final items = decoded['assignments'] as List<dynamic>;
    return items
        .map((item) => Assignment.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAssignments(List<Assignment> assignments) async {
    final file = await _getDataFile();
    final data = {
      'assignments': assignments.map((item) => item.toJson()).toList()
    };
    await file.writeAsString(jsonEncode(data), flush: true);
  }
}
