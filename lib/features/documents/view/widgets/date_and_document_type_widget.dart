import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:provider/provider.dart';

class DateAndDocumentTypeLabelWidget extends StatelessWidget {
  const DateAndDocumentTypeLabelWidget({
    super.key,
    required this.document,
    required this.onDocumentTypeSelected,
  });

  final DocumentModel document;
  final void Function(int? documentTypeId)? onDocumentTypeSelected;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle =
        Theme.of(context).textTheme.labelMedium?.apply(color: Colors.grey);
    final labelRepository = context.watch<LabelRepository>();
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: DateFormat.yMMMMd(Localizations.localeOf(context).toString())
            .format(document.created),
        style: subtitleStyle,
        children: document.documentType != null
            ? [
                const TextSpan(text: '\u30FB'),
                WidgetSpan(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: onDocumentTypeSelected != null
                          ? () => onDocumentTypeSelected!(document.documentType)
                          : null,
                      child: Text(
                        labelRepository
                            .documentTypes[document.documentType]!.name,
                        style: subtitleStyle,
                      ),
                    ),
                  ),
                ),
              ]
            : null,
      ),
    );
  }
}
