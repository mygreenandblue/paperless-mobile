import 'package:bloc/bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/paged_document_view/paged_documents_mixin.dart';
import 'package:paperless_mobile/features/paged_document_view/model/paged_documents_state.dart';

part 'similar_documents_state.dart';

class SimilarDocumentsCubit extends Cubit<SimilarDocumentsState>
    with PagedDocumentsMixin<SimilarDocumentsState> {
  final int documentId;

  @override
  final PaperlessDocumentsApi api;

  SimilarDocumentsCubit(
    this.api, {
    required this.documentId,
  }) : super(const SimilarDocumentsState());

  Future<void> initialize() async {
    if (!state.hasLoaded) {
      await updateFilter(
        filter: state.filter.copyWith(moreLike: () => documentId),
      );
      emit(state.copyWith(hasLoaded: true));
    }
  }
}
