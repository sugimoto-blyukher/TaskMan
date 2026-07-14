import 'package:flutter/material.dart';

import '../controllers/task_flow_controller.dart';
import '../models/assignment.dart';
import '../utils/date_utils.dart';
import '../utils/id_generator.dart';

class AssignmentFormScreen extends StatefulWidget {
  const AssignmentFormScreen({
    super.key,
    required this.controller,
    this.assignment,
  });

  final TaskFlowController controller;
  final Assignment? assignment;

  @override
  State<AssignmentFormScreen> createState() => _AssignmentFormScreenState();
}

class _AssignmentFormScreenState extends State<AssignmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _subjectController;
  late final TextEditingController _descriptionController;
  DateTime? _deadline;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final assignment = widget.assignment;
    _titleController = TextEditingController(text: assignment?.title);
    _subjectController = TextEditingController(text: assignment?.subject);
    _descriptionController =
        TextEditingController(text: assignment?.description);
    _deadline = assignment?.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 20),
    );
    if (selected != null) setState(() => _deadline = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_deadline == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('締切を選択してください')));
      return;
    }
    setState(() => _saving = true);
    final old = widget.assignment;
    final now = DateTime.now();
    final assignment = Assignment(
      id: old?.id ?? IdGenerator.create(),
      title: _titleController.text.trim(),
      subject: _subjectController.text.trim(),
      deadline: _deadline!,
      description: _descriptionController.text.trim(),
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
      todos: old?.todos ?? const [],
    );
    try {
      if (old == null) {
        await widget.controller.addAssignment(assignment);
      } else {
        await widget.controller.updateAssignment(assignment);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('保存に失敗しました')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.assignment != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? '課題編集' : '課題追加')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  autofocus: !editing,
                  decoration: const InputDecoration(
                      labelText: '課題名 *', hintText: '情報数学レポート'),
                  textInputAction: TextInputAction.next,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? '課題名を入力してください'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subjectController,
                  decoration:
                      const InputDecoration(labelText: '科目', hintText: '情報数学'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDeadline,
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        labelText: '締切 *',
                        suffixIcon: Icon(Icons.calendar_today_outlined)),
                    child: Text(
                        _deadline == null ? '締切を選択' : formatDate(_deadline!)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      labelText: '説明', alignLabelWithHint: true),
                  minLines: 3,
                  maxLines: 6,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? '保存中…' : '保存'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
