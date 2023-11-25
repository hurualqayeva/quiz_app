import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:quiz_app/models/model.dart';
import 'package:quiz_app/screens/question_detail.dart';

class QuizResultPage extends StatelessWidget {
  final List<QuizQuestion> quizQuestions;
  final Map<int, String?> selectedAnswers;

  QuizResultPage({
    required this.quizQuestions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 37, 55, 83),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 37, 55, 83),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(quizQuestions.length, (index) {
                bool isCorrect = selectedAnswers.containsKey(index) &&
                    selectedAnswers[index] == quizQuestions[index].correctAnswer;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionDetailPage(
                          question: quizQuestions[index],
                          userAnswer: selectedAnswers[index],
                          isCorrect: isCorrect,
                          questionNumber: index + 1,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 16), 
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isCorrect ? Colors.green : Colors.red,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Html(
                          data: quizQuestions[index].question,
                          style: {
                            "html": Style(
                              color: Colors.white,
                              fontSize: FontSize(18),
                            ),
                          },
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0), 
                          child: Text(
                            isCorrect
                                ? ' Your answer: ${selectedAnswers[index]} (Correct)'
                                : ' Your answer: ${selectedAnswers[index]} (Incorrect)',
                            style: TextStyle(
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                        if (!isCorrect)
                          Html(
                            data: 'Correct answer: ${quizQuestions[index].correctAnswer}',
                            style: {
                              "html": Style(
                                color: Colors.green,
                              ),
                            },
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
