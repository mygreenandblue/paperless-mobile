import 'package:collection/collection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/database/tables/user_account.dart';
import 'package:paperless_mobile/features/paged_document_view/cubit/document_paging_bloc_mixin.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/features/paged_document_view/cubit/paged_documents_state.dart';
import 'package:paperless_mobile/core/database/tables/user_settings.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';

part 'document_search_state.dart';
part 'document_search_cubit.g.dart';

class DocumentSearchCubit extends HydratedCubit<DocumentSearchState> with DocumentPagingBlocMixin {
  @override
  final PaperlessDocumentsApi api;

  final LabelRepository _labelRepository;
  @override
  final DocumentChangedNotifier notifier;
  DocumentSearchCubit(this.api, this.notifier, this._labelRepository)
      : super(const DocumentSearchState()) {
    _labelRepository.addListener(
      this,
      onChanged: (labels) {
        emit(
          state.copyWith(
            correspondents: labels.correspondents,
            documentTypes: labels.documentTypes,
            tags: labels.tags,
            storagePaths: labels.storagePaths,
          ),
        );
      },
    );
    notifier.addListener(
      this,
      onDeleted: remove,
      onUpdated: replace,
    );
  }

  Future<void> search(String query) async {
    emit(state.copyWith(
      isLoading: true,
      suggestions: [],
      view: SearchView.results,
    ));
    final searchFilter = DocumentFilter(
      query: TextQuery.extended(query),
    );

    await updateFilter(filter: searchFilter);
    emit(
      state.copyWith(
        searchHistory: [
          query,
          ...state.searchHistory.whereNot((previousQuery) => previousQuery == query)
        ],
      ),
    );
  }

  void updateViewType(ViewType viewType) {
    emit(state.copyWith(viewType: viewType));
  }

  void removeHistoryEntry(String entry) {
    emit(
      state.copyWith(
        searchHistory: state.searchHistory.whereNot((element) => element == entry).toList(),
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
  Future<void> close() {
    notifier.removeListener(this);
    _labelRepository.removeListener(this);
    return super.close();
  }

  @override
  DocumentSearchState? fromJson(Map<String, dynamic> json) {
    return DocumentSearchState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DocumentSearchState state) {
    return state.toJson();
  }

  @override
  Future<void> onFilterUpdated(DocumentFilter filter) async {}
}
