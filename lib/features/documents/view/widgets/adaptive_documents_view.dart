import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/provider/label_repositories_provider.dart';
import 'package:paperless_mobile/features/documents/view/widgets/documents_list_loading_widget.dart';
import 'package:paperless_mobile/features/documents/bloc/documents_state.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_grid_item.dart';
import 'package:paperless_mobile/features/documents/view/widgets/items/document_list_item.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';

abstract class AdaptiveDocumentsView extends StatelessWidget {
  final List<DocumentModel> documents;
  final bool isLoading;
  final bool hasLoaded;
  final bool enableHeroAnimation;
  final List<int> selectedDocumentIds;
  final ViewType viewType;
  final void Function(DocumentModel)? onTap;
  final void Function(DocumentModel)? onSelected;
  final bool hasInternetConnection;
  final bool isLabelClickable;
  final void Function(int id)? onTagSelected;
  final void Function(int? id)? onCorrespondentSelected;
  final void Function(int? id)? onDocumentTypeSelected;
  final void Function(int? id)? onStoragePathSelected;

  const AdaptiveDocumentsView({
    super.key,
    this.selectedDocumentIds = const [],
    required this.documents,
    this.onTap,
    this.onSelected,
    this.viewType = ViewType.list,
    required this.hasInternetConnection,
    required this.isLabelClickable,
    this.onTagSelected,
    this.onCorrespondentSelected,
    this.onDocumentTypeSelected,
    this.onStoragePathSelected,
    required this.isLoading,
    required this.hasLoaded,
    this.enableHeroAnimation = true,
  });
}

class SliverAdaptiveDocumentsView extends AdaptiveDocumentsView {
  const SliverAdaptiveDocumentsView({
    super.key,
    required super.documents,
    required super.hasInternetConnection,
    required super.isLabelClickable,
    super.onCorrespondentSelected,
    super.onDocumentTypeSelected,
    super.onStoragePathSelected,
    super.onSelected,
    super.onTagSelected,
    super.onTap,
    super.selectedDocumentIds,
    super.viewType,
    required super.isLoading,
    required super.hasLoaded,
  });

  @override
  Widget build(BuildContext context) {
    switch (viewType) {
      case ViewType.grid:
        return _buildGridView();
      case ViewType.list:
        return _buildListView();
    }
  }

  Widget _buildListView() {
    if (!hasLoaded && isLoading) {
      return const DocumentsListLoadingWidget();
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: documents.length,
        (context, index) {
          final document = documents.elementAt(index);
          return LabelRepositoriesProvider(
            child: DocumentListItem(
              isLabelClickable: isLabelClickable,
              document: document,
              onTap: onTap,
              isSelected: selectedDocumentIds.contains(document.id),
              onSelected: onSelected,
              isSelectionActive: selectedDocumentIds.isNotEmpty,
              onTagSelected: onTagSelected,
              onCorrespondentSelected: onCorrespondentSelected,
              onDocumentTypeSelected: onDocumentTypeSelected,
              onStoragePathSelected: onStoragePathSelected,
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView() {
    if (!hasLoaded && isLoading) {
      return const DocumentsListLoadingWidget();
    }
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1 / 2,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents.elementAt(index);
        return DocumentGridItem(
          document: document,
          onTap: onTap,
          isSelected: selectedDocumentIds.contains(document.id),
          onSelected: onSelected,
          isSelectionActive: selectedDocumentIds.isNotEmpty,
          isLabelClickable: isLabelClickable,
          onTagSelected: onTagSelected,
          onCorrespondentSelected: onCorrespondentSelected,
          onDocumentTypeSelected: onDocumentTypeSelected,
          onStoragePathSelected: onStoragePathSelected,
          enableHeroAnimation: enableHeroAnimation,
        );
      },
    );
  }
}

class DefaultAdaptiveDocumentsView extends AdaptiveDocumentsView {
  final ScrollController? scrollController;
  const DefaultAdaptiveDocumentsView({
    super.key,
    required super.documents,
    required super.hasInternetConnection,
    required super.isLabelClickable,
    required super.isLoading,
    required super.hasLoaded,
    super.onCorrespondentSelected,
    super.onDocumentTypeSelected,
    super.onStoragePathSelected,
    super.onSelected,
    super.onTagSelected,
    super.onTap,
    this.scrollController,
    super.selectedDocumentIds,
    super.viewType,
    super.enableHeroAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (viewType) {
      case ViewType.grid:
        return _buildGridView();
      case ViewType.list:
        return _buildListView();
    }
  }

  Widget _buildListView() {
    if (!hasLoaded && isLoading) {
      return const CustomScrollView(slivers: [
        DocumentsListLoadingWidget(),
      ]);
    }

    return ListView.builder(
      controller: scrollController,
      primary: false,
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents.elementAt(index);
        return LabelRepositoriesProvider(
          child: DocumentListItem(
            isLabelClickable: isLabelClickable,
            document: document,
            onTap: onTap,
            isSelected: selectedDocumentIds.contains(document.id),
            onSelected: onSelected,
            isSelectionActive: selectedDocumentIds.isNotEmpty,
            onTagSelected: onTagSelected,
            onCorrespondentSelected: onCorrespondentSelected,
            onDocumentTypeSelected: onDocumentTypeSelected,
            onStoragePathSelected: onStoragePathSelected,
            enableHeroAnimation: enableHeroAnimation,
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    if (!hasLoaded && isLoading) {
      return const CustomScrollView(
        slivers: [
          DocumentsListLoadingWidget(),
        ],
      ); //TODO: Build grid skeleton
    }
    return GridView.builder(
      controller: scrollController,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1 / 2,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents.elementAt(index);
        return DocumentGridItem(
          document: document,
          onTap: onTap,
          isSelected: selectedDocumentIds.contains(document.id),
          onSelected: onSelected,
          isSelectionActive: selectedDocumentIds.isNotEmpty,
          isLabelClickable: isLabelClickable,
          onTagSelected: onTagSelected,
          onCorrespondentSelected: onCorrespondentSelected,
          onDocumentTypeSelected: onDocumentTypeSelected,
          onStoragePathSelected: onStoragePathSelected,
          enableHeroAnimation: enableHeroAnimation,
        );
      },
    );
  }
}
