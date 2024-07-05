import 'package:flutter/material.dart';
import 'package:gchat/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:gchat/provider/provider.dart';
import 'package:gchat/helpers/local_storage_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String id = "ProfileScreen_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void getUsername() async {
    String? userName = await LocalStorageService.getUserName();
    if (userName != null) {
      setState(() {
        name = userName;
        isLoading = false; // Update loading state
      });
    } else {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      body: isLoading // Show a loading indicator while data is being fetched
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFFE8C483),
                          child: Text(
                            name.isNotEmpty
                                ? name.substring(0, 2).toUpperCase()
                                : '',
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontSize: 20)),
                            Text(user?.email ?? "",
                                style: const TextStyle(fontSize: 20))
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      await authProvider.signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, Homepage.id);
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }
}
