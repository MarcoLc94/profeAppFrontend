import 'package:flutter/material.dart';
import 'package:profeapp/screens/home_screen.dart';
import 'package:profeapp/screens/login_screen.dart';
import 'package:profeapp/states/auth_notifier.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);

    if (authNotifier.isAuthenticated) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
