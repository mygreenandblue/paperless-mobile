import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/paged_document_view/cubit/document_paging_bloc_mixin.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/features/inbox/cubit/inbox_cubit.dart';

mixin DocumentPagingViewMixin<T extends StatefulWidget> on State<T> {
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

  DocumentPagingBlocMixin get _bloc => context.read<DocumentPagingBlocMixin>();

  void shouldLoadMoreDocumentsListener() async {
    if (shouldLoadMoreDocuments) {
      try {
        await _bloc.loadMore();
      } on PaperlessServerException catch (error, stackTrace) {
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
