import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/features/documents/view/widgets/adaptive_documents_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/documents_list_loading_widget.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/features/documents/view/widgets/documents_empty_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_list_item.dart';
import 'package:paperless_mobile/features/similar_documents/cubit/similar_documents_cubit.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/constants.dart';

class SimilarDocumentsView extends StatefulWidget {
  const SimilarDocumentsView({super.key});

  @override
  State<SimilarDocumentsView> createState() => _SimilarDocumentsViewState();
}

class _SimilarDocumentsViewState extends State<SimilarDocumentsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listenForLoadNewData);
    try {
      context.read<SimilarDocumentsCubit>().initialize();
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenForLoadNewData);
    super.dispose();
  }

  void _listenForLoadNewData() async {
    final currState = context.read<SimilarDocumentsCubit>().state;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.75 &&
        !currState.isLoading &&
        !currState.isLastPageLoaded) {
      try {
        await context.read<SimilarDocumentsCubit>().loadMore();
      } on PaperlessServerException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const earlyPreviewHintCard = HintCard(
      hintIcon: Icons.construction,
      hintText: "This view is still work in progress.",
    );
    return BlocBuilder<SimilarDocumentsCubit, SimilarDocumentsState>(
      builder: (context, state) {
        if (state.documents.isEmpty) {
          return DocumentsEmptyState(
            state: state,
            onReset: () => context.read<SimilarDocumentsCubit>().updateFilter(
                  filter: DocumentFilter.initial.copyWith(
                    moreLike: () =>
                        context.read<SimilarDocumentsCubit>().documentId,
                  ),
                ),
          );
        }

        return BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, connectivity) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverToBoxAdapter(child: earlyPreviewHintCard),
                SliverAdaptiveDocumentsView(
                  documents: state.documents,
                  hasInternetConnection: connectivity.isConnected,
                  isLabelClickable: false,
                  isLoading: state.isLoading,
                  hasLoaded: state.hasLoaded,

                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: state.documents.length,
                    (context, index) => DocumentListItem(
                      document: state.documents[index],
                      enableHeroAnimation: false,
                      isLabelClickable: false,
                      isSelected: false,
                      isSelectionActive: false,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
