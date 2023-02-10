import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/features/paged_document_view/model/paged_documents_state.dart';
import 'package:paperless_mobile/features/paged_document_view/paged_documents_mixin.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';

part 'saved_view_details_cubit.g.dart';
part 'saved_view_details_state.dart';

class SavedViewDetailsCubit extends HydratedCubit<SavedViewDetailsState>
    with PagedDocumentsMixin {
  @override
  final PaperlessDocumentsApi api;

  @override
  final DocumentChangedNotifier notifier;

  final SavedView savedView;
  SavedViewDetailsCubit(
    this.api,
    this.notifier, {
    required this.savedView,
  }) : super(const SavedViewDetailsState()) {
    notifier.subscribe(
      this,
      onDeleted: remove,
      onUpdated: replace,
    );
    updateFilter(filter: savedView.toDocumentFilter());
  }

  void setViewType(ViewType viewType) {
    emit(state.copyWith(viewType: viewType));
  }

  @override
  SavedViewDetailsState? fromJson(Map<String, dynamic> json) {
    return SavedViewDetailsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SavedViewDetailsState state) {
    return state.toJson();
  }
}
