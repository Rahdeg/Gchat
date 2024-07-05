import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const Responsive({super.key, required this.mobile, required this.desktop});

//For mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 650;
  }

//for desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      //width grater than 900 is deskstop
      if (constraints.maxWidth >= 900) {
        return desktop;
      }
      //otherwise mobile
      else {
        return mobile;
      }
    });
  }
}
