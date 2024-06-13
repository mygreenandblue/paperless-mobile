import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/features/paged_document_view/cubit/document_paging_bloc_mixin.dart';
import 'package:edocs_mobile/helpers/message_helpers.dart';

mixin DocumentPagingViewMixin<T extends StatefulWidget,
    Bloc extends DocumentPagingBlocMixin> on State<T> {
  ScrollController get pagingScrollController;

  @override
  void initState() {
    super.initState();
    pagingScrollController.addListener(shouldLoadMoreDocumentsListener);
  }

  @override
  void dispose() {
    pagingScrollController.removeListener(shouldLoadMoreDocumentsListener);
    super.dispose();
  }

  DocumentPagingBlocMixin get _bloc => context.read<Bloc>();

  void shouldLoadMoreDocumentsListener() async {
    if (shouldLoadMoreDocuments) {
      try {
        await _bloc.loadMore();
      } on EdocsApiException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      }
    }
  }

  bool get shouldLoadMoreDocuments {
    final currState = _bloc.state;
    return pagingScrollController.position.maxScrollExtent != 0 &&
        !currState.isLoading &&
        !currState.isLastPageLoaded &&
        pagingScrollController.offset >=
            pagingScrollController.position.maxScrollExtent * 0.75;
  }
}
