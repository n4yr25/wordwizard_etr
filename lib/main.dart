import 'package:flutter/material.dart';
import 'package:wordwizard_mad_etr/screens/homescreen.dart';

void main() {
  runApp(const WordWizardApp());
}

class WordWizardApp extends StatelessWidget {
  const WordWizardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
