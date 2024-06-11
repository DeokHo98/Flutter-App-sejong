import 'package:flutter/material.dart';

extension ShowAlertDialogExtension on BuildContext {
  void showAlertDialog({
    required String title,
    required String message,
    required String buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}