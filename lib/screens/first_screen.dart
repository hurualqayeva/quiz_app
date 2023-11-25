import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/screens/login_page.dart'; 
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3), 
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), 
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()), 
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 37, 55, 83),
                  const Color.fromARGB(255, 28, 55, 78),
                ],
              ),
            ),
            child: Center(
              child: Hero(
                tag: 'appLogo',
                child: Material(
                  type: MaterialType.transparency,
                  child: Image.network(
                    'https://play-lh.googleusercontent.com/WkK8-_NYDo0f15qfGsZnn4iZ9G7Q-MMloycE5mdnClbUNnkQ50hZrkWi5xxubg5_F8E',
                    width: 150, 
                    height: 150, 
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
