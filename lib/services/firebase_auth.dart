// services/firebase_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> registerWithEmailAndPassword({required String email, required String password}) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> saveUserAnswers(String userEmail, Map<String, dynamic> userAnswers) async {
    try {
      await _firestore.collection('quiz_results').doc(userEmail).set(userAnswers);
    } catch (e) {
      print("Error saving user answers: $e");
    }
  }
}
