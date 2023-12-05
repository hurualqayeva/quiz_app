import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizState extends ChangeNotifier {
  late List<QuizQuestion> quizQuestions;
  late int currentQuestionIndex;
  late Map<int, String?> selectedAnswers;
  late Timer timer;
  late int timerSeconds;
  late double timerProgress;

  QuizState()
      : quizQuestions = [],
        currentQuestionIndex = 0,
        selectedAnswers = {},
        timerSeconds = 60,
        timerProgress = 1.0;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (timerSeconds > 0) {
        timerSeconds--;
        timerProgress = timerSeconds / 60.0;
      } else {
        goToNextQuestion();
      }
      notifyListeners();
    });
  }

  Future<void> fetchQuizQuestions(int numberOfQuestions, String selectedCategory, String selectedDifficulty, String selectedType) async {
    final categoryParam = selectedCategory.isNotEmpty ? '&category=$selectedCategory' : '';
    final difficultyParam = selectedDifficulty == 'any' ? '' : '&difficulty=$selectedDifficulty';
    final typeParam = selectedType == 'any' ? '' : '&type=$selectedType';

    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=$numberOfQuestions$categoryParam$difficultyParam$typeParam'));
    final data = json.decode(response.body);

    quizQuestions = (data['results'] as List)
        .map((questionData) => QuizQuestion(
      question: questionData['question'],
      options: List<String>.from(questionData['incorrect_answers']) +
          [questionData['correct_answer']],
      correctAnswer: questionData['correct_answer'],
    ))
        .toList();
    notifyListeners();
  }

  void goToNextQuestion(int numberOfQuestions) {
    if (currentQuestionIndex < numberOfQuestions - 1) {
      currentQuestionIndex++;
      timerSeconds = 60;
      timerProgress = 1.0;
    } else {
      timer.cancel();
      showQuizResult(numberOfQuestions);
    }
    notifyListeners();
  }

  void showQuizResult(BuildContext context, int numberOfQuestions) {
    int correctCount = calculateCorrectAnswers(numberOfQuestions);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Result'),
          content: Text('You answered $correctCount out of $numberOfQuestions questions correctly.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizResultPage(
                      quizQuestions: quizQuestions,
                      selectedAnswers: selectedAnswers,
                    ),
                  ),
                );
              },
              child: Text('See Correct/Incorrect Answers'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  int calculateCorrectAnswers(int numberOfQuestions) {
    int correctCount = 0;
    for (int i = 0; i < numberOfQuestions; i++) {
      if (selectedAnswers.containsKey(i) && selectedAnswers[i] == quizQuestions[i].correctAnswer) {
        correctCount++;
      }
    }
    return correctCount;
  }
}

class QuizQuestionsPage extends StatefulWidget {
  final String selectedCategory;
  final String selectedDifficulty;
  final String selectedType;
  final int numberOfQuestions;

  QuizQuestionsPage({
    required this.selectedCategory,
    required this.selectedDifficulty,
    required this.selectedType,
    required this.numberOfQuestions,
  });

  @override
  _QuizQuestionsPageState createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends State<QuizQuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizState(),
      builder: (context, child) {
        final quizState = Provider.of<QuizState>(context);

        if (quizState.quizQuestions.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Quiz Questions'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

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
                    'Question ${quizState.currentQuestionIndex + 1} of ${widget.numberOfQuestions}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: quizState.timerProgress,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Time Remaining: ${quizState.timerSeconds}s',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Html(
                    data: quizState.quizQuestions[quizState.currentQuestionIndex].question,
                    style: {
                      "html": Style(
                        color: Colors.white,
                        fontSize: FontSize(18),
                      ),
                    },
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: quizState.quizQuestions[quizState.currentQuestionIndex].options.map((option) {
                      bool isCorrect = option == quizState.quizQuestions[quizState.currentQuestionIndex].correctAnswer;
                      bool isSelected = quizState.selectedAnswers[quizState.currentQuestionIndex] == option;

                      return RadioListTile<String>(
                        title: Html(
                          data: option,
                          style: {
                            "html": Style(
                              color: Colors.white,
                            ),
                          },
                        ),
                        activeColor: Colors.blue,
                        value: option,
                        groupValue: quizState.selectedAnswers[quizState.currentQuestionIndex],
                        onChanged: (String? value) {
                          quizState.selectedAnswers[quizState.currentQuestionIndex] = value;
                          quizState.notifyListeners();
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text(
                      'Next Question',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      quizState.goToNextQuestion(widget.numberOfQuestions);
