
import 'package:flutter/material.dart';
import 'screens/formatter_screen.dart';

void main() {
  runApp(const UtilityFormatterApp());
}

class UtilityFormatterApp extends StatelessWidget {
  const UtilityFormatterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Utility Formatter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const FormatterScreen(),
    );
  }
}
