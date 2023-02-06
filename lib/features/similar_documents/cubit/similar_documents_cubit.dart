import 'package:bloc/bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/features/paged_document_view/paged_documents_mixin.dart';
import 'package:paperless_mobile/features/paged_document_view/model/paged_documents_state.dart';

part 'similar_documents_state.dart';

class SimilarDocumentsCubit extends Cubit<SimilarDocumentsState>
    with PagedDocumentsMixin {
  final int documentId;

  @override
  final PaperlessDocumentsApi api;

  @override
  final DocumentChangedNotifier notifier;

  SimilarDocumentsCubit(
    this.api,
    this.notifier, {
    required this.documentId,
  }) : super(const SimilarDocumentsState()) {
    notifier.subscribe(
      this,
      onDeleted: remove,
      onUpdated: replace,
    );
  }

  Future<void> initialize() async {
    if (!state.hasLoaded) {
      await updateFilter(
        filter: state.filter.copyWith(moreLike: () => documentId),
      );
      emit(state.copyWith(hasLoaded: true));
    }
  }
}
