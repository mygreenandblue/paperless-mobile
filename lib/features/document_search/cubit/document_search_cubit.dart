import 'package:collection/collection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/features/document_search/cubit/document_search_state.dart';
import 'package:paperless_mobile/features/paged_document_view/paged_documents_mixin.dart';

class DocumentSearchCubit extends HydratedCubit<DocumentSearchState>
    with PagedDocumentsMixin {
  @override
  final PaperlessDocumentsApi api;
  @override
  final DocumentChangedNotifier notifier;

  DocumentSearchCubit(this.api, this.notifier)
      : super(const DocumentSearchState());

  Future<void> search(String query) async {
    emit(state.copyWith(
      isLoading: true,
      suggestions: [],
      view: SearchView.results,
    ));
    final searchFilter = DocumentFilter(
      query: TextQuery.titleAndContent(query),
    );

    await updateFilter(filter: searchFilter);
    emit(
      state.copyWith(
        searchHistory: [
          query,
          ...state.searchHistory
              .whereNot((previousQuery) => previousQuery == query)
        ],
      ),
    );
  }

  Future<void> suggest(String query) async {
    emit(
      state.copyWith(
        isLoading: true,
        view: SearchView.suggestions,
        value: [],
        suggestions: [],
      ),
    );
    final suggestions = await api.autocomplete(query);
    emit(state.copyWith(
      suggestions: suggestions,
      isLoading: false,
    ));
  }

  void reset() {
    emit(state.copyWith(
      view: SearchView.suggestions,
      suggestions: [],
      isLoading: false,
    ));
  }

  @override
  DocumentSearchState? fromJson(Map<String, dynamic> json) {
    return DocumentSearchState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DocumentSearchState state) {
    return state.toJson();
  }
}
