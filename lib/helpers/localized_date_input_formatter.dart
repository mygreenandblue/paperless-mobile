import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A [TextInputFormatter] that supports the user in entering correct, localized full date patterns.
/// These patterns are required to be padded (e.g. 03/07/2023 instead of 3/7/23).
class LocalizedDateInputFormatter extends TextInputFormatter {
  final String locale;

  @visibleForTesting
  final String separator;

  @visibleForTesting
  final String dateFormatPattern;

  LocalizedDateInputFormatter(this.locale)
      : separator = _buildSeparator(locale),
        dateFormatPattern = DateFormat.yMd(locale).pattern ?? 'undefined';

  ///
  ///1. Check currently edited segment
  /// --> Is complete?
  ///     --> Has trailing separator?
  ///       --> No? Add separator
  ///       --> Yes? Do nothing and update edit position to after separator
  /// --> Is incomplete?
  ///     --> Wait for user to finish segment input
  ///2. Check all other untouched segments
  /// --> Are they complete?
  ///   --> Yes? Do nothing
  ///   --> No? Pad with leading zeros, we can consider it finished from user side
  ///
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String result = '';
    final currentValue = newValue.text;
    if (currentValue.length < _segmentLengths.first) {
      // We skip the initial characters as otherwise they will be padded directly.
      return newValue;
    }
    final splits = currentValue.split(separator);
    final strippedInput = splits.join('');
    // Map cursor position into separator stripped input.
    final normalizedCursorPosition =
        newValue.selection.baseOffset - (splits.length - 1);

    final globalSegmentOffsets = splits.map((e) => e.length).cumsum;
    final editedSegmentIndex = globalSegmentOffsets
        .indexWhere((offset) => offset >= normalizedCursorPosition);

    final editedSegment = splits[editedSegmentIndex];
    final editedSegmentTargetLength = _segmentLengths[editedSegmentIndex];

    if (editedSegment.length == editedSegmentTargetLength) {
      // Current segment is complete
      if (strippedInput
          .substring(normalizedCursorPosition)
          .startsWith(separator)) {
        // Current segment already ends with separator or is the last segment which does not require a separator. Return untouched value but skip separator.
        return newValue.copyWith(
          selection: TextSelection(
            baseOffset: newValue.selection.baseOffset + 1,
            extentOffset: newValue.selection.baseOffset + 1,
          ),
        );
      }
      if (editedSegmentIndex == _segmentLengths.length - 1) {
        // Current segment is the last segment, nothing to do here.
        return newValue;
      }
      // Currently edited segment is not the last segment.
      // We add a separator and update the cursor position.
      result = '${splits.join(separator)}$separator';
      return TextEditingValue(
        text: result,
        selection: TextSelection(
          baseOffset: newValue.selection.baseOffset + 1,
          extentOffset: newValue.selection.baseOffset + 1,
        ),
      );
    } else {
      // Current segment is incomplete
      // We wait for the user to finish the segment.
      return newValue;
    }
    // // final editedSegment = splits.length - 1;
    // final normalizedText = splits.mapIndexed((index, segment) {
    //   if (segment.isEmpty) {
    //     return segment;
    //   }
    //   final intendedSegmentLength = _segmentLengths[index];
    //   if (segment.length == intendedSegmentLength) {
    //     return segment;
    //   }
    //   if (index == editedSegment && index != _segmentLengths.length) {
    //     return segment;
    //   }
    //   // Otherwise pad number with leading zeros.
    //   return segment.padLeft(intendedSegmentLength, '0');
    // }).join(separator);

    // final separatorStrippedText = normalizedText.replaceAll(separator, '');
    // final chars = separatorStrippedText.characters;
    // String result = '';
    // for (int i = 0; i < min(_segmentLengths.length, editedSegment + 1); i++) {
    //   final skipCount = _segmentLengths.sublist(0, i).sum;
    //   final currentSegmentLength = _segmentLengths[i];
    //   final segmentChars = chars.skip(skipCount).take(currentSegmentLength);
    //   if (segmentChars.length != currentSegmentLength ||
    //       i == _segmentLengths.length - 1) {
    //     result += segmentChars.toString();
    //     break;
    //   } else {
    //     result += '${segmentChars.toString()}$separator';
    //   }
    // }
  }

  static String _buildSeparator(String locale) {
    final formattedDate = DateFormat.yMd(locale).format(DateTime(2000, 10, 10));
    final separator =
        formattedDate.replaceAll(RegExp(r"[0-9]"), '').substring(0, 1);
    print("SEPARATOR IS: " + separator);
    return separator;
  }

  List<int> get _segmentLengths {
    return DateFormat.yMd(locale)
        .format(DateTime(2000, 10, 10))
        .split(separator)
        .map((e) => e.length)
        .toList();
  }
}

extension CumulativeSumListExtension on Iterable<num> {
  List<num> get cumsum {
    num sum = 0;
    return map((e) => sum += e).toList();
  }
}
