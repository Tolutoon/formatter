import 'package:flutter/material.dart';

// WHAT: Bold 18px section heading text.
// WHERE: Rendered at the top of DecimalFormatterWidget + TimeFormatterWidget in this file.
// WHY: Single style for both section titles so the heading look stays consistent.
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

// WHAT: Green rounded card showing a small grey title plus a large bold value.
// WHERE: Shown conditionally below the button in the decimal/time widgets when result != null.
// WHY: One shared success style so formatted decimal and time output look the same.
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

// WHAT: Small red message text with top padding for validation errors.
// WHERE: Shown conditionally below the button in the decimal/time widgets when error != null.
// WHY: One shared error style so FormatException messages render identically in both sections.
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

// WHAT: Decimal input section — number TextField + "Format Decimal" button + result/error below.
// WHERE: Placed first in FormatterScreen's Column; receives decimalController and handleDecimalFormatting.
// WHY: Groups decimal UI together so the screen owns state while this widget stays stateless display-only.
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

// WHAT: Time input section — datetime TextField + "Format Time" button + result/error below.
// WHERE: Placed second in FormatterScreen's Column; receives timeController and handleTimeFormatting.
// WHY: Mirrors the decimal section for time so each format flow stays independent and stateless.
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
