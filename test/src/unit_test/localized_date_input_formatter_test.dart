import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/helpers/localized_date_input_formatter.dart';

void main() {
  group('TestLocalizedDateInputFormatter', () {
    // MM/dd/yyyy
    final LocalizedDateInputFormatter inputFormatter =
        LocalizedDateInputFormatter('en_US');
    final defaultOldValue = TextEditingValue();
    test('if first digits are left untouched.', () {
      final newValue = TextEditingValue(
        text: '1',
        selection: TextSelection.fromPosition(
          const TextPosition(offset: 1),
        ),
      );
      final transformed =
          inputFormatter.formatEditUpdate(defaultOldValue, newValue);
      expect(transformed.text, '1');
      // Test case 1 code
    });

    test('if first separator is correctly placed', () {
      final newValue = TextEditingValue(
        text: '12',
        selection: TextSelection.fromPosition(
          const TextPosition(offset: 3),
        ),
      );
      final transformed =
          inputFormatter.formatEditUpdate(defaultOldValue, newValue);
      expect(transformed.text, '12/');
    });

    test('if second separator is correctly placed', () {
      final newValue = TextEditingValue(
        text: '12/34',
        selection: TextSelection.fromPosition(
          const TextPosition(offset: 3),
        ),
      );
      final transformed =
          inputFormatter.formatEditUpdate(defaultOldValue, newValue);
      expect(transformed.text, '12/34/');
    });

    test('if early closed segment is correctly padded', () {
      final newValue = TextEditingValue(
        text: '12/3/',
        selection: TextSelection.fromPosition(
          const TextPosition(offset: 3),
        ),
      );
      final transformed =
          inputFormatter.formatEditUpdate(defaultOldValue, newValue);
      expect(transformed.text, '12/03/');
    });

    test('if early closed segment is correctly padded', () {
      final newValue = TextEditingValue(
        text: '12/3/',
        selection: TextSelection.fromPosition(
          const TextPosition(offset: 3),
        ),
      );
      final transformed =
          inputFormatter.formatEditUpdate(defaultOldValue, newValue);
      expect(transformed.text, '12/03/');
    });

    test('if correct input is correctly replicated', () {
      final newValue = TextEditingValue(
        text: '12/03/2023',
        selection: TextSelection.fromPosition(
          const TextPosition(offset: 3),
        ),
      );
      final transformed =
          inputFormatter.formatEditUpdate(defaultOldValue, newValue);
      expect(transformed.text, '12/03/2023');
    });

    test('if correct, but unpadded input is correctly padded', () {
      final newValue = TextEditingValue(
        text: '2/3/2023',
        selection: TextSelection.fromPosition(
          const TextPosition(offset: 3),
        ),
      );
      final transformed =
          inputFormatter.formatEditUpdate(defaultOldValue, newValue);
      expect(transformed.text, '02/03/2023');
    });
  });
}
