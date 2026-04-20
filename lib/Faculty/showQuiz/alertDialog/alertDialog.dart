import 'package:flutter/material.dart';

import 'alertDialogContent.dart';
import 'alertDialogTitle.dart';
import 'deleteQuiz.dart';

alertDialogMyQuiz(context, snapshot, index) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        title: titleOfAlertDialog(context, index, snapshot),
        content: contentOfAlertDialog(context, index, snapshot),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              deleteQuiz(context, snapshot, index);
            },
            icon: const Icon(Icons.delete, color: Colors.white, size: 18),
            label:
                const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
