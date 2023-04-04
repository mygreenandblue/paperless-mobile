import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/features/paged_document_view/cubit/paged_documents_state.dart';
import 'package:paperless_mobile/features/paged_document_view/cubit/document_paging_bloc_mixin.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';
part 'linked_documents_state.dart';

part 'linked_documents_cubit.g.dart';

class LinkedDocumentsCubit extends HydratedCubit<LinkedDocumentsState>
    with DocumentPagingBlocMixin {
  @override
  final PaperlessDocumentsApi api;

  @override
  final DocumentChangedNotifier notifier;

  final LabelRepository _labelRepository;

  LinkedDocumentsCubit(
    DocumentFilter filter,
    this.api,
    this.notifier,
    this._labelRepository,
  ) : super(const LinkedDocumentsState()) {
    updateFilter(filter: filter);
    _labelRepository.subscribe(
      this,
      onChanged: (labels) {
        emit(state.copyWith(
          correspondents: labels.correspondents,
          documentTypes: labels.documentTypes,
          tags: labels.tags,
          storagePaths: labels.storagePaths,
        ));
      },
    );
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

  void setViewType(ViewType type) {
    emit(state.copyWith(viewType: type));
  }

  @override
  LinkedDocumentsState? fromJson(Map<String, dynamic> json) {
    return LinkedDocumentsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(LinkedDocumentsState state) {
    return state.toJson();
  }
}
