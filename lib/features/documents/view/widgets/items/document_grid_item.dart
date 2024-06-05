import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_item.dart';
import 'package:paperless_mobile/features/labels/correspondent/view/widgets/correspondent_widget.dart';
import 'package:paperless_mobile/features/labels/document_type/view/widgets/document_type_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:paperless_mobile/features/labels/warehouse/view/widgets/warehouse_widget.dart';
import 'package:provider/provider.dart';

class DocumentGridItem extends DocumentItem {
  const DocumentGridItem({
    super.key,
    required super.document,
    required super.isSelected,
    required super.isSelectionActive,
    required super.isLabelClickable,
    super.onCorrespondentSelected,
    super.onWarehouseSelected,
    super.onDocumentTypeSelected,
    super.onSelected,
    super.onStoragePathSelected,
    super.onTagSelected,
    super.onTap,
    required super.enableHeroAnimation,
  });

  @override
  Widget build(BuildContext context) {
    var currentUser = context.watch<LocalUserAccount>().paperlessUser;
    final labelRepository = context.watch<LabelRepository>();

    return Stack(
      children: [
        Card(
          elevation: 1.0,
          color: isSelected
              ? Theme.of(context).colorScheme.inversePrimary
              : Theme.of(context).cardColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _onTap,
            onLongPress:
                onSelected != null ? () => onSelected!(document) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: DocumentPreview(
                            documentId: document.id,
                            borderRadius: 12.0,
                            enableHero: enableHeroAnimation,
                            title: document.title,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: kMinInteractiveDimension,
                            child: NotificationListener<ScrollNotification>(
                              // Prevents ancestor notification listeners to be notified when this widget scrolls
                              onNotification: (notification) => true,
                              child: CustomScrollView(
                                scrollDirection: Axis.horizontal,
                                slivers: [
                                  const SliverToBoxAdapter(
                                    child: SizedBox(width: 8),
                                  ),
                                  if (currentUser.canViewTags)
                                    TagsWidget.sliver(
                                      tags: document.tags
                                          .map((e) => labelRepository.tags[e]!)
                                          .toList(),
                                      onTagSelected: onTagSelected,
                                    ),
                                  const SliverToBoxAdapter(
                                    child: SizedBox(width: 8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (currentUser.canViewCorrespondents)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: CorrespondentWidget(
                                  correspondent: labelRepository
                                      .correspondents[document.correspondent],
                                  onSelected: onCorrespondentSelected,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: WarehouseWidget(
                                  warehouse: labelRepository
                                      .boxcases[document.warehouse],
                                  onSelected: onWarehouseSelected,
                                ),
                              ),
                            ],
                          ),
                        if (currentUser.canViewDocumentTypes)
                          DocumentTypeWidget(
                            documentType: labelRepository
                                .documentTypes[document.documentType],
                            onSelected: onDocumentTypeSelected,
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            document.title.isEmpty ? '-' : document.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat.yMMMMd(
                                Localizations.localeOf(context).toString(),
                              ).format(document.created),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (document.archiveSerialNumber != null)
                              Text(
                                '#' + document.archiveSerialNumber!.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
