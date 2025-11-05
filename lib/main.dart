import 'package:flutter/material.dart';
import 'screens/landing/landing_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SmartKareApp());
}

class SmartKareApp extends StatelessWidget {
  const SmartKareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartKare Healthcare',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
    );
  }
}
