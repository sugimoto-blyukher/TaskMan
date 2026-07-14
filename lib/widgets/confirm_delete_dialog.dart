import 'package:flutter/material.dart';

Future<bool> showConfirmDeleteDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('この課題を削除しますか？'),
          content: const Text('削除するとサブタスクも消えます。'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('キャンセル')),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              child: const Text('削除'),
            ),
          ],
        ),
      ) ??
      false;
}
