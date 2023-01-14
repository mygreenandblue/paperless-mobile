import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/provider/label_repositories_provider.dart';
import 'package:paperless_mobile/core/repository/state/impl/correspondent_repository_state.dart';
import 'package:paperless_mobile/core/repository/state/impl/document_type_repository_state.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/bloc/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/inbox/bloc/inbox_cubit.dart';
import 'package:paperless_mobile/features/labels/correspondent/view/widgets/correspondent_widget.dart';
import 'package:paperless_mobile/features/labels/document_type/view/widgets/document_type_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_text.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:badges/badges.dart' as b;
import 'package:paperless_mobile/extensions/string_extensions.dart';

class InboxItem extends StatelessWidget {
  static const _a4AspectRatio = 1 / 1.4142;
  final void Function(DocumentModel model) onDocumentUpdated;
  final DocumentModel document;

  const InboxItem({
    super.key,
    required this.document,
    required this.onDocumentUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Row(
                  children: [
                    Text(
                      document.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
                Row(
                  children: [],
                ),
              ],
            ),
          ),
        ],
      ),
      isThreeLine: true,
      leading: AspectRatio(
        aspectRatio: _a4AspectRatio,
        child: DocumentPreview(
          id: document.id,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          enableHero: false,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_outline,
                size: Theme.of(context).textTheme.bodySmall?.fontSize,
              ),
              Flexible(
                child: LabelText<Correspondent, CorrespondentRepositoryState>(
                  id: document.correspondent,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: Theme.of(context).textTheme.bodySmall?.fontSize,
              ),
              Flexible(
                child: LabelText<DocumentType, DocumentTypeRepositoryState>(
                  id: document.documentType,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          TagsWidget(
            tagIds: document.tags,
            isMultiLine: false,
            isClickable: false,
            isSelectedPredicate: (_) => false,
            showShortNames: true,
            dense: true,
          ),
        ],
      ),
      trailing: document.archiveSerialNumber != null
          ? Text(
              document.archiveSerialNumber!.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      onTap: () async {
        final returnedDocument = await Navigator.push<DocumentModel?>(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => DocumentDetailsCubit(
                context.read<PaperlessDocumentsApi>(),
                document,
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
          onDocumentUpdated(returnedDocument);
        }
      },
    );
  }
}
