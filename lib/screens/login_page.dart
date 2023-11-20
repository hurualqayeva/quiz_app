// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:quiz_app/screens/register_page.dart';
import '../services/firebase_auth.dart';
import '../widgets/custom_text_field.dart';
import 'quiz_screen.dart'; 

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
   
    return null;
  }

  Future<void> _signInWithEmailAndPassword() async {
  final form = _formKey.currentState;
  if (form != null && form.validate()) {
    try {
      await _authService.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizScreen()),
      );
    } catch (e) {
      print("Error: $e");
 
      _showLoginErrorDialog();
    }
  }
}

void _showLoginErrorDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Login Failed'),
        content: Text('Incorrect email or password. Please try again.'),
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
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color.fromARGB(255, 37, 55, 83), const Color.fromARGB(255, 28, 55, 78)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 24), // Adjust font size
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    validator: _emailValidator,
                    isSmall: true, 
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                    validator: _passwordValidator,
                    isSmall: true, 
                  ),
                  SizedBox(height: 16),
                ElevatedButton(
  onPressed: _signInWithEmailAndPassword,
  child: Text(
    'Login',
    style: TextStyle(fontSize: 18, color: Colors.white),
  ),
  style: ElevatedButton.styleFrom(
    primary: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
),

                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
            
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      'Create an account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
