import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/features/linked_documents/bloc/state/linked_documents_state.dart';
import 'package:paperless_mobile/features/paged_document_view/paged_documents_mixin.dart';

class LinkedDocumentsCubit extends Cubit<LinkedDocumentsState>
    with PagedDocumentsMixin {
  @override
  final PaperlessDocumentsApi api;

  @override
  final DocumentChangedNotifier notifier;

  LinkedDocumentsCubit(
    DocumentFilter filter,
    this.api,
    this.notifier,
  ) : super(const LinkedDocumentsState()) {
    updateFilter(filter: filter);
    notifier.subscribe(
      this,
      onUpdated: replace,
      onDeleted: remove,
    );
  }

  @override
  Future<void> update(DocumentModel document) async {
    final updated = await api.update(document);
    if (!state.filter.matches(updated)) {
      remove(document);
    } else {
      replace(document);
    }
  }
}
