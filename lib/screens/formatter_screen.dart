// WHAT: Stateful screen holding decimal + time inputs, results and errors;
//   calls formatDecimal()/formatTime() when the buttons are pressed.
// WHERE: Set as home in lib/main.dart; imports the helpers from
//   lib/utils/formatter_utils.dart and the section widgets from
//   lib/widgets/formatter_widgets.dart.
// WHY: Owns the TextEditingControllers + try/catch on FormatException,
//   so the utils stay pure/testable and the widgets stay stateless.
//   dispose() frees the controllers to avoid leaks.

import 'package:flutter/material.dart';
import 'package:formatter/utils/formatter_utils.dart';
import 'package:formatter/widgets/formatter_widgets.dart';

class FormatterScreen extends StatefulWidget {
  const FormatterScreen({super.key});

  @override
  State<FormatterScreen> createState() => _FormatterScreenState();
}

class _FormatterScreenState extends State<FormatterScreen> {
  final TextEditingController decimalController = TextEditingController();

  final TextEditingController timeController = TextEditingController();

  String? decimalResult;
  String? timeResult;

  String? decimalError;
  String? timeError;

  void handleDecimalFormatting() {
    try {
      final result = formatDecimal(decimalController.text);

      setState(() {
        decimalResult = result;
        decimalError = null;
      });
    } on FormatException catch (error) {
      setState(() {
        decimalResult = null;
        decimalError = error.message;
      });
    }
  }

  void handleTimeFormatting() {
    try {
      final result = formatTime(timeController.text);

      setState(() {
        timeResult = result;
        timeError = null;
      });
    } on FormatException catch (error) {
      setState(() {
        timeResult = null;
        timeError = error.message;
      });
    }
  }

  @override
  void dispose() {
    decimalController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utility Formatter'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Format your values',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Convert decimal numbers and time formats easily.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),
            DecimalFormatterWidget(
              controller: decimalController,
              onFormat: handleDecimalFormatting,
              result: decimalResult,
              error: decimalError,
            ),
            const SizedBox(height: 35),
            TimeFormatterWidget(
              controller: timeController,
              onFormat: handleTimeFormatting,
              result: timeResult,
              error: timeError,
            ),
          ],
        ),
      ),
    );
  }
}
