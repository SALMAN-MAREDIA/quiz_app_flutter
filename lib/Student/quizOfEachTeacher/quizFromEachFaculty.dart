import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/studentProviders/studentProvider.dart';
import '../../reusableWidgets/Responsive.dart';
import '../../reusableWidgets/appBar.dart';
import '../../reusableWidgets/createColor.dart';
import '../InstructionDialog/dialogMain.dart';
import 'showQuizForStudent.dart';

class QuizFromEachFaculty extends StatefulWidget {
  const QuizFromEachFaculty({Key? key}) : super(key: key);

  @override
  State<QuizFromEachFaculty> createState() => _QuizFromEachFacultyState();
}

class _QuizFromEachFacultyState extends State<QuizFromEachFaculty> {
  // Set of quiz IDs already attempted by the student
  Set<String> _attemptedQuizKeys = {};
  bool _loadedAttempted = false;

  @override
  void initState() {
    super.initState();
    _loadAttemptedQuizzes();
  }

  /// Load the list of quizzes this student has already attempted
  Future<void> _loadAttemptedQuizzes() async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;

    var answersSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .collection("answers")
        .get();

    Set<String> attempted = {};
    for (var doc in answersSnapshot.docs) {
      var data = doc.data();
      // Create a unique key from faculty email + quiz title
      String facultyEmail = data['Faculty Email'] ?? '';
      String quizTitle = data['Quiz Title'] ?? '';
      String quizID = data['Quiz ID'] ?? '';
      if (quizID.isNotEmpty) {
        attempted.add("$facultyEmail|$quizID");
      } else {
        // Fallback for old answers without Quiz ID
        attempted.add("$facultyEmail|$quizTitle");
      }
    }

    if (mounted) {
      setState(() {
        _attemptedQuizKeys = attempted;
        _loadedAttempted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSimple(context, "Quiz From Faculty"),
      body: Consumer<StudentProvider>(
        builder: (context, providerValue, child) {
          // Firebase Snapshot......................
          var firestoreSnapshots = FirebaseFirestore.instance
              .collection("users")
              .doc(providerValue.facultyEmail)
              .collection("questions")
              .snapshots();

          return Container(
            alignment: Alignment.topCenter,
            child: StreamBuilder(
              stream: firestoreSnapshots,
              builder: (context, snapshot) {
                if ((snapshot.data?.docs.length).toString() == "null" ||
                    (snapshot.data?.docs.length).toString() == "0") {
                  // If no List Available show this container.....................
                  return Container(
                      alignment: Alignment.center,
                      child: textNoQuizAvailable());
                }

                if (!_loadedAttempted) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter out already attempted quizzes
                var allDocs = snapshot.data!.docs;
                var unattemptedDocs = allDocs.where((doc) {
                  String quizID = doc.id;
                  String quizTitle = doc['Quiz Title'] ?? '';
                  String facultyEmail = providerValue.facultyEmail;
                  // Check both Quiz ID based key and title based key (fallback)
                  return !_attemptedQuizKeys
                          .contains("$facultyEmail|$quizID") &&
                      !_attemptedQuizKeys
                          .contains("$facultyEmail|$quizTitle");
                }).toList();

                if (unattemptedDocs.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,
                            size: 60, color: Colors.green.shade400),
                        const SizedBox(height: 16),
                        Text(
                          "🎉 All Quizzes Completed!\nYou have attempted all available quizzes.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: setSize(context, 18),
                              fontWeight: FontWeight.bold,
                              color: hexToColor("#263300"),
                              height: 1.5),
                        ),
                      ],
                    ),
                  );
                }

                // Build list/grid of unattempted quizzes
                return ResponsiveWidget.isSmallScreen(context)
                    ? ListView.builder(
                        itemCount: unattemptedDocs.length,
                        itemBuilder: (context, index) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return _buildQuizCard(
                              context, unattemptedDocs, index, providerValue);
                        },
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                ResponsiveWidget.isMediumScreen(context)
                                    ? 2
                                    : 3,
                            mainAxisExtent: screenHeight(context) / 1.5),
                        itemCount: unattemptedDocs.length,
                        itemBuilder: (context, index) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return _buildQuizCard(
                              context, unattemptedDocs, index, providerValue);
                        },
                      );
              },
            ),
          );
        },
      ),
    );
  }

  /// Build a quiz card from filtered documents
  Widget _buildQuizCard(BuildContext context,
      List<QueryDocumentSnapshot> docs, int index, StudentProvider provider) {
    var doc = docs[index];

    int quizDuration = 10;
    try {
      quizDuration = doc['Quiz Duration'] ?? 10;
    } catch (_) {
      quizDuration = 10;
    }

    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 20,
      child: Column(
        children: [
          textDisplay(doc['Quiz Title'].toString(), "title", context),
          textDisplay(doc['Quiz Description'].toString(), "desc", context),
          textDisplay(doc['Difficulty'].toString(), "diff", context),
          textDisplay(doc['Total Questions'].toString(), "total", context),
          textDisplay("$quizDuration minutes", "time", context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  provider.getDifficultyLevel(doc['Difficulty'].toString());
                  provider.getTotalQuestions(
                      doc['Total Questions'].toString());
                  provider.getQuizTitle(doc['Quiz Title'].toString());
                  provider.getQuizDescription(
                      doc['Quiz Description'].toString());
                  provider.getQuizID(doc.id.toString());
                  provider.setQuizDuration(quizDuration);
                  dialogBoxForInstructions(context);
                },
                child: const Text("Attempt Quiz")),
          ),
        ],
      ),
    );
  }

  Text textNoQuizAvailable() {
    return Text(
      "This Faculty has no Quiz to Show.\n Kindly check back later.!",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: setSize(context, 17),
          fontWeight: FontWeight.bold,
          color: hexToColor("#263300"),
          overflow: TextOverflow.visible,
          wordSpacing: 2,
          letterSpacing: 0.4),
    );
  }
}
