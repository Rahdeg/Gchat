// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:gchat/components/action_button.dart';
import 'package:gchat/screens/login_screen.dart';
import 'package:gchat/screens/signup_screen.dart';

class Homepage extends StatelessWidget {
  static const String id = "home_screen";

  const Homepage({super.key});

  Future<void> _navigateToSignUp(BuildContext context) async {
    Navigator.pushNamed(context, SignUpScreen.id);
  }

  Future<void> _navigateToLogin(BuildContext context) async {
    Navigator.pushNamed(context, LoginScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFF9EFD8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/home.png"),
                const Text(
                  "Hey!",
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
                const Text(
                  "Welcome to GChat",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                )
              ],
            ),
          ),
          ActionButton(
            label: "Get Started",
            textOne: "Already have an account?",
            textTwo: "Login",
            signUp: () => _navigateToSignUp(context),
            login: () => _navigateToLogin(context),
          ),
        ],
      ),
    );
  }
}
