import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDialog({
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: Colors.blue.shade800),),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: Text("Cancel", style: TextStyle(color: Colors.blue.shade800),),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text("Confirm", style: TextStyle(color: Colors.blue.shade800),),
        ),
      ],
    );
  }
}

Future<void> showConfirmDialog(
    BuildContext context, String title, String message, VoidCallback onConfirm) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmDialog(
        title: title,
        message: message,
        onConfirm: onConfirm,
        onCancel: () => Navigator.of(context).pop(),
      );
    },
  );
}
