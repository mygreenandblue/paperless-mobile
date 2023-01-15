extension DateComparisons on DateTime {
  bool isEqualToIgnoringDate(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }
}
