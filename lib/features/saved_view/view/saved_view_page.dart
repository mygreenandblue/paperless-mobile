import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/repository/provider/label_repositories_provider.dart';
import 'package:paperless_mobile/features/document_details/bloc/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/document_details_page.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/documents_empty_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/confirm_delete_saved_view_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/view_actions.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_details_cubit.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routes/document_details_route.dart';

class SavedViewPage extends StatefulWidget {
  final Future<void> Function(SavedView savedView) onDelete;
  const SavedViewPage({
    super.key,
    required this.onDelete,
  });

  @override
  State<SavedViewPage> createState() => _SavedViewPageState();
}

class _SavedViewPageState extends State<SavedViewPage> {
  final _scrollController = ScrollController();
  ViewType _viewType = ViewType.list;
  SavedView get _savedView => context.read<SavedViewDetailsCubit>().savedView;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenForLoadNewData);
  }

  void _listenForLoadNewData() async {
    final currState = context.read<SavedViewDetailsCubit>().state;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.7 &&
        !currState.isLoading &&
        !currState.isLastPageLoaded) {
      try {
        await context.read<SavedViewDetailsCubit>().loadMore();
      } on PaperlessServerException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<SavedViewDetailsCubit, SavedViewDetailsState>(
          builder: (context, state) {
            return Text(_savedView.name);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) =>
                        ConfirmDeleteSavedViewDialog(view: _savedView),
                  ) ??
                  false;
              if (shouldDelete) {
                await widget.onDelete(_savedView);
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: Icon(
              _viewType == ViewType.list ? Icons.grid_view_rounded : Icons.list,
            ),
            onPressed: () => setState(() => _viewType = _viewType.toggle()),
          ),
        ],
      ),
      body: BlocBuilder<SavedViewDetailsCubit, SavedViewDetailsState>(
        builder: (context, state) {
          if (state.hasLoaded && state.documents.isEmpty) {
            return DocumentsEmptyState(state: state);
          }
          return BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, connectivity) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAdaptiveDocumentsView(
                    documents: state.documents,
                    hasInternetConnection: connectivity.isConnected,
                    isLabelClickable: false,
                    isLoading: state.isLoading,
                    hasLoaded: state.hasLoaded,
                    onTap: _onOpenDocumentDetails,
                    viewType: _viewType,
                  ),
                  if (state.hasLoaded && state.isLoading)
                    const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _onOpenDocumentDetails(DocumentModel document) {
    Navigator.pushNamed(
      context,
      DocumentDetailsRoute.routeName,
      arguments: DocumentDetailsRouteArguments(
        document: document,
        isLabelClickable: false,
      ),
    );
  }
}
