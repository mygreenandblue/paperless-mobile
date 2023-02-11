import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_item.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/labels/cubit/providers/document_type_bloc_provider.dart';
import 'package:paperless_mobile/features/labels/correspondent/view/widgets/correspondent_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';

class DocumentListItem extends DocumentItem {
  static const _a4AspectRatio = 1 / 1.4142;

  const DocumentListItem({
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
    super.enableHeroAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentTypeBlocProvider(
      child: ListTile(
        dense: true,
        selected: isSelected,
        onTap: () => _onTap(),
        selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
        onLongPress: () => onSelected?.call(document),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                AbsorbPointer(
                  absorbing: isSelectionActive,
                  child: CorrespondentWidget(
                    isClickable: isLabelClickable,
                    correspondentId: document.correspondent,
                    onSelected: onCorrespondentSelected,
                  ),
                ),
              ],
            ),
            Text(
              document.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            AbsorbPointer(
              absorbing: isSelectionActive,
              child: TagsWidget(
                isClickable: isLabelClickable,
                tagIds: document.tags,
                isMultiLine: false,
                onTagSelected: (id) => onTagSelected?.call(id),
              ),
            )
          ],
        ),
        subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child:
                BlocBuilder<LabelCubit<DocumentType>, LabelState<DocumentType>>(
              builder: (context, docTypes) {
                return RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: DateFormat.yMMMd().format(document.created),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.apply(color: Colors.grey),
                    children: document.documentType != null
                        ? [
                            const TextSpan(text: '\u30FB'),
                            TextSpan(
                              text:
                                  docTypes.labels[document.documentType]?.name,
                            ),
                          ]
                        : null,
                  ),
                );
              },
            )
            // Row(
            //   children: [
            //     Text(
            //       DateFormat.yMMMd().format(document.created),
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodySmall
            //           ?.apply(color: Colors.grey),
            //     ),
            //     if (document.documentType != null) ...[
            //       Text("\u30FB"),
            //       DocumentTypeWidget(
            //         documentTypeId: document.documentType,
            //         textStyle: Theme.of(context).textTheme.bodySmall?.apply(
            //               color: Colors.grey,
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //       ),
            //     ],
            //   ],
            // ),
            ),
        isThreeLine: document.tags.isNotEmpty,
        leading: AspectRatio(
          aspectRatio: _a4AspectRatio,
          child: GestureDetector(
            child: DocumentPreview(
              id: document.id,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              enableHero: enableHeroAnimation,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.all(8.0),
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
