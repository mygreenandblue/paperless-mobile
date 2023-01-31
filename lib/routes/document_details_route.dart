import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/provider/label_repositories_provider.dart';
import 'package:paperless_mobile/features/document_details/bloc/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';

class DocumentDetailsRoute extends StatelessWidget {
  static const String routeName = "/documentDetails";
  const DocumentDetailsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as DocumentDetailsRouteArguments;

    return BlocProvider(
      create: (context) => DocumentDetailsCubit(
        context.read<PaperlessDocumentsApi>(),
        args.document,
      ),
      child: LabelRepositoriesProvider(
        child: DocumentDetailsPage(
          allowEdit: args.allowEdit,
          isLabelClickable: args.isLabelClickable,
          titleAndContentQueryString: args.titleAndContentQueryString,
        ),
      ),
    );
  }
}

class DocumentDetailsRouteArguments {
  final DocumentModel document;
  final bool isLabelClickable;
  final bool allowEdit;
  final String? titleAndContentQueryString;

  DocumentDetailsRouteArguments({
    required this.document,
    this.isLabelClickable = true,
    this.allowEdit = true,
    this.titleAndContentQueryString,
  });
}
