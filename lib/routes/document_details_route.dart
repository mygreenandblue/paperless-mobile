import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:provider/provider.dart';

class DocumentDetailsRoute extends StatelessWidget {
  final DocumentModel document;
  final bool isLabelClickable;
  final bool allowEdit;
  final String? titleAndContentQueryString;

  const DocumentDetailsRoute({
    super.key,
    required this.document,
    this.isLabelClickable = true,
    this.allowEdit = true,
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
        allowEdit: allowEdit,
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

Future<void> pushDocumentDetailsRoute(
  BuildContext context, {
  required DocumentModel document,
  bool isLabelClickable = true,
  bool allowEdit = true,
  String? titleAndContentQueryString,
}) {
  final LabelRepository labelRepository = context.read();
  final DocumentChangedNotifier changeNotifier = context.read();
  final PaperlessDocumentsApi documentsApi = context.read();
  final LocalNotificationService notificationservice = context.read();
  final CacheManager cacheManager = context.read();
  return Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => MultiProvider(
      providers: [
        Provider.value(value: documentsApi),
        Provider.value(value: labelRepository),
        Provider.value(value: changeNotifier),
        Provider.value(value: notificationservice),
        Provider.value(value: cacheManager),
      ],
      child: DocumentDetailsRoute(
        document: document,
        allowEdit: allowEdit,
        isLabelClickable: isLabelClickable,
      ),
    ),
  ));
}
