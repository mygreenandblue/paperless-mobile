import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/highlighted_text.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/details_item.dart';
import 'package:paperless_mobile/features/labels/storage_path/view/widgets/storage_path_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_text.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class DocumentOverviewWidget extends StatelessWidget {
  final DocumentModel document;
  final String? queryString;
  final double itemSpacing;
  const DocumentOverviewWidget({
    super.key,
    required this.document,
    this.queryString,
    required this.itemSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      children: [
        DetailsItem(
          label: S.of(context)!.title,
          content: HighlightedText(
            text: document.title,
            highlights: queryString?.split(" ") ?? [],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ).paddedOnly(bottom: itemSpacing),
        DetailsItem.text(
          DateFormat.yMMMMd().format(document.created),
          context: context,
          label: S.of(context)!.createdAt,
        ).paddedOnly(bottom: itemSpacing),
        Visibility(
          visible: document.documentType != null,
          child: DetailsItem(
            label: S.of(context)!.documentType,
            content: LabelText<DocumentType>(
              style: Theme.of(context).textTheme.bodyLarge,
              id: document.documentType,
            ),
          ).paddedOnly(bottom: itemSpacing),
        ),
        Visibility(
          visible: document.correspondent != null,
          child: DetailsItem(
            label: S.of(context)!.correspondent,
            content: LabelText<Correspondent>(
              style: Theme.of(context).textTheme.bodyLarge,
              id: document.correspondent,
            ),
          ).paddedOnly(bottom: itemSpacing),
        ),
        Visibility(
          visible: document.storagePath != null,
          child: DetailsItem(
            label: S.of(context)!.storagePath,
            content: StoragePathWidget(
              pathId: document.storagePath,
            ),
          ).paddedOnly(bottom: itemSpacing),
        ),
        Visibility(
          visible: document.tags.isNotEmpty,
          child: DetailsItem(
            label: S.of(context)!.tags,
            content: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TagsWidget(
                isClickable: false,
                tagIds: document.tags,
              ),
            ),
          ).paddedOnly(bottom: itemSpacing),
        ),
      ],
    );
  }
}
