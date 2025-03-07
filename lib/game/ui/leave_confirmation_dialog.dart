import 'package:flutter/material.dart';

Future<bool?> showLeaveConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return LeaveConfirmationDialog();
    },
  );
}

class LeaveConfirmationDialog extends StatelessWidget {
  const LeaveConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Вы уверены?'),
      content: Text('Вы уверены, что хотите покинуть игру?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Отмена'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Выйти'),
        ),
      ],
    );
  }
}
