import 'package:flutter/material.dart';

class InfoDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.blue.shade900, fontSize: 20),),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}
