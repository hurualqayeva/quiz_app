import 'package:flutter/material.dart';


class QuizProvider extends ChangeNotifier {
  String selectedCategory = '';
  String selectedDifficulty = 'any';
  String selectedType = 'any';
  TextEditingController numberOfQuestionsController = TextEditingController();
  Key numberOfQuestionsKey = UniqueKey();

  void resetInputFields() {
    selectedCategory = '';
    selectedDifficulty = 'any';
    selectedType = 'any';
    numberOfQuestionsController.text = '';
    numberOfQuestionsKey = UniqueKey();
    notifyListeners();
  }
}
