import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_api/src/modules/documents_api/paperless_documents_api.dart';
import 'package:paperless_mobile/features/paged_document_view/documents_paging_mixin.dart';

import 'document_search_state.dart';

class DocumentSearchCubit extends HydratedCubit<DocumentSearchState>
    with DocumentsPagingMixin {
  DocumentSearchCubit(this.api) : super(const DocumentSearchState());

  @override
  final PaperlessDocumentsApi api;

  Future<void> updateResults(String query) async {
    await updateFilter(
      filter: state.filter.copyWith(query: TextQuery.titleAndContent(query)),
    );
    emit(state.copyWith(searchHistory: [query, ...state.searchHistory]));
  }

  Future<void> updateSuggestions(String query) async {
    final suggestions = await api.autocomplete(query);
    emit(state.copyWith(suggestions: suggestions));
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
