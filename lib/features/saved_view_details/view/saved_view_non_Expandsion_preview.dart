import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/extensions/document_extensions.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/documents/view/widgets/items/document_list_item.dart';
import 'package:edocs_mobile/features/saved_view_details/cubit/saved_view_preview_cubit.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/routing/routes/documents_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';
import 'package:provider/provider.dart';

class SavedViewNonExpandsionPreview extends StatelessWidget {
  final DocumentModel documentModel;
  const SavedViewNonExpandsionPreview({
    super.key,
    required this.documentModel,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentListItem(
      document: documentModel,
      isLabelClickable: false,
      isSelected: false,
      isSelectionActive: false,
      onTap: (document) {
        DocumentDetailsRoute(
          title: document.title,
          id: document.id,
          thumbnailUrl: document.buildThumbnailUrl(context),
        ).push(context);
      },
      onSelected: null,
    );
  }
}
