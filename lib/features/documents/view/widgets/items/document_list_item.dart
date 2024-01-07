import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/features/documents/view/widgets/date_and_document_type_widget.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_item.dart';
import 'package:paperless_mobile/features/labels/correspondent/view/widgets/correspondent_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:provider/provider.dart';

class DocumentListItem extends DocumentItem {
  static const _a4AspectRatio = 1 / 1.4142;

  final Color? backgroundColor;
  const DocumentListItem({
    super.key,
    this.backgroundColor,
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
    super.enableHeroAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final labelRepository = context.watch<LabelRepository>();

    return ListTile(
      tileColor: backgroundColor,
      dense: true,
      selected: isSelected,
      onTap: () => _onTap(),
      selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
      onLongPress: onSelected != null ? () => onSelected!(document) : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Flexible(
                child: AbsorbPointer(
                  absorbing: isSelectionActive,
                  child: CorrespondentWidget(
                    isClickable: isLabelClickable,
                    correspondent:
                        labelRepository.correspondents[document.correspondent],
                    onSelected: onCorrespondentSelected,
                  ),
                ),
              ),
            ],
          ),
          Text(
            document.title.isEmpty ? '-' : document.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          AbsorbPointer(
            absorbing: isSelectionActive,
            child: TagsWidget(
              isClickable: isLabelClickable,
              tags: document.tags
                  .where((e) => labelRepository.tags.containsKey(e))
                  .map((e) => labelRepository.tags[e]!)
                  .toList(),
              onTagSelected: (id) => onTagSelected?.call(id),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: DateAndDocumentTypeLabelWidget(
          document: document,
          onDocumentTypeSelected: onDocumentTypeSelected,
        ),
      ),
      isThreeLine: document.tags.isNotEmpty,
      leading: AspectRatio(
        aspectRatio: _a4AspectRatio,
        child: GestureDetector(
          child: DocumentPreview(
            documentId: document.id,
            title: document.title,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            enableHero: enableHeroAnimation,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.all(8.0),
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
