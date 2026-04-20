import 'package:flutter/material.dart';

import '../../reusableWidgets/Responsive.dart';
import 'alertDialog/alertDialog.dart';

Widget showQuizData(context, snapshot, index) {
  // Get quiz duration, handle old quizzes without this field
  String quizDuration = "10";
  try {
    var duration = snapshot.data.docs[index]['Quiz Duration'];
    if (duration != null) {
      quizDuration = duration.toString();
    }
  } catch (_) {}

  return InkWell(
    child: Card(
      margin: const EdgeInsets.all(10),
      elevation: 20,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                child: Text(snapshot.data.docs[index]['Quiz Title'].toString(),
                    style: textStyle("title", context),
                    textAlign: TextAlign.center)),
            Container(
                padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                child: Text(
                  snapshot.data.docs[index]['Quiz Description'].toString(),
                  style: textStyle("desc", context),
                  textAlign: TextAlign.center,
                )),
            Container(
                padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                child: Text(
                  "⏱ $quizDuration min",
                  style: TextStyle(
                    fontSize: setSize(context, 15),
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade800,
                  ),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    ),
    onTap: () {
      alertDialogMyQuiz(context, snapshot, index);
    },
  );
}

TextStyle textStyle(value, context) {
  return TextStyle(
      fontSize:
          (value == "title") ? setSize(context, 24) : setSize(context, 16),
      color: (value == "title") ? Colors.blue.shade700 : Colors.black,
      fontWeight: (value == "title") ? FontWeight.w800 : FontWeight.w600,
      overflow: TextOverflow.visible);
}
