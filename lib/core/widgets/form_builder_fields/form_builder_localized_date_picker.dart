import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/landing/view/widgets/mime_types_pie_chart.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

/// A localized, segmented date input field.
class FormBuilderLocalizedDatePicker extends StatefulWidget {
  final String name;
  final Locale locale;
  final String labelText;
  final Widget? prefixIcon;
  final DateTime? initialValue;
  final DateTime firstDate;
  final DateTime lastDate;

  /// If set to true, the field will not throw any validation errors when empty.
  final bool allowUnset;

  const FormBuilderLocalizedDatePicker({
    super.key,
    required this.name,
    this.initialValue,
    required this.firstDate,
    required this.lastDate,
    required this.locale,
    required this.labelText,
    this.prefixIcon,
    this.allowUnset = false,
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
      LinkedList<_NeighbourAwareDateInputSegmentControls>();
  String? _error;
  bool _temporarilyDisableListeners = false;
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
      final controls = _NeighbourAwareDateInputSegmentControls(
        node: FocusNode(debugLabel: formatString),
        controller: TextEditingController(text: initialText),
        format: formatString,
        position: i,
        type: _DateInputSegment.fromPattern(formatString),
      );
      _textFieldControls.add(controls);
      controls.controller.addListener(() {
        if (_temporarilyDisableListeners) {
          return;
        }
        if (controls.controller.selection.isCollapsed &&
            controls.controller.text.length == controls.format.length) {
          controls.next?.node.requestFocus();
        }
      });
      controls.node.addListener(() {
        if (_temporarilyDisableListeners || !controls.node.hasFocus) {
          return;
        }
        controls.controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controls.controller.text.length,
        );
      });
    }
  }

  @override
  void dispose() {
    for (var controls in _textFieldControls) {
      controls.node.dispose();
      controls.controller.dispose();
    }
    super.dispose();
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
        validator: _validateDate,
        onChanged: (value) {
          // We have to temporarily disable our listeners on the TextEditingController here
          // since otherwise the listeners get notified of the change and
          // the fields get focused and highlighted/selected (as defined in the
          // listeners above).
          _temporarilyDisableListeners = true;
          for (var control in _textFieldControls) {
            control.controller.text = DateFormat(control.format).format(value!);
          }
          _temporarilyDisableListeners = false;

          final error = _validateDate(value);
          setState(() {
            _error = error;
          });

          if (value?.isBefore(widget.firstDate) ?? false) {
            setState(() => _error = "Date must be after " +
                DateFormat.yMd(widget.locale.toString())
                    .format(widget.firstDate) +
                ".");
            return;
          }
          if (value?.isAfter(widget.lastDate) ?? false) {
            setState(() => _error = "Date must be before " +
                DateFormat.yMd(widget.locale.toString())
                    .format(widget.lastDate) +
                ".");
            return;
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: widget.name,
        initialValue: widget.initialValue,
        builder: (field) {
          return GestureDetector(
            onTap: () {
              _textFieldControls.first.node.requestFocus();
            },
            child: InputDecorator(
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                errorText: _error,
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
                        for (var c in _textFieldControls) {
                          c.controller.clear();
                        }
                        _textFieldControls.first.node.requestFocus();
                        field.didChange(null);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ).paddedOnly(right: 4),
              ),
              child: Row(
                children: [
                  for (var s in _textFieldControls) ...[
                    IntrinsicWidth(
                      child: _buildDateSegmentInput(s, context, field),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? _validateDate(DateTime? date) {
    if (widget.allowUnset && date == null) {
      return null;
    }
    if (date == null) {
      return S.of(context)!.thisFieldIsRequired;
    }
    if (date.isBefore(widget.firstDate)) {
      final formattedDateHint =
          DateFormat.yMd(widget.locale.toString()).format(widget.firstDate);
      return "Date must be after $formattedDateHint.";
    }
    if (date.isAfter(widget.lastDate)) {
      final formattedDateHint =
          DateFormat.yMd(widget.locale.toString()).format(widget.lastDate);
      return "Date must be before $formattedDateHint.";
    }
    return null;
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
    _NeighbourAwareDateInputSegmentControls controls,
    BuildContext context,
    FormFieldState<DateTime> field,
  ) {
    return TextFormField(
      onFieldSubmitted: (value) {
        if (value.length < controls.format.length) {
          controls.controller.text = value.padLeft(controls.format.length, '0');
        }
        _textFieldControls
            .elementAt(controls.position)
            .next
            ?.node
            .requestFocus();
      },
      style: const TextStyle(fontFamily: 'RobotoMono'),
      keyboardType: TextInputType.datetime,
      textInputAction:
          controls.position < 2 ? TextInputAction.next : TextInputAction.done,
      controller: controls.controller,
      focusNode: _textFieldControls.elementAt(controls.position).node,
      maxLength: controls.format.length,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      enableInteractiveSelection: false,
      onChanged: (value) {
        if (value.length == controls.format.length && field.value != null) {
          final number = int.tryParse(value);
          if (number == null) {
            return;
          }
          final newValue = switch (controls.type) {
            _DateInputSegment.day => field.value!.copyWith(day: number),
            _DateInputSegment.month => field.value!.copyWith(month: number),
            _DateInputSegment.year => field.value!.copyWith(year: number),
          };
          field.didChange(newValue);
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        RangeLimitedInputFormatter(
          1,
          switch (controls.type) {
            _DateInputSegment.day => 31,
            _DateInputSegment.month => 12,
            _DateInputSegment.year => 9999,
          },
        ),
      ],
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: controls.position < 2
            ? Text(
                _separator,
                style: const TextStyle(fontFamily: 'RobotoMono'),
              ).paddedSymmetrically(horizontal: 2)
            : null,
        suffixIconConstraints: const BoxConstraints.tightFor(),
        fillColor: Colors.blue.values[controls.position],
        counterText: '',
        contentPadding: EdgeInsets.zero,
        hintText: controls.format,
        hintStyle: const TextStyle(fontFamily: "RobotoMono"),
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

enum _DateInputSegment {
  day,
  month,
  year;

  static _DateInputSegment fromPattern(String pattern) {
    final char = pattern.characters.first;
    return switch (char) {
      'd' => day,
      'M' => month,
      'y' => year,
      _ => throw ArgumentError.value(pattern),
    };
  }
}

final class _NeighbourAwareDateInputSegmentControls
    with LinkedListEntry<_NeighbourAwareDateInputSegmentControls> {
  final FocusNode node;
  final TextEditingController controller;
  final int position;
  final String format;
  final _DateInputSegment type;

  _NeighbourAwareDateInputSegmentControls({
    required this.node,
    required this.controller,
    required this.format,
    required this.position,
    required this.type,
  });
}

class RangeLimitedInputFormatter extends TextInputFormatter {
  RangeLimitedInputFormatter(
    this.minimum,
    this.maximum,
  ) : assert(minimum < maximum);

  final int minimum;
  final int maximum;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < 2) {
      return newValue;
    }
    var value = int.parse(newValue.text);
    final lastCharacter = newValue.text.characters.last;
    if (value < minimum || value > maximum) {
      return TextEditingValue(
        text: lastCharacter,
        selection: TextSelection.collapsed(offset: 1),
      );
    }
    return newValue;
  }
}
