import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/core/extensions/document_extensions.dart';
import 'package:edocs_mobile/core/repository/label_repository.dart';
import 'package:edocs_mobile/core/util/lambda_utils.dart';
import 'package:edocs_mobile/core/widgets/shimmer_placeholder.dart';
import 'package:edocs_mobile/core/workarounds/colored_chip.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/features/documents/view/widgets/delete_document_confirmation_dialog.dart';
import 'package:edocs_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:edocs_mobile/features/documents/view/widgets/placeholder/tags_placeholder.dart';
import 'package:edocs_mobile/features/documents/view/widgets/placeholder/text_placeholder.dart';
import 'package:edocs_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:edocs_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:edocs_mobile/features/labels/view/widgets/label_text.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/helpers/connectivity_aware_action_wrapper.dart';
import 'package:edocs_mobile/routing/routes/documents_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';

class InboxItemPlaceholder extends StatelessWidget {
  const InboxItemPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerPlaceholder(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextPlaceholder(length: 150, fontSize: 12),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 90,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: const ColoredBox(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            TextPlaceholder(length: 200, fontSize: 14),
                            Spacer(),
                            TextPlaceholder(length: 120, fontSize: 14),
                            SizedBox(height: 8),
                            TextPlaceholder(length: 170, fontSize: 14),
                            Spacer(),
                            TagsPlaceholder(count: 3, dense: true),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: IntrinsicHeight(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 40,
                            child: ColoredBox(
                              color: Colors.white,
                            ),
                          ).padded(),
                          const VerticalDivider(
                            indent: 12,
                            endIndent: 12,
                          ),
                          SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  width: 200,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InboxItem extends StatefulWidget {
  static const a4AspectRatio = 1 / 1.4142;
  final DocumentModel document;
  const InboxItem({
    super.key,
    required this.document,
  });

  @override
  State<InboxItem> createState() => _InboxItemState();
}

class _InboxItemState extends State<InboxItem> {
  // late final Future<FieldSuggestions> _fieldSuggestions;

  bool _isAsnAssignLoading = false;

  @override
  Widget build(BuildContext context) {
    final labelRepository = context.read<LabelRepository>();
    return BlocBuilder<InboxCubit, InboxState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            DocumentDetailsRoute(
              title: widget.document.title,
              id: widget.document.id,
              thumbnailUrl: widget.document.buildThumbnailUrl(context),
              isLabelClickable: false,
            ).push(context);
          },
          child: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      AspectRatio(
                        aspectRatio: InboxItem.a4AspectRatio,
                        child: DocumentPreview(
                          documentId: widget.document.id,
                          title: widget.document.title,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          enableHero: false,
                        ),
                      ).padded(),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle().paddedOnly(left: 8, right: 8, top: 8),
                            const Spacer(),
                            _buildTextWithLeadingIcon(
                              Icon(
                                Icons.person_outline,
                                size: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.fontSize,
                              ),
                              LabelText<Correspondent>(
                                label: labelRepository.correspondents[
                                    widget.document.correspondent],
                                style: Theme.of(context).textTheme.bodyMedium,
                                placeholder: "-",
                              ),
                            ).paddedSymmetrically(horizontal: 8),
                            _buildTextWithLeadingIcon(
                              Icon(
                                Icons.description_outlined,
                                size: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.fontSize,
                              ),
                              LabelText<DocumentType>(
                                label: labelRepository.documentTypes[
                                    widget.document.documentType],
                                style: Theme.of(context).textTheme.bodyMedium,
                                placeholder: "-",
                              ),
                            ).paddedSymmetrically(horizontal: 8),
                            const Spacer(),
                            TagsWidget(
                              tags: widget.document.tags
                                  .map((e) => labelRepository.tags[e])
                                  .where(isNotNull)
                                  .toList()
                                  .cast<Tag>(),
                              isClickable: false,
                              showShortNames: true,
                            ).paddedOnly(left: 8, bottom: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                LimitedBox(
                  maxHeight: 56,
                  child: ConnectivityAwareActionWrapper(
                    child: _buildActions(context),
                  ),
                ),
              ],
            ).paddedOnly(left: 8, top: 8, bottom: 8),
          ),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context) {
    final currentUser = context.watch<LocalUserAccount>().edocsUser;
    final canEdit = currentUser.canEditDocuments;
    final canDelete = currentUser.canDeleteDocuments;
    final chipShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32),
    );
    final actions = [
      if (canEdit) _buildAssignAsnAction(chipShape, context),
      if (canEdit && canDelete) const SizedBox(width: 8.0),
      if (canDelete)
        ColoredChipWrapper(
          child: ActionChip(
            avatar: const Icon(Icons.delete_outline),
            shape: chipShape,
            label: Text(S.of(context)!.deleteDocument),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => DeleteDocumentConfirmationDialog(
                        document: widget.document),
                  ) ??
                  false;
              if (shouldDelete) {
                context.read<InboxCubit>().delete(widget.document);
              }
            },
          ),
        ),
    ];
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 50,
              ),
              child: Text(
                S.of(context)!.quickAction,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            const VerticalDivider(
              indent: 16,
              endIndent: 16,
            ),
          ],
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...actions,
              // if (suggestions != null) ...suggestions,
            ],
          ),
        ),
      ],
      // );
      // },
    );
  }

  Widget _buildAssignAsnAction(
    RoundedRectangleBorder chipShape,
    BuildContext context,
  ) {
    final hasAsn = widget.document.archiveSerialNumber != null;
    return ColoredChipWrapper(
      child: ActionChip(
        avatar: _isAsnAssignLoading
            ? const CircularProgressIndicator()
            : hasAsn
                ? null
                : const Icon(Icons.archive_outlined),
        shape: chipShape,
        label: hasAsn
            ? Text(
                '${S.of(context)!.asn} #${widget.document.archiveSerialNumber}',
              )
            : Text(S.of(context)!.assignAsn),
        onPressed: !hasAsn
            ? () {
                setState(() {
                  _isAsnAssignLoading = true;
                });

                context
                    .read<InboxCubit>()
                    .assignAsn(widget.document)
                    .whenComplete(
                      () => setState(() => _isAsnAssignLoading = false),
                    );
              }
            : null,
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      widget.document.title.isEmpty ? '-' : widget.document.title,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }

  Row _buildTextWithLeadingIcon(Icon icon, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 2),
        Flexible(
          child: child,
        ),
      ],
    );
  }

  // List<Widget> _buildSuggestionChips(
  //   OutlinedBorder chipShape,
  //   FieldSuggestions suggestions,
  //   InboxState state,
  // ) {
  //   return [
  //     ...suggestions.correspondents
  //         .whereNot((e) => widget.document.correspondent == e)
  //         .map(
  //           (e) => ActionChip(
  //             avatar: const Icon(Icons.person_outline),
  //             shape: chipShape,
  //             label: Text(state.availableCorrespondents[e]?.name ?? ''),
  //             onPressed: () {
  //               context
  //                   .read<InboxCubit>()
  //                   .update(
  //                     widget.document.copyWith(correspondent: () => e),
  //                   )
  //                   .then((value) => showSnackBar(
  //                       context,
  //                       S
  //                           .of(context)
  //                           .suggestionSuccessfullyApplied));
  //             },
  //           ),
  //         )
  //         .toList(),
  //     ...suggestions.documentTypes
  //         .whereNot((e) => widget.document.documentType == e)
  //         .map(
  //           (e) => ActionChip(
  //             avatar: const Icon(Icons.description_outlined),
  //             shape: chipShape,
  //             label: Text(state.availableDocumentTypes[e]?.name ?? ''),
  //             onPressed: () => context
  //                 .read<InboxCubit>()
  //                 .update(
  //                   widget.document.copyWith(documentType: () => e),
  //                   shouldReload: false,
  //                 )
  //                 .then((value) => showSnackBar(
  //                     context,
  //                     S
  //                         .of(context)
  //                         .suggestionSuccessfullyApplied)),
  //           ),
  //         )
  //         .toList(),
  //     ...suggestions.tags
  //         .whereNot((e) => widget.document.tags.contains(e))
  //         .map(
  //           (e) => ActionChip(
  //             avatar: const Icon(Icons.label_outline),
  //             shape: chipShape,
  //             label: Text(state.availableTags[e]?.name ?? ''),
  //             onPressed: () {
  //               context
  //                   .read<InboxCubit>()
  //                   .update(
  //                     widget.document.copyWith(
  //                       tags: {...widget.document.tags, e}.toList(),
  //                     ),
  //                     shouldReload: false,
  //                   )
  //                   .then((value) => showSnackBar(
  //                       context,
  //                       S
  //                           .of(context)
  //                           .suggestionSuccessfullyApplied));
  //             },
  //           ),
  //         )
  //         .toList(),
  //     ...suggestions.dates
  //         .whereNot((e) => widget.document.created.isEqualToIgnoringDate(e))
  //         .map(
  //           (e) => ActionChip(
  //             avatar: const Icon(Icons.calendar_today_outlined),
  //             shape: chipShape,
  //             label: Text(
  //               "${S.of(context)!.createdAt}: ${DateFormat.yMd().format(e)}",
  //             ),
  //             onPressed: () => context
  //                 .read<InboxCubit>()
  //                 .update(
  //                   widget.document.copyWith(created: e),
  //                   shouldReload: false,
  //                 )
  //                 .then((value) => showSnackBar(
  //                     context,
  //                     S
  //                         .of(context)
  //                         .suggestionSuccessfullyApplied)),
  //           ),
  //         )
  //         .toList(),
  //   ].expand((element) => [element, const SizedBox(width: 4)]).toList();
  // }
}
