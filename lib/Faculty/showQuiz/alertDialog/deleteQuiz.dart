import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../reusableWidgets/toastWidget.dart';

/// Shows a confirmation dialog and deletes the quiz from Firestore
void deleteQuiz(BuildContext context, AsyncSnapshot snapshot, int index) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete Quiz"),
        content: Text(
          "Are you sure you want to delete \"${snapshot.data.docs[index]['Quiz Title']}\"?\n\nThis action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                String? email =
                    FirebaseAuth.instance.currentUser?.email.toString();
                String docId = snapshot.data.docs[index].id.toString();

                // First delete all documents in the sub-collection (questions)
                var subCollection = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(email)
                    .collection("questions")
                    .doc(docId)
                    .collection(docId)
                    .get();

                for (var doc in subCollection.docs) {
                  await doc.reference.delete();
                }

                // Then delete the quiz document itself
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(email)
                    .collection("questions")
                    .doc(docId)
                    .delete();

                // Update the attempt count
                var userDoc = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(email)
                    .get();
                int currentAttempt = userDoc.data()?['attempt'] ?? 1;
                if (currentAttempt > 0) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(email)
                      .update({"attempt": currentAttempt - 1});
                }

                Navigator.pop(context); // Close confirmation dialog
                Navigator.pop(context); // Close quiz details dialog
                short_flutter_toast("Quiz deleted successfully!");
              } catch (e) {
                Navigator.pop(context);
                short_flutter_toast("Error deleting quiz: $e");
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
