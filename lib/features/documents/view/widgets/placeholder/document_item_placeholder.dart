import 'dart:math';

mixin DocumentItemPlaceholder {
  static const _tags = ["    ", "            ", "      "];
  static const _titleLengths = <double>[double.infinity, 150.0, 200.0];
  static const _correspondentLengths = <double>[120.0, 80.0, 40.0];

  Random get random;

  RandomDocumentItemPlaceholderValues get nextValues {
    return RandomDocumentItemPlaceholderValues(
      tagCount: random.nextInt(_tags.length + 1),
      correspondentLength: _correspondentLengths[
          random.nextInt(_correspondentLengths.length - 1)],
      titleLength: _titleLengths[random.nextInt(_titleLengths.length - 1)],
    );
  }
}

class RandomDocumentItemPlaceholderValues {
  final int tagCount;
  final double correspondentLength;
  final double titleLength;

  RandomDocumentItemPlaceholderValues({
    required this.tagCount,
    required this.correspondentLength,
    required this.titleLength,
  });
}
