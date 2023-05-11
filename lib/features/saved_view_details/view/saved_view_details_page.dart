import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/navigation/push_routes.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/documents_empty_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/confirm_delete_saved_view_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/selection/view_type_selection_widget.dart';
import 'package:paperless_mobile/features/paged_document_view/view/document_paging_view_mixin.dart';
import 'package:paperless_mobile/features/saved_view_details/cubit/saved_view_details_cubit.dart';

class SavedViewDetailsPage extends StatefulWidget {
  final Future<void> Function(SavedView savedView) onDelete;
  const SavedViewDetailsPage({
    super.key,
    required this.onDelete,
  });

  @override
  State<SavedViewDetailsPage> createState() => _SavedViewDetailsPageState();
}

class _SavedViewDetailsPageState extends State<SavedViewDetailsPage>
    with DocumentPagingViewMixin<SavedViewDetailsPage, SavedViewDetailsCubit> {
  @override
  final pagingScrollController = ScrollController();

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
                    builder: (context) => ConfirmDeleteSavedViewDialog(
                      view: cubit.savedView,
                    ),
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
                controller: pagingScrollController,
                slivers: [
                  SliverAdaptiveDocumentsView(
                    documents: state.documents,
                    hasInternetConnection: connectivity.isConnected,
                    isLabelClickable: false,
                    isLoading: state.isLoading,
                    hasLoaded: state.hasLoaded,
                    onTap: (document) {
                      pushDocumentDetailsRoute(
                        context,
                        document: document,
                        isLabelClickable: false,
                      );
                    },
                    viewType: state.viewType,
                    correspondents: state.correspondents,
                    documentTypes: state.documentTypes,
                    tags: state.tags,
                    storagePaths: state.storagePaths,
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
}
