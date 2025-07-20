import 'package:flutter/material.dart';
import 'package:syncronize/core/theme/app_theme.dart';
import 'package:syncronize/src/presentation/page/auth/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Syncronize',
      theme: AppTheme.lightTheme,
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginPage(),
      },
    );
  }
}

