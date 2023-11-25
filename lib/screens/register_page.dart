import 'package:flutter/material.dart';
import '../services/firebase_auth.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  Future<void> _registerWithEmailAndPassword() async {
  final form = _formKey.currentState;
  if (form != null && form.validate()) {
    try {
      await _authService.registerWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      _showRegistrationSuccessDialog();
    } catch (e) {
      print("Error: $e");
      _showRegistrationErrorDialog();
    }
  }
}

void _showRegistrationSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Registration Successful'),
        content: Text('You have successfully registered.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}


void _showRegistrationErrorDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Registration Failed'),
        content: Text('An error occurred during registration. Please try again.'),
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
      backgroundColor: Colors.transparent, // Set background color to transparent
      body: Container(
        decoration: const  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
               Color.fromARGB(255, 37, 55, 83),
               Color.fromARGB(255, 28, 55, 78),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   const Align(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 24), // Adjust font size
                    ),
                  ),
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
               const SizedBox(height: 16),
                ElevatedButton(
  onPressed: _registerWithEmailAndPassword,
  child: Text(
    'Register',
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
                    // Navigate to the login page
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
