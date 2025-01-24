import 'package:flutter/material.dart';

Future<void> showGenericDialog({
  required BuildContext context,
  required String title,
  required String content,
  String buttonText = 'Done',
  TextStyle buttonStyle = const TextStyle(
    color: Color.fromRGBO(0, 179, 134, 1.0),
    fontSize: 20,
  ),
  VoidCallback? onButtonPressed,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              if (onButtonPressed != null) {
                onButtonPressed();
              }
              Navigator.of(context).pop();
            },
            child: Text(buttonText, style: buttonStyle),
          ),
        ],
      );
    },
  );
}
