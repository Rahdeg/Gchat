import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  User? get user => _user;

  CustomAuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      // Get user details from Firestore
      Map<String, dynamic>? userInfo = await getUserInfo(user.uid);

      if (userInfo != null) {
        // Save user details to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('uid', user.uid);
        prefs.setString('userName', userInfo['userName']);
        prefs.setString('email', userInfo['email']);
      }
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'userName': name,
        'email': user.email,
        'created_at': DateTime.now(),
      });
      // Save user details to local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userName', name);
      prefs.setString('email', email);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // Clear user details from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<Map<String, dynamic>?> getUserInfo(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  Future<void> saveConversation(String conversationId, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> messages = prefs.getStringList(conversationId) ?? [];
    messages.add(message);
    await prefs.setStringList(conversationId, messages);
  }

  Future<List<String>?> getConversation(String conversationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(conversationId);
  }
}
