import 'package:flutter/material.dart';
void showAlert(BuildContext context,String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Connection Alert'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}