import 'package:flutter/material.dart';

import '../controllers/task_flow_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final TaskFlowController controller;

  Future<bool> _confirm(
      BuildContext context, String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('キャンセル')),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('実行')),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _run(
      BuildContext context, Future<void> Function() action) async {
    try {
      await action();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('完了しました')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('保存に失敗しました')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restart_alt),
                  title: const Text('サンプルデータを再生成'),
                  subtitle: const Text('現在のデータをサンプルで上書きします'),
                  onTap: () async {
                    if (await _confirm(
                            context, 'サンプルデータを再生成しますか？', '現在の課題はすべて置き換わります。') &&
                        context.mounted) {
                      await _run(context, controller.resetSampleData);
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.delete_sweep_outlined,
                      color: Theme.of(context).colorScheme.error),
                  title: const Text('全データ削除'),
                  subtitle: const Text('すべての課題とサブタスクを削除します'),
                  onTap: () async {
                    if (await _confirm(
                            context, '全データを削除しますか？', 'この操作は取り消せません。') &&
                        context.mounted) {
                      await _run(context, controller.clearAll);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('TaskFlow'),
              subtitle: const Text(
                  '課題を小さな行動に分け、締切に基づいて「次の一手」を1つだけ提示する大学生向け課題管理アプリです。\n\nVersion 1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}
