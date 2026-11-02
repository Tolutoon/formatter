import 'package:flutter/material.dart';
import 'package:formatter/utils/formatter_utils.dart';
import 'package:formatter/widgets/formatter_widgets.dart';

// WHAT: Root stateful screen hosting the decimal + time formatter sections.
// WHERE: Set as home in lib/main.dart's MaterialApp.
// WHY: Owns input state so lib/main.dart stays setup-only and widgets stay stateless.
class FormatterScreen extends StatefulWidget {
  const FormatterScreen({super.key});

  @override
  State<FormatterScreen> createState() => _FormatterScreenState();
}

// WHAT: State holding both controllers plus result/error strings for each section.
// WHERE: Lives only inside this screen; passed down to the widgets in build() below.
// WHY: Keeps TextEditingControllers + setState in one place so utils stay pure and widgets stay display-only.
class _FormatterScreenState extends State<FormatterScreen> {
  final TextEditingController decimalController = TextEditingController();

  final TextEditingController timeController = TextEditingController();

  String? decimalResult;
  String? timeResult;

  String? decimalError;
  String? timeError;

  // WHAT: Runs formatDecimal() on the decimal input, sets result or error message.
  // WHERE: Called by DecimalFormatterWidget's button via the onFormat callback.
  // WHY: try/catch on FormatException here so the widget just displays whatever state comes back.
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

  // WHAT: Runs formatTime() on the time input, sets result or error message.
  // WHERE: Called by TimeFormatterWidget's button via the onFormat callback.
  // WHY: Same try/catch pattern as decimal so each flow succeeds or fails independently.
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

  // WHAT: Disposes both TextEditingControllers when the screen is removed.
  // WHERE: Flutter calls this automatically on state teardown.
  // WHY: Frees native text-input resources to avoid memory leaks.
  @override
  void dispose() {
    decimalController.dispose();
    timeController.dispose();
    super.dispose();
  }

  // WHAT: Scaffold with header text plus the decimal section stacked above the time section.
  // WHERE: Renders DecimalFormatterWidget first, TimeFormatterWidget second, each wired to its controller + handler.
  // WHY: Single scrollable Column layout so both tools share one page while keeping their state separate.
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
            // WHAT: Decimal input section bound to decimalController/result/error.
            // WHERE: First section in this Column.
            // WHY: Wires handleDecimalFormatting so the button press updates only decimal state.
            DecimalFormatterWidget(
              controller: decimalController,
              onFormat: handleDecimalFormatting,
              result: decimalResult,
              error: decimalError,
            ),
            const SizedBox(height: 35),
            // WHAT: Time input section bound to timeController/result/error.
            // WHERE: Second section in this Column, below the decimal one.
            // WHY: Wires handleTimeFormatting so the button press updates only time state.
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
