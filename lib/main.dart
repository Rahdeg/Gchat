import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gchat/provider/provider.dart';
import 'package:gchat/screens/chat.dart';
import 'package:gchat/screens/dashboard.dart';
import 'package:gchat/screens/home.dart';
import 'package:gchat/screens/login_screen.dart';
import 'package:gchat/screens/profile.dart';
import 'package:gchat/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCoVLQccu1ZJx0CPEJWUmvxMMIUBBGijyY",
      authDomain: "travelad-364716.firebaseapp.com",
      projectId: "travelad-364716",
      storageBucket: "travelad-364716.appspot.com",
      messagingSenderId: "357995453311",
      appId: "1:357995453311:web:84a08ea7de9ca43b65184a",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ChangeNotifierProvider(
        create: (context) => CustomAuthProvider(),
        child: MaterialApp(
          builder: FToastBuilder(),
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
          initialRoute: Homepage.id,
          routes: {
            Homepage.id: (context) => Consumer<CustomAuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.user == null) {
                      return const Homepage();
                    } else {
                      return const DashBoard();
                    }
                  },
                ),
            LoginScreen.id: (context) => const LoginScreen(),
            SignUpScreen.id: (context) => const SignUpScreen(),
            Chat.id: (context) => const Chat(
                  userId: "",
                ),
            ProfileScreen.id: (context) => const ProfileScreen(),
            DashBoard.id: (context) => Consumer<CustomAuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.user == null) {
                      return const Homepage();
                    } else {
                      return const DashBoard();
                    }
                  },
                )
          },
        ),
      ),
    );
  }
}
