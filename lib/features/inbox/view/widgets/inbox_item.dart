import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/provider/label_repositories_provider.dart';
import 'package:paperless_mobile/core/repository/state/impl/correspondent_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/document_type_repository_state.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/bloc/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/documents/view/widgets/delete_document_confirmation_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/inbox/bloc/inbox_cubit.dart';
import 'package:paperless_mobile/features/inbox/bloc/state/inbox_state.dart';
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
  bool _isAsnAssignLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 180,
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
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        const Spacer(),
                        _buildCorrespondent(context),
                        _buildDocumentType(context),
                        const Spacer(),
                        _buildTags(),
                      ],
                    ).padded(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48,
              child: _buildActions(context),
            ),
          ],
        ).padded(),
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
      ActionChip(
        avatar: const Icon(Icons.delete_outline),
        shape: chipShape,
        label: const Text("Delete document"),
        onPressed: () async {
          final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) =>
                    DeleteDocumentConfirmationDialog(document: widget.document),
              ) ??
              false;
          if (shouldDelete) {
            context.read<InboxCubit>().deleteDocument(widget.document);
          }
        },
      ),
    ];
    return BlocBuilder<InboxCubit, InboxState>(
      builder: (context, state) {
        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...actions,
            if (state.suggestions[widget.document.id] != null) ...[
              SizedBox(width: 4),
              ..._buildSuggestionChips(
                chipShape,
                state.suggestions[widget.document.id]!,
                state,
              )
            ]
          ],
        );
      },
    );
  }

  ActionChip _buildAssignAsnAction(
    RoundedRectangleBorder chipShape,
    BuildContext context,
  ) {
    final hasAsn = widget.document.archiveSerialNumber != null;
    return ActionChip(
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
    );
  }

  TagsWidget _buildTags() {
    return TagsWidget(
      tagIds: widget.document.tags,
      isMultiLine: false,
      isClickable: false,
      isSelectedPredicate: (_) => false,
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

  List<Widget> _buildSuggestionChips(
    OutlinedBorder chipShape,
    FieldSuggestions suggestions,
    InboxState state,
  ) {
    return [
      ...suggestions.correspondents
          .map(
            (e) => ActionChip(
              avatar: const Icon(Icons.person_outline),
              shape: chipShape,
              label: Text(state.availableCorrespondents[e]?.name ?? ''),
              onPressed: () {
                context
                    .read<InboxCubit>()
                    .updateDocument(widget.document.copyWith(
                      correspondent: e,
                      overwriteCorrespondent: true,
                    ));
              },
            ),
          )
          .toList(),
      ...suggestions.documentTypes
          .map(
            (e) => ActionChip(
              avatar: const Icon(Icons.description_outlined),
              shape: chipShape,
              label: Text(state.availableDocumentTypes[e]?.name ?? ''),
              onPressed: () {
                context
                    .read<InboxCubit>()
                    .updateDocument(widget.document.copyWith(
                      documentType: e,
                      overwriteDocumentType: true,
                    ));
              },
            ),
          )
          .toList(),
    ];
  }
}
