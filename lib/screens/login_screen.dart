import 'package:flutter/material.dart';
import 'package:gchat/components/action_button.dart';
import 'package:gchat/screens/dashboard.dart';
import 'package:gchat/screens/signup_screen.dart';
import 'package:gchat/screens/responsive.dart';
import 'package:provider/provider.dart';
import 'package:gchat/provider/provider.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    try {
      final authProvider =
          Provider.of<CustomAuthProvider>(context, listen: false);
      await authProvider.signIn(
        _emailController.text,
        _passwordController.text,
      );
      toastification.show(
        type: ToastificationType.success,
        title: const Text('Login succesful'),
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, DashBoard.id);
    } catch (e) {
      toastification.show(
        type: ToastificationType.error,
        title: const Text('Login failed'),
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> navigateToSignUp() async {
    Navigator.pushNamed(context, SignUpScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: Responsive.isDesktop(context)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: Responsive.isDesktop(context)
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  // ignore: unrelated_type_equality_checks
                  if (Responsive.isMobile == true)
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.arrow_back)),
                  const Text(
                    "Login",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "login with your existing account",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal:
                            Responsive.isDesktop(context) ? 500.0 : 0.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal:
                            Responsive.isDesktop(context) ? 500.0 : 0.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              ActionButton(
                label: "Login",
                textOne: "Don't have an account?",
                textTwo: "Signup",
                signUp: login,
                login: navigateToSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
