import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/documents_empty_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/confirm_delete_saved_view_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/view_type_selection_widget.dart';
import 'package:paperless_mobile/features/saved_view_details/cubit/saved_view_details_cubit.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routes/document_details_route.dart';

class SavedViewDetailsPage extends StatefulWidget {
  final Future<void> Function(SavedView savedView) onDelete;
  const SavedViewDetailsPage({
    super.key,
    required this.onDelete,
  });

  @override
  State<SavedViewDetailsPage> createState() => _SavedViewDetailsPageState();
}

class _SavedViewDetailsPageState extends State<SavedViewDetailsPage> {
  final _scrollController = ScrollController();

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
    final cubit = context.read<SavedViewDetailsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(cubit.savedView.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) =>
                        ConfirmDeleteSavedViewDialog(view: cubit.savedView),
                  ) ??
                  false;
              if (shouldDelete) {
                await widget.onDelete(cubit.savedView);
                Navigator.pop(context);
              }
            },
          ),
          BlocBuilder<SavedViewDetailsCubit, SavedViewDetailsState>(
            builder: (context, state) {
              return ViewTypeSelectionWidget(
                viewType: state.viewType,
                onChanged: cubit.setViewType,
              );
            },
          )
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
                    viewType: state.viewType,
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
