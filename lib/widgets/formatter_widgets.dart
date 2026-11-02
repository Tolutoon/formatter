// WHAT: Stateless building blocks — section title, result card,
//   error message, plus DecimalFormatterWidget + TimeFormatterWidget sections.
// WHERE: Used by lib/screens/formatter_screen.dart, which passes in
//   controllers, onFormat callbacks, result + error strings.
// WHY: Keeps reusable UI pieces in one place so the screen's build()
//   stays short; result/error show conditionally (if != null), so the
//   screen just passes state down and these widgets only display it.

import 'package:flutter/material.dart';

class FormatterSectionTitle extends StatelessWidget {
  const FormatterSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class FormatterResultCard extends StatelessWidget {
  const FormatterResultCard({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class FormatterErrorMessage extends StatelessWidget {
  const FormatterErrorMessage(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 13),
      ),
    );
  }
}

class DecimalFormatterWidget extends StatelessWidget {
  const DecimalFormatterWidget({
    required this.controller,
    required this.onFormat,
    this.result,
    this.error,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onFormat;
  final String? result;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormatterSectionTitle('Decimal Formatter'),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          decoration: const InputDecoration(
            hintText: 'Enter decimal e.g. 12.5000',
            prefixIcon: Icon(Icons.numbers),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onFormat,
            child: const Text('Format Decimal'),
          ),
        ),
        if (result != null)
          FormatterResultCard(title: 'Formatted Decimal', value: result!),
        if (error != null) FormatterErrorMessage(error!),
      ],
    );
  }
}

class TimeFormatterWidget extends StatelessWidget {
  const TimeFormatterWidget({
    required this.controller,
    required this.onFormat,
    this.result,
    this.error,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onFormat;
  final String? result;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormatterSectionTitle('Time Formatter'),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(
            hintText: 'Enter time e.g. 14:30',
            prefixIcon: Icon(Icons.access_time),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onFormat,
            child: const Text('Format Time'),
          ),
        ),
        if (result != null)
          FormatterResultCard(title: 'Formatted Time', value: result!),
        if (error != null) FormatterErrorMessage(error!),
      ],
    );
  }
}
