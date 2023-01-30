import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_item.dart';
import 'package:paperless_mobile/features/labels/correspondent/view/widgets/correspondent_widget.dart';
import 'package:paperless_mobile/features/labels/document_type/view/widgets/document_type_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:intl/intl.dart';

class DocumentGridItem extends DocumentItem {
  const DocumentGridItem({
    super.key,
    required super.document,
    required super.isSelected,
    required super.isSelectionActive,
    required super.isLabelClickable,
    super.onCorrespondentSelected,
    super.onDocumentTypeSelected,
    super.onSelected,
    super.onStoragePathSelected,
    super.onTagSelected,
    super.onTap,
    required super.enableHeroAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onLongPress: onSelected != null ? () => onSelected!(document) : null,
      child: AbsorbPointer(
        absorbing: isSelectionActive,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 1.0,
            color: isSelected
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: DocumentPreview(
                    id: document.id,
                    borderRadius: 12.0,
                    enableHero: enableHeroAnimation,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CorrespondentWidget(
                          correspondentId: document.correspondent,
                        ),
                        DocumentTypeWidget(
                          documentTypeId: document.documentType,
                        ),
                        Text(
                          document.title,
                          maxLines: document.tags.isEmpty ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        TagsWidget(
                          tagIds: document.tags,
                          isMultiLine: false,
                          onTagSelected: onTagSelected,
                        ),
                        const Spacer(),
                        Text(
                          DateFormat.yMMMd().format(
                            document.created,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    if (isSelectionActive || isSelected) {
      onSelected?.call(document);
    } else {
      onTap?.call(document);
    }
  }
}
