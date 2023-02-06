import 'package:bloc/bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/notifier/document_changed_notifier.dart';
import 'package:paperless_mobile/features/paged_document_view/model/paged_documents_state.dart';
import 'package:paperless_mobile/features/paged_document_view/paged_documents_mixin.dart';

part 'saved_view_details_state.dart';

class SavedViewDetailsCubit extends Cubit<SavedViewDetailsState>
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
}
