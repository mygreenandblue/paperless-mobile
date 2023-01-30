import 'package:bloc/bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/paged_document_view/model/paged_documents_state.dart';
import 'package:paperless_mobile/features/paged_document_view/paged_documents_mixin.dart';

part 'saved_view_details_state.dart';

class SavedViewDetailsCubit extends Cubit<SavedViewDetailsState>
    with PagedDocumentsMixin {
  @override
  final PaperlessDocumentsApi api;

  final SavedView savedView;
  SavedViewDetailsCubit(
    this.api, {
    required this.savedView,
  }) : super(const SavedViewDetailsState()) {
    updateFilter(filter: savedView.toDocumentFilter());
  }
}
