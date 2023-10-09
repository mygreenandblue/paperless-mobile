import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/localized_date_input_formatter.dart';

class LocalizedFormBuilderDatePicker extends StatelessWidget {
  final String name;
  final String label;
  final DateTime? initialValue;
  const LocalizedFormBuilderDatePicker({
    super.key,
    required this.name,
    required this.label,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final localizedDateFormat =
        DateFormat.yMd(Localizations.localeOf(context).toString());
    final separator = localizedDateFormat
        .format(DateTime(2000, 11, 11))
        .replaceAll(RegExp(r'[0-9]'), '')
        .characters
        .first;
    return FormBuilderField<DateTime>(
      initialValue: initialValue,
      builder: (field) {
        return TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            try {
              final parsed = localizedDateFormat.parseLoose(value);
            } on FormatException catch (_) {
              return "Invalid date format (${localizedDateFormat.pattern})."; //TODO: INTL
            }
          },
          keyboardType: TextInputType.datetime,
          initialValue: initialValue != null
              ? localizedDateFormat.format(initialValue!)
              : null,
          onChanged: (value) {
            try {
              final date = localizedDateFormat.parseLoose(value);
              field.didChange(date);
            } on FormatException catch (_) {}
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9$separator]')),
            LocalizedDateInputFormatter(
              Localizations.localeOf(context).toString(),
            ),
          ],
          onTap: () {
            field.didChange(null);
          },
          decoration: InputDecoration(
            hintText: initialValue != null
                ? DateFormat.yMd(Localizations.localeOf(context).toString())
                    .format(initialValue!)
                : null,
            prefixIcon: Icon(Icons.calendar_today_rounded),
            suffixIcon: TextButton(
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.only(right: 8)),
              ),
              child: Text(S.of(context)!.select),
              onPressed: () async {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                  lastDate: DateTime.now(),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                );
              },
            ),
          ),
        );
      },
      name: name,
    );
  }
}
