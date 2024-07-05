import 'package:flutter/material.dart';
import 'package:gchat/screens/chat_list.dart';
import 'package:gchat/screens/profile.dart';

class DashBoard extends StatefulWidget {
  static const String id = "dashboard_screen";

  const DashBoard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Chats',
    'Profile',
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.all(25.0),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Text(
            _titles[_currentIndex],
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        fixedColor: const Color(0xFFE8C483),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
