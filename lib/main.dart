import 'package:flutter/material.dart';
import 'package:profeapp/screens/splash_screen.dart';
import 'package:profeapp/states/theme/theme_notifier.dart';

import 'package:provider/provider.dart';

import 'package:profeapp/services/auth_notifier.dart';
import 'package:profeapp/services/group_notifier.dart';
import 'package:profeapp/services/student_notifier.dart';
import 'package:profeapp/services/attendance_notifier.dart';
import 'package:profeapp/services/task_notifier.dart';
import 'package:profeapp/services/subject_notifier.dart';
import 'package:profeapp/services/grade_notifier.dart';
import 'package:profeapp/services/behavior_notifier.dart';
import 'package:profeapp/services/report_notifier.dart';
import 'package:profeapp/services/notification_notifier.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
        ChangeNotifierProvider(create: (_) => GroupNotifier()),
        ChangeNotifierProvider(create: (_) => StudentNotifier()),
        ChangeNotifierProvider(create: (_) => AttendanceNotifier()),
        ChangeNotifierProvider(create: (_) => TaskNotifier()),
        ChangeNotifierProvider(create: (_) => SubjectNotifier()),
        ChangeNotifierProvider(create: (_) => GradeNotifier()),
        ChangeNotifierProvider(create: (_) => BehaviorNotifier()),
        ChangeNotifierProvider(create: (_) => ReportNotifier()),
        ChangeNotifierProvider(create: (_) => NotificationNotifier()),
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
      title: 'ProfeApp',
      theme: ThemeNotifier.lightTheme,
      darkTheme: ThemeNotifier.darkTheme,
      themeMode: themeNotifier.currentTheme,
      routes: {'/splash': (context) => SplashScreen()},
      initialRoute: '/splash',
    );
  }
}
