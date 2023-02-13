import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_item.dart';
import 'package:paperless_mobile/features/labels/correspondent/view/widgets/correspondent_widget.dart';
import 'package:paperless_mobile/features/labels/document_type/view/widgets/document_type_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';

class DocumentDetailedItem extends DocumentItem {
  const DocumentDetailedItem({
    super.key,
    required super.document,
    required super.isSelected,
    required super.isSelectionActive,
    required super.isLabelClickable,
    required super.enableHeroAnimation,
    super.onCorrespondentSelected,
    super.onDocumentTypeSelected,
    super.onSelected,
    super.onStoragePathSelected,
    super.onTagSelected,
    super.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final insets = MediaQuery.of(context).viewInsets;
    final padding = MediaQuery.of(context).viewPadding;
    final availableHeight = size.height -
        insets.top -
        insets.bottom -
        padding.top -
        padding.bottom -
        kBottomNavigationBarHeight -
        kToolbarHeight;
    final maxHeight = min(500.0, availableHeight);
    return Card(
      child: InkWell(
        enableFeedback: true,
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isSelectionActive) {
            onSelected?.call(document);
          } else {
            onTap?.call(document);
          }
        },
        onLongPress: () {
          onSelected?.call(document);
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    width: double.infinity,
                    height: maxHeight / 2,
                  ),
                  child: DocumentPreview(
                    document: document,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(document.created),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.apply(color: Theme.of(context).hintColor),
                    ),
                    if (document.archiveSerialNumber != null)
                      Row(
                        children: [
                          Text(
                            '#${document.archiveSerialNumber}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.apply(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                  ],
                ).paddedLTRB(8, 8, 8, 4),
                Text(
                  document.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ).paddedLTRB(8, 0, 8, 4),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                    ).paddedOnly(right: 4.0),
                    CorrespondentWidget(
                      onSelected: onCorrespondentSelected,
                      textStyle: Theme.of(context).textTheme.titleSmall?.apply(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      correspondentId: document.correspondent,
                    ),
                  ],
                ).paddedLTRB(8, 0, 8, 4),
                Row(
                  children: [
                    const Icon(
                      Icons.description_outlined,
                      size: 16,
                    ).paddedOnly(right: 4.0),
                    DocumentTypeWidget(
                      onSelected: onDocumentTypeSelected,
                      textStyle: Theme.of(context).textTheme.titleSmall?.apply(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      documentTypeId: document.documentType,
                    ),
                  ],
                ).paddedLTRB(8, 0, 8, 4),
                TagsWidget(
                  isMultiLine: false,
                  tagIds: document.tags,
                ).padded(),
              ],
            ),
          ],
        ),
      ),
    ).padded();
  }
}
