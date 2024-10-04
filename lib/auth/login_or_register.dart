import 'package:flutter/material.dart';
import 'package:homehunt/pages/loginpage.dart';
import 'package:homehunt/pages/registerpage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Initially, show login page
  bool showLoginPage = true;

  // Toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages); // Ensure LoginPage is defined and imported correctly
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
