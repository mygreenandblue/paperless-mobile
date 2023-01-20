import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/provider/label_repositories_provider.dart';
import 'package:paperless_mobile/core/repository/state/impl/correspondent_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/document_type_repository_state.dart';
import 'package:paperless_mobile/core/workarounds/colored_chip.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/bloc/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/documents/view/widgets/delete_document_confirmation_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/inbox/bloc/inbox_cubit.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_text.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class InboxItem extends StatefulWidget {
  static const _a4AspectRatio = 1 / 1.4142;

  final void Function(DocumentModel model) onDocumentUpdated;
  final DocumentModel document;
  const InboxItem({
    super.key,
    required this.document,
    required this.onDocumentUpdated,
  });

  @override
  State<InboxItem> createState() => _InboxItemState();
}

class _InboxItemState extends State<InboxItem> {
  // late final Future<FieldSuggestions> _fieldSuggestions;

  bool _isAsnAssignLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final returnedDocument = await Navigator.push<DocumentModel?>(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => DocumentDetailsCubit(
                context.read<PaperlessDocumentsApi>(),
                widget.document,
              ),
              child: const LabelRepositoriesProvider(
                child: DocumentDetailsPage(
                  isLabelClickable: false,
                ),
              ),
            ),
          ),
        );
        if (returnedDocument != null) {
          widget.onDocumentUpdated(returnedDocument);
        }
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
                    aspectRatio: InboxItem._a4AspectRatio,
                    child: DocumentPreview(
                      id: widget.document.id,
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
                        _buildCorrespondent(context)
                            .paddedSymmetrically(horizontal: 8),
                        _buildDocumentType(context)
                            .paddedSymmetrically(horizontal: 8),
                        const Spacer(),
                        _buildTags().paddedOnly(left: 8, bottom: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 56,
              child: _buildActions(context),
            ),
          ],
        ).paddedOnly(left: 8, top: 8, bottom: 8),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final chipShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32),
    );
    final actions = [
      _buildAssignAsnAction(chipShape, context),
      const SizedBox(width: 4.0),
      ColoredChipWrapper(
        child: ActionChip(
          avatar: const Icon(Icons.delete_outline),
          shape: chipShape,
          label: const Text("Delete document"),
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
    // return FutureBuilder<FieldSuggestions>(
    //   future: _fieldSuggestions,
    //   builder: (context, snapshot) {
    //     List<Widget>? suggestions;
    //     if (!snapshot.hasData) {
    //       suggestions = [
    //         const SizedBox(width: 4),
    //       ];
    //     } else {
    //       if (snapshot.data!.hasSuggestions) {
    //         suggestions = [
    //           const SizedBox(width: 4),
    //           ..._buildSuggestionChips(
    //             chipShape,
    //             snapshot.data!,
    //             context.watch<InboxCubit>().state,
    //           ),
    //         ];
    //       }
    //     }

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_outlined),
            SizedBox(
              width: 40,
              child: Text(
                S.of(context).inboxPageQuickActionsLabel,
                textAlign: TextAlign.center,
                maxLines: 2,
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
                '${S.of(context).documentArchiveSerialNumberPropertyShortLabel} #${widget.document.archiveSerialNumber}',
              )
            : const Text("Assign ASN"),
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

  TagsWidget _buildTags() {
    return TagsWidget(
      tagIds: widget.document.tags,
      isMultiLine: false,
      isClickable: false,
      showShortNames: true,
      dense: true,
    );
  }

  Row _buildDocumentType(BuildContext context) {
    return _buildTextWithLeadingIcon(
      Icon(
        Icons.description_outlined,
        size: Theme.of(context).textTheme.bodyMedium?.fontSize,
      ),
      LabelText<DocumentType, DocumentTypeRepositoryState>(
        id: widget.document.documentType,
        style: Theme.of(context).textTheme.bodyMedium,
        placeholder: "-",
      ),
    );
  }

  Row _buildCorrespondent(BuildContext context) {
    return _buildTextWithLeadingIcon(
      Icon(
        Icons.person_outline,
        size: Theme.of(context).textTheme.bodyMedium?.fontSize,
      ),
      LabelText<Correspondent, CorrespondentRepositoryState>(
        id: widget.document.correspondent,
        style: Theme.of(context).textTheme.bodyMedium,
        placeholder: "-",
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
  //                           .inboxPageSuggestionSuccessfullyAppliedMessage));
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
  //                         .inboxPageSuggestionSuccessfullyAppliedMessage)),
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
  //                           .inboxPageSuggestionSuccessfullyAppliedMessage));
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
  //               "${S.of(context).documentCreatedPropertyLabel}: ${DateFormat.yMd().format(e)}",
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
  //                         .inboxPageSuggestionSuccessfullyAppliedMessage)),
  //           ),
  //         )
  //         .toList(),
  //   ].expand((element) => [element, const SizedBox(width: 4)]).toList();
  // }
}
