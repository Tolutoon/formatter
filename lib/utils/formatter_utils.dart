// WHAT: Pure formatting helpers — formatDecimal trims trailing zeros,
//   formatTime converts HH:mm to 12-hour AM/PM. No widgets, no Flutter.
// WHERE: Used by lib/screens/formatter_screen.dart —
//   handleDecimalFormatting() calls formatDecimal(),
//   handleTimeFormatting() calls formatTime().
//   Both catch FormatException and show error.message in the UI.
// WHY: Keeps parsing/validation in one testable place outside the UI,
//   so the screen only handles TextControllers + setState. Both helpers
//   throw FormatException on bad input instead of returning null, which
//   is why the screen uses try/catch. No regex by design — digit check
//   is done char-by-char in _isTwoDigitNumber.

String formatDecimal(String input) {
  // Remove spaces around the input, then try to read it as a number.
  // Returns null if the text is not a number at all.
  final value = num.tryParse(input.trim());

  // If parsing failed, or the number is infinity / NaN, reject it.
  if (value == null || !value.isFinite) {
    // Stop here and tell the caller the input was bad.
    throw const FormatException('Please enter a valid number.');
  }

  // Turn the number back into text, e.g. 5.500 -> "5.5", 10.0 -> "10.0".
  String result = value.toString();

  // Only do zero-trimming if there is a decimal point.
  if (result.contains('.')) {
    // While the last character is '0', chop off that last character.
    // e.g. "5.500" -> "5.50" -> "5.5"
    while (result.endsWith('0')) {
      // Keep everything except the last character.
      result = result.substring(0, result.length - 1);
    }

    // If we trimmed all decimals, a lonely dot is left, e.g. "10.".
    if (result.endsWith('.')) {
      // Chop off that dot too, so "10." becomes "10".
      result = result.substring(0, result.length - 1);
    }
  }

  // Give back the cleaned text.
  return result;
}

String formatTime(String input) {
  // Remove spaces around the input.
  final trimmedInput = input.trim();

  // A valid time is exactly 5 chars long, like "14:30".
  // The 3rd character (index 2) must be a colon.
  if (trimmedInput.length != 5 || trimmedInput[2] != ':') {
    // Wrong shape, stop here.
    throw const FormatException('Enter time in HH:mm format.');
  }

  // Grab the first 2 characters as the hour, e.g. "14".
  final hourText = trimmedInput.substring(0, 2);

  // Grab the last 2 characters as the minute, e.g. "30".
  final minuteText = trimmedInput.substring(3, 5);

  // Both parts must be digits. If either is not, stop here.
  if (!_isTwoDigitNumber(hourText) || !_isTwoDigitNumber(minuteText)) {
    throw const FormatException('Enter time in HH:mm format.');
  }

  // Convert the hour text into a real number, e.g. "14" -> 14.
  final hour = int.parse(hourText);

  // Convert the minute text into a real number, e.g. "30" -> 30.
  final minute = int.parse(minuteText);

  // Hour must be 0-23 and minute must be 0-59.
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    // Numbers are digits but not a real clock time.
    throw const FormatException('Invalid time entered.');
  }

  // If hour is 12 or more, it is afternoon/evening.
  final period = hour >= 12 ? 'PM' : 'AM';

  // Convert 24-hour to 12-hour.
  // hour % 12 turns 13->1, 14->2, 0->0, 12->0.
  // The == 0 check turns midnight (0) and noon (12) into 12.
  final formattedHour = hour % 12 == 0 ? 12 : hour % 12;

  // Turn hour back to text and add a leading zero if needed, e.g. 2 -> "02".
  final hourString = formattedHour.toString().padLeft(2, '0');

  // Same for minute, e.g. 5 -> "05".
  final minuteString = minute.toString().padLeft(2, '0');

  // Combine into final form, e.g. "02:30 PM".
  return '$hourString:$minuteString $period';
}

// Helper: checks that a string is exactly 2 digits, no regex needed.
bool _isTwoDigitNumber(String value) {
  // Must be exactly 2 characters long.
  if (value.length != 2) {
    return false;
  }

  // Look at each character one by one.
  for (int i = 0; i < value.length; i++) {
    // Read this character's code: '0' is 48, '9' is 57.
    // NOTE: Dart strings can't use < > directly, so we compare codes.
    // This is the "no regex" trick in code form: ch < '0' || ch > '9'.
    final code = value.codeUnitAt(i);

    // If it is smaller than '0' or bigger than '9', it is not a digit.
    if (code < 48 || code > 57) {
      return false;
    }
  }

  // Passed both checks, so it is two digits.
  return true;
}
