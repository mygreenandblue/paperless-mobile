import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';

class DocumentDetailsRoute extends StatelessWidget {
  final DocumentModel document;
  final bool isLabelClickable;
  final String? titleAndContentQueryString;

  const DocumentDetailsRoute({
    super.key,
    required this.document,
    this.isLabelClickable = true,
    this.titleAndContentQueryString,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentDetailsCubit(
        context.read(),
        context.read(),
        context.read(),
        context.read(),
        initialDocument: document,
      ),
      lazy: false,
      child: DocumentDetailsPage(
        isLabelClickable: isLabelClickable,
        titleAndContentQueryString: titleAndContentQueryString,
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
