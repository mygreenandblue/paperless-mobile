import 'package:collection/collection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/paged_document_view/documents_paging_mixin.dart';

import 'document_search_state.dart';

class DocumentSearchCubit extends HydratedCubit<DocumentSearchState>
    with DocumentsPagingMixin {
  ////
  DocumentSearchCubit(this.api) : super(const DocumentSearchState());

  @override
  final PaperlessDocumentsApi api;

  ///
  /// Requests results based on [query] and adds [query] to the
  /// search history, removing old occurrences and trimming the list to
  /// the last 5 searches.
  ///
  Future<void> updateResults(String query) async {
    await updateFilter(
      filter: state.filter.copyWith(query: TextQuery.titleAndContent(query)),
    );
    emit(
      state.copyWith(
        searchHistory: [
          query,
          ...state.searchHistory.where((element) => element != query)
        ].take(5).toList(),
      ),
    );
  }

  void removeHistoryEntry(String suggestion) {
    emit(state.copyWith(
      searchHistory: state.searchHistory
          .whereNot((element) => element == suggestion)
          .toList(),
    ));
  }

  Future<List<String>> findSuggestions(String query) {
    return api.autocomplete(query);
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
