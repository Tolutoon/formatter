String formatDecimal(String input) {
  // Parse the trimmed input and reject invalid or infinite values.
  final value = num.tryParse(input.trim());

  if (value == null || !value.isFinite) {
    throw const FormatException('Please enter a valid number.');
  }

  // Convert the number to text before removing extra decimal zeros.
  String result = value.toString();

  // Only trim zeros when the number has a decimal part.
  if (result.contains('.')) {
    while (result.endsWith('0')) {
      result = result.substring(0, result.length - 1);
    }

    // Remove the decimal point too if it no longer has digits after it.
    if (result.endsWith('.')) {
      result = result.substring(0, result.length - 1);
    }
  }

  return result;
}

String formatTime(String input) {
  // Trim surrounding whitespace and check for the HH:mm shape.
  final trimmedInput = input.trim();
  if (trimmedInput.length != 5 || trimmedInput[2] != ':') {
    throw const FormatException('Enter time in HH:mm format.');
  }

  // Read the two-digit hour and minute sections.
  final hourText = trimmedInput.substring(0, 2);
  final minuteText = trimmedInput.substring(3, 5);

  // Make sure both sections contain digits before parsing them.
  if (!_isTwoDigitNumber(hourText) || !_isTwoDigitNumber(minuteText)) {
    throw const FormatException('Enter time in HH:mm format.');
  }

  final hour = int.parse(hourText);
  final minute = int.parse(minuteText);

  // Validate hours and minutes.
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    throw const FormatException('Invalid time entered.');
  }

  // Determine AM or PM.
  final period = hour >= 12 ? 'PM' : 'AM';

  // Convert 24-hour time to 12-hour time.
  final formattedHour = hour % 12 == 0 ? 12 : hour % 12;

  // Ensure the hour and minute have leading zeros.
  final hourString = formattedHour.toString().padLeft(2, '0');
  final minuteString = minute.toString().padLeft(2, '0');

  return '$hourString:$minuteString $period';
}

// Check for exactly two ASCII digits without using a regular expression.
bool _isTwoDigitNumber(String value) {
  return value.length == 2 &&
      value.codeUnits.every((digit) => digit >= 48 && digit <= 57);
}
