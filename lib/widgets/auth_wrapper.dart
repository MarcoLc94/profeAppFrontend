import 'package:flutter/material.dart';
import 'package:profeapp/screens/main_layout.dart';
import 'package:profeapp/screens/login_screen.dart';
import 'package:profeapp/services/auth_notifier.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);

    if (authNotifier.isAuthenticated) {
      return const MainLayout();
    } else {
      return const LoginScreen();
    }
  }
}
