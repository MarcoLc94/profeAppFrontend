import 'package:flutter/material.dart';
import 'package:profeapp/screens/splash_screen.dart';
import 'package:profeapp/states/theme/theme_notifier.dart';

import 'package:provider/provider.dart';

import 'package:profeapp/states/auth_notifier.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.currentTheme,
      routes: {'/splash': (context) => SplashScreen()},
      initialRoute: '/splash',
    );
  }
}
