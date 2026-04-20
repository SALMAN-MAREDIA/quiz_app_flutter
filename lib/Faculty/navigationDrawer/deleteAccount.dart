import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../reusableWidgets/Responsive.dart';
import '../../reusableWidgets/toastWidget.dart';

/// ListTile for the navigation drawer
ListTile listTileDeleteAccount(context) {
  return ListTile(
    contentPadding: const EdgeInsets.only(top: 5, left: 20, bottom: 10),
    leading: const Icon(Icons.delete_forever, size: 22, color: Colors.red),
    title: Text(
      "Delete Account",
      style: TextStyle(
        fontSize: setSize(context, 18),
        fontWeight: FontWeight.w500,
        color: Colors.red,
      ),
    ),
    onTap: () {
      Navigator.pop(context); // Close drawer
      deleteFacultyAccount(context);
    },
  );
}

/// Shows confirmation dialog and permanently deletes faculty account,
/// all quizzes, and their sub-collections from Firestore + Firebase Auth.
void deleteFacultyAccount(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text("Delete Account",
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          "⚠️ This will PERMANENTLY delete:\n\n"
          "• Your account\n"
          "• All your quizzes\n"
          "• All quiz questions\n"
          "• Your profile data\n\n"
          "This action CANNOT be undone!",
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _showFinalConfirmation(context);
            },
            child: const Text("Delete Everything",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      );
    },
  );
}

/// Second confirmation step to prevent accidental deletion
void _showFinalConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Are you absolutely sure?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          "Type DELETE to confirm.\nAll data will be permanently removed.",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await _performAccountDeletion(context);
            },
            child: const Text("YES, DELETE PERMANENTLY",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

/// Performs the actual deletion of all faculty data and auth account
Future<void> _performAccountDeletion(BuildContext context) async {
  // Show a loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Expanded(child: Text("Deleting account and all data...")),
          ],
        ),
      );
    },
  );

  try {
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      Navigator.pop(context);
      short_flutter_toast("Error: No user logged in");
      return;
    }

    // Step 1: Get all quiz documents for this faculty
    var quizzesSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .collection("questions")
        .get();

    // Step 2: For each quiz, delete all questions in its sub-collection
    for (var quizDoc in quizzesSnapshot.docs) {
      String quizId = quizDoc.id;

      // Delete all documents in the quiz's question sub-collection
      var questionsSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(email)
          .collection("questions")
          .doc(quizId)
          .collection(quizId)
          .get();

      for (var questionDoc in questionsSnapshot.docs) {
        await questionDoc.reference.delete();
      }

      // Delete the quiz document itself
      await quizDoc.reference.delete();
    }

    // Step 3: Delete all answer records (if any stored under this user)
    var answersSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .collection("answers")
        .get();

    for (var answerDoc in answersSnapshot.docs) {
      await answerDoc.reference.delete();
    }

    // Step 4: Delete the user document from Firestore
    await FirebaseFirestore.instance.collection("users").doc(email).delete();

    // Step 5: Delete the Firebase Auth account
    await FirebaseAuth.instance.currentUser?.delete();

    // Close loading dialog
    Navigator.pop(context);

    // Navigate to login screen (pop all routes)
    Navigator.of(context).popUntil((route) => route.isFirst);

    short_flutter_toast("Account and all data deleted permanently.");
  } catch (e) {
    // Close loading dialog
    Navigator.pop(context);

    if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
      short_flutter_toast(
          "Please log out and log back in, then try again.");
    } else {
      short_flutter_toast("Error deleting account: $e");
    }
  }
}
