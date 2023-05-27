import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/navigation/push_routes.dart';
import 'package:paperless_mobile/core/workarounds/colored_chip.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/delete_document_confirmation_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_text.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

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
    return BlocBuilder<InboxCubit, InboxState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            pushDocumentDetailsRoute(
              context,
              document: widget.document,
              isLabelClickable: false,
            );
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
                          document: widget.document,
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
                                size: Theme.of(context).textTheme.bodyMedium?.fontSize,
                              ),
                              LabelText<Correspondent>(
                                label: state.labels.correspondents[widget.document.correspondent],
                                style: Theme.of(context).textTheme.bodyMedium,
                                placeholder: "-",
                              ),
                            ).paddedSymmetrically(horizontal: 8),
                            _buildTextWithLeadingIcon(
                              Icon(
                                Icons.description_outlined,
                                size: Theme.of(context).textTheme.bodyMedium?.fontSize,
                              ),
                              LabelText<DocumentType>(
                                label: state.labels.documentTypes[widget.document.documentType],
                                style: Theme.of(context).textTheme.bodyMedium,
                                placeholder: "-",
                              ),
                            ).paddedSymmetrically(horizontal: 8),
                            const Spacer(),
                            TagsWidget(
                              tags: widget.document.tags
                                  .map((e) => state.labels.tags[e])
                                  .whereNot((element) => element == null)
                                  .toList()
                                  .cast<Tag>(),
                              isMultiLine: false,
                              isClickable: false,
                              showShortNames: true,
                              dense: true,
                            ).paddedOnly(left: 8, bottom: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                LimitedBox(
                  maxHeight: 56,
                  child: _buildActions(context),
                ),
              ],
            ).paddedOnly(left: 8, top: 8, bottom: 8),
          ),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context) {
    final canEdit = LocalUserAccount.current.paperlessUser
        .hasPermission(PermissionAction.change, PermissionTarget.document);
    final canDelete = LocalUserAccount.current.paperlessUser
        .hasPermission(PermissionAction.delete, PermissionTarget.document);
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
                    builder: (context) =>
                        DeleteDocumentConfirmationDialog(document: widget.document),
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

                context.read<InboxCubit>().assignAsn(widget.document).whenComplete(
                      () => setState(() => _isAsnAssignLoading = false),
                    );
              }
            : null,
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      widget.document.title,
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
