import 'package:flutter/material.dart';

Future<bool?> showFinishConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => FinishConfirmationDialog(),
  );
}

class FinishConfirmationDialog extends StatelessWidget {
  const FinishConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Вы уверены?'),
      content: Text('Вы уверены, что хотите завершить игру?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Отмена'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Завершить'),
        ),
      ],
    );
  }
}
