import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:quiz_app/models/model.dart';

class QuestionDetailPage extends StatelessWidget {
  final QuizQuestion question;
  final String? userAnswer;
  final bool isCorrect;
  final int questionNumber;

  QuestionDetailPage({
    required this.question,
    required this.userAnswer,
    required this.isCorrect,
    required this.questionNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 37, 55, 83),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question Detail',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Question $questionNumber',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 8),
              Html(
                data: question.question,
                style: {
                  "html": Style(
                    color: Colors.white,
                    fontSize: FontSize(18),
                  ),
                },
              ),
              SizedBox(height: 16),
              Text(
                isCorrect
                    ? 'Your answer: $userAnswer (Correct)'
                    : 'Your answer: $userAnswer (Incorrect)',
                style: TextStyle(
                  color: isCorrect ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
              ),
              if (!isCorrect)
                Html(
                  data: 'Correct answer: ${question.correctAnswer}',
                  style: {
                    "html": Style(
                      color: Colors.green,
                      fontSize: FontSize(16),
                    ),
                  },
                ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text(
                  'Back to Results',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
