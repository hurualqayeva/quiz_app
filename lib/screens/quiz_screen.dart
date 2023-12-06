import 'dart:async';	
import 'package:flutter/material.dart';	
import 'dart:convert';	
import 'package:http/http.dart' as http;	
import 'quiz_questions_page.dart';	
import 'package:html_unescape/html_unescape.dart';	

class QuizScreen extends StatefulWidget {	
  @override	
  _QuizScreenState createState() => _QuizScreenState();	
}	

class _QuizScreenState extends State<QuizScreen> {	
  late List<Map<String, dynamic>> categories;	
  late String selectedCategory;	
  late String selectedDifficulty;	
  late String selectedType;	
  late TextEditingController numberOfQuestionsController;	
  late Key numberOfQuestionsKey;	

  @override	
  void initState() {	
    super.initState();	
    categories = [];	
    selectedCategory = '';	
    selectedDifficulty = 'any';	
    selectedType = 'any';	
    numberOfQuestionsController = TextEditingController();	
    numberOfQuestionsKey = UniqueKey();	
    resetInputFields();	

    fetchCategories();	
  }	

  void resetInputFields() {	
    selectedCategory = '';	
    selectedDifficulty = 'any';	
    selectedType = 'any';	
    numberOfQuestionsController.text = '';	
    numberOfQuestionsKey = UniqueKey();	
  }	

  Future<void> fetchCategories() async {	
    final response = await http.get(Uri.parse('https://opentdb.com/api_category.php'));	
    final data = json.decode(response.body);	

    setState(() {	
      categories = List<Map<String, dynamic>>.from(data['trivia_categories']);	
    });	
  }	

  @override	
  Widget build(BuildContext context) {	
    return Scaffold(	
      body: Container(	
        decoration: const BoxDecoration(	
          gradient: LinearGradient(	
            begin: Alignment.topLeft,	
            end: Alignment.bottomRight,	
            colors: [const Color.fromARGB(255, 37, 55, 83), const Color.fromARGB(255, 28, 55, 78)],	
          ),	
        ),	
        child: Center(	
          child: Column(	
            mainAxisAlignment: MainAxisAlignment.start,	
            children: [	
              SizedBox(height: 40),	
             const Padding(	
                padding:  EdgeInsets.symmetric(horizontal: 16),	
                child: Text(	
                  "Let's Play",	
                  style: TextStyle(	
                    color: Colors.white,	
                    fontSize: 24,	
                    fontWeight: FontWeight.bold,	
                  ),	
                ),	
              ),	
              SizedBox(height: 20),	
              _buildDropdown(	
                value: selectedCategory,	
                items: [	
                  DropdownMenuItem<String>(	
                    value: '',	
                    child: Text('Select a Category', style: TextStyle(color: Colors.white)),	
                  ),	
                  ...categories.map<DropdownMenuItem<String>>((Map<String, dynamic> category) {	
                    return DropdownMenuItem<String>(	
                      value: category['id'].toString(),	
                      child: Text(	
                        HtmlUnescape().convert(category['name']),	
                        style: TextStyle(color: Colors.white, fontSize: 16.0),	
                      ),	
                    );	
                  }).toList(),	
                ],	
                onChanged: (String? newValue) {	
                  setState(() {	
                    selectedCategory = newValue!;	
                  });	
                },	
              ),	
              SizedBox(height: 16),	
              _buildDropdown(	
                value: selectedDifficulty,	
                items: [	
                  DropdownMenuItem<String>(	
                    value: 'any',	
                    child: Text('Select Difficulty', style: TextStyle(color: Colors.white)),	
                  ),	
                  DropdownMenuItem<String>(	
                    value: 'easy',	
                    child: Text('Easy', style: TextStyle(color: Colors.white, fontSize: 16.0)),	
                  ),	
                  DropdownMenuItem<String>(	
                    value: 'medium',	
                    child: Text('Medium', style: TextStyle(color: Colors.white, fontSize: 16.0)),	
                  ),	
                  DropdownMenuItem<String>(	
                    value: 'hard',	
                    child: Text('Hard', style: TextStyle(color: Colors.white, fontSize: 16.0)),	
                  ),	
                ],	
                onChanged: (String? newValue) {	
                  if (newValue != null) {	
                    setState(() {	
                      selectedDifficulty = newValue;	
                    });	
                  }	
                },	
              ),	
              SizedBox(height: 16),	
              _buildTypeDropdown(),	
              SizedBox(height: 16),	
              _buildNumberInput(),	
              SizedBox(height: 16),	
              ElevatedButton(	
                onPressed: () async {	
                  if (numberOfQuestionsController.text.isEmpty ||	
                      int.parse(numberOfQuestionsController.text) <= 0) {	
                    showDialog(	
                      context: context,	
                      builder: (BuildContext context) {	
                        return AlertDialog(	
                          title: Text('Validation Error'),	
                          content: Text('Please fill in all fields and ensure the number of questions is greater than 0.'),	
                          actions: <Widget>[	
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
                  } else {	
                    await Navigator.push(	
                      context,	
                      MaterialPageRoute(	
                        builder: (context) => QuizQuestionsPage(	
                          selectedCategory: selectedCategory,	
                          selectedDifficulty: selectedDifficulty,	
                          selectedType: selectedType,	
                          numberOfQuestions: int.parse(numberOfQuestionsController.text),	
                        ),	
                      ),	
                    );	

                    setState(resetInputFields);	
                  }	
                },	
                style: ElevatedButton.styleFrom(	
                  primary: Colors.blue,	
                  shape: RoundedRectangleBorder(	
                    borderRadius: BorderRadius.circular(8.0),	
                  ),	
                ),	
                child: Text('Start Quiz', style: TextStyle(fontSize: 18, color: Colors.white)),	
              ),	
            ],	
          ),	
        ),	
      ),	
    );	
  }	

  Widget _buildDropdown({	
    required String? value,	
    required List<DropdownMenuItem<String>> items,	
    required ValueChanged<String?> onChanged,	
  }) {	
    return Container(	
      padding: EdgeInsets.symmetric(horizontal: 16),	
      margin: EdgeInsets.symmetric(horizontal: 16),	
      decoration: BoxDecoration(	
        borderRadius: BorderRadius.circular(8.0),	
        gradient: LinearGradient(	
          begin: Alignment.topLeft,	
          end: Alignment.bottomRight,	
          colors: [const Color.fromARGB(255, 37, 55, 83), const Color.fromARGB(255, 28, 55, 78)],	
        ),	
        border: Border.all(color: Colors.blue),	
      ),	
      child: Theme(	
        data: ThemeData(	
          canvasColor: const Color.fromARGB(255, 28, 55, 78),	
        ),	
        child: DropdownButton<String>(	
          value: value,	
          onChanged: (newValue) {	
            onChanged(newValue);	
          },	
          items: items,	
          style: TextStyle(color: Colors.white, fontSize: 16.0),	
          underline: SizedBox(),	
          isExpanded: true,	
        ),	
      ),	
    );	
  }	

  Widget _buildNumberInput() {	
    return Container(	
      margin: EdgeInsets.symmetric(horizontal: 16),	
      decoration: BoxDecoration(	
        borderRadius: BorderRadius.circular(8.0),	
        gradient: LinearGradient(	
          begin: Alignment.topLeft,	
          end: Alignment.bottomRight,	
          colors: [const Color.fromARGB(255, 37, 55, 83), const Color.fromARGB(255, 28, 55, 78)],	
        ),	
        border: Border.all(color: Colors.blue),	
      ),	
      child: TextField(	
        key: numberOfQuestionsKey,	
        controller: numberOfQuestionsController,	
        keyboardType: TextInputType.number,	
        onChanged: (value) {	
          setState(() {	
            if (int.tryParse(value) != null && int.parse(value) > 0) {	
              numberOfQuestionsController.text = value;	
            }	
          });	
        },	
        style: TextStyle(color: Colors.white),	
        decoration: InputDecoration(	
          labelText: 'Number of Questions',	
          labelStyle: TextStyle(color: Colors.white),	
          fillColor: Colors.transparent,	
          filled: true,	
          enabledBorder: UnderlineInputBorder(	
            borderSide: BorderSide(color: Colors.blue),	
            borderRadius: BorderRadius.circular(8.0),	
          ),	
          focusedBorder: UnderlineInputBorder(	
            borderSide: BorderSide(color: Colors.blue),	
            borderRadius: BorderRadius.circular(8.0),	
          ),	
        ),	
      ),	
    );	
  }	

  Widget _buildTypeDropdown() {	
    return Container(	
      padding: EdgeInsets.symmetric(horizontal: 16),	
      margin: EdgeInsets.symmetric(horizontal: 16),	
      decoration: BoxDecoration(	
        borderRadius: BorderRadius.circular(8.0),	
        gradient: LinearGradient(	
          begin: Alignment.topLeft,	
          end: Alignment.bottomRight,	
          colors: [const Color.fromARGB(255, 37, 55, 83), const Color.fromARGB(255, 28, 55, 78)],	
        ),	
        border: Border.all(color: Colors.blue),	
      ),	
      child: Theme(	
        data: ThemeData(	
          canvasColor: const Color.fromARGB(255, 28, 55, 78),	
        ),	
        child: DropdownButton<String>(	
          value: selectedType,	
          onChanged: (String? newValue) {	
            setState(() {	
              selectedType = newValue!;	
            });	
          },	
          items: [	
            DropdownMenuItem<String>(	
              value: 'any',	
              child: Text('Select Type', style: TextStyle(color: Colors.white)),	
            ),	
            DropdownMenuItem<String>(	
              value: 'multiple',	
              child: Text('Multiple Choice', style: TextStyle(color: Colors.white, fontSize: 16.0)),	
            ),	
            DropdownMenuItem<String>(	
              value: 'boolean',	
              child: Text('True/False', style: TextStyle(color: Colors.white, fontSize: 16.0)),	
            ),	
          ],	
          style: TextStyle(color: Colors.white, fontSize: 16.0),	
          underline: SizedBox(),	
          isExpanded: true,	
        ),	
      ),	
    );	
  }	
}	