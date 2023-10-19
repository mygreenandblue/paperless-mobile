import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:synchronized/extension.dart';

final class NeighbourAwareDateInputSegmentControls
    with LinkedListEntry<NeighbourAwareDateInputSegmentControls> {
  final FocusNode node;
  final TextEditingController controller;
  final int position;
  final String format;
  final DateTime? initialDate;

  NeighbourAwareDateInputSegmentControls({
    required this.node,
    required this.controller,
    required this.format,
    this.initialDate,
    required this.position,
  });
}

class FormBuilderLocalizedDatePicker extends StatefulWidget {
  final String name;
  final String labelText;
  final Widget? prefixIcon;
  final DateTime? initialValue;
  final DateTime firstDate;
  final DateTime lastDate;
  final Locale locale;

  const FormBuilderLocalizedDatePicker({
    super.key,
    required this.name,
    this.initialValue,
    required this.firstDate,
    required this.lastDate,
    required this.locale,
    required this.labelText,
    this.prefixIcon,
  });

  @override
  State<FormBuilderLocalizedDatePicker> createState() =>
      _FormBuilderLocalizedDatePickerState();
}

class _FormBuilderLocalizedDatePickerState
    extends State<FormBuilderLocalizedDatePicker> {
  late final String _separator;
  late final String _format;

  final _textFieldControls =
      LinkedList<NeighbourAwareDateInputSegmentControls>();

  @override
  void initState() {
    super.initState();
    final format =
        DateFormat.yMd(widget.locale.toString()).format(DateTime(1000, 11, 22));
    _separator = format.replaceAll(RegExp(r'\d'), '').characters.first;
    _format = format
        .replaceAll("1000", "yyyy")
        .replaceAll("11", "MM")
        .replaceAll("22", "dd");

    final components = _format.split(_separator);
    for (int i = 0; i < components.length; i++) {
      final formatString = components[i];
      final initialText = widget.initialValue != null
          ? DateFormat(formatString).format(widget.initialValue!)
          : null;
      final item = NeighbourAwareDateInputSegmentControls(
        node: FocusNode(debugLabel: formatString),
        controller: TextEditingController(text: initialText),
        format: formatString,
        position: i,
      );
      item.controller.addListener(() {
        if (item.controller.text.length == item.format.length) {
          // _textFieldControls.elementAt(i).next?.node.requestFocus();
          // _textFieldControls.elementAt(i).next?.controller.selection =
          //     const TextSelection.collapsed(offset: 0);
          // return;
        }
      });
      item.node.addListener(() {
        if (item.node.hasFocus) {
          item.controller.selection = const TextSelection.collapsed(offset: 0);
        }
      });
      _textFieldControls.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (value) {
        if (value.logicalKey == LogicalKeyboardKey.backspace &&
            value is RawKeyDownEvent) {
          final currentFocus = _textFieldControls
              .where((element) => element.node.hasFocus)
              .firstOrNull;
          if (currentFocus == null) {
            return;
          }
          if (currentFocus.controller.text.isEmpty) {
            currentFocus.previous?.node.requestFocus();
            final endOffset = currentFocus.previous?.controller.text.length;
            currentFocus.previous?.controller.selection =
                TextSelection.collapsed(offset: endOffset ?? 0);
          }
        }
      },
      child: FormBuilderField<DateTime>(
        name: widget.name,
        initialValue: widget.initialValue,
        validator: (value) {
          if (value?.isBefore(widget.firstDate) ?? false) {
            return "Date must be before " +
                DateFormat.yMd(widget.locale.toString())
                    .format(widget.firstDate);
          }
          if (value?.isAfter(widget.lastDate) ?? false) {
            return "Date must be after " +
                DateFormat.yMd(widget.locale.toString())
                    .format(widget.lastDate);
          }
          return null;
        },
        builder: (field) {
          return SizedBox(
            height: 56,
            child: InputDecorator(
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                labelText: widget.labelText,
                prefixIcon: widget.prefixIcon,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: widget.initialValue ?? DateTime.now(),
                          firstDate: widget.firstDate,
                          lastDate: widget.lastDate,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                        );
                        if (selectedDate != null) {
                          _updateInputsWithDate(selectedDate);
                          field.didChange(selectedDate);
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        field.didChange(null);
                        for (var c in _textFieldControls) {
                          c.controller.clear();
                        }
                        _textFieldControls.first.node.requestFocus();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ).paddedOnly(right: 4),
              ),
              child: Row(
                children: [
                  for (var s in _textFieldControls) ...[
                    SizedBox(
                      width: switch (s.format) {
                        == "dd" => 32,
                        == "MM" => 32,
                        == "yyyy" => 48,
                        _ => 0,
                      },
                      child: _buildDateSegmentInput(s, context, field),
                    ),
                    if (s.position < 2) Text(_separator).paddedOnly(right: 4),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateInputsWithDate(DateTime date) {
    final components = _format.split(_separator);
    for (int i = 0; i < components.length; i++) {
      final formatString = components[i];
      final value = DateFormat(formatString).format(date);
      _textFieldControls.elementAt(i).controller.text = value;
    }
  }

  Widget _buildDateSegmentInput(
    NeighbourAwareDateInputSegmentControls controls,
    BuildContext context,
    FormFieldState<DateTime> field,
  ) {
    return TextFormField(
      onFieldSubmitted: (value) {
        _textFieldControls
            .elementAt(controls.position)
            .next
            ?.node
            .requestFocus();
      },
      // onTap: () {
      //   controls.controller.clear();
      // },
      canRequestFocus: true,
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.done,
      controller: controls.controller,
      focusNode: _textFieldControls.elementAt(controls.position).node,
      maxLength: controls.format.length,
      maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
      enableInteractiveSelection: false,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        ReplacingTextFormatter(),
      ],
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        counterText: '',
        hintText: controls.format,
        border: Theme.of(context).inputDecorationTheme.border?.copyWith(
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
      ),
    );
  }
}

class ReplacingTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldOffset = oldValue.selection.baseOffset;
    final newOffset = newValue.selection.baseOffset;
    final replacement = newValue.text.substring(oldOffset, newOffset);
    print(
        "DBG: Received ${oldValue.text} -> ${newValue.text}. New char = $replacement");
    if (oldOffset < newOffset) {
      final oldText = oldValue.text;
      final newText = oldText.replaceRange(
        oldOffset,
        newOffset,
        newValue.text.substring(oldOffset, newOffset),
      );
      print("DBG: Replacing $oldText -> $newText");
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newOffset),
      );
    }

    return newValue;
  }
}
