import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/translation/error_code_localization_mapper.dart';
import 'package:paperless_mobile/core/widgets/material/colored_tab_bar.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_content_widget.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_download_button.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_meta_data_widget.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_overview_widget.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_permissions_widget.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_share_button.dart';
import 'package:paperless_mobile/features/documents/view/widgets/delete_document_confirmation_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/similar_documents/cubit/similar_documents_cubit.dart';
import 'package:paperless_mobile/features/similar_documents/view/similar_documents_view.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/connectivity_aware_action_wrapper.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routes/typed/branches/documents_route.dart';

class DocumentDetailsPage extends StatefulWidget {
  final bool isLabelClickable;
  final String? titleAndContentQueryString;

  const DocumentDetailsPage({
    Key? key,
    this.isLabelClickable = true,
    this.titleAndContentQueryString,
  }) : super(key: key);

  @override
  State<DocumentDetailsPage> createState() => _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends State<DocumentDetailsPage> {
  static const double _itemSpacing = 24;

  final _pagingScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final hasMultiUserSupport =
        context.watch<LocalUserAccount>().hasMultiUserSupport;
    final tabLength = 4 + (hasMultiUserSupport ? 1 : 0);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pop(context.read<DocumentDetailsCubit>().state.document);
        return false;
      },
      child: DefaultTabController(
        length: tabLength,
        child: BlocListener<ConnectivityCubit, ConnectivityState>(
          listenWhen: (previous, current) =>
              !previous.isConnected && current.isConnected,
          listener: (context, state) {
            context.read<DocumentDetailsCubit>().loadMetaData();
          },
          child: Scaffold(
            extendBodyBehindAppBar: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: _buildEditButton(),
            bottomNavigationBar: _buildBottomAppBar(),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    title: Text(context
                        .watch<DocumentDetailsCubit>()
                        .state
                        .document
                        .title),
                    leading: const BackButton(),
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    collapsedHeight: kToolbarHeight,
                    expandedHeight: 250.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          BlocBuilder<DocumentDetailsCubit,
                              DocumentDetailsState>(
                            builder: (context, state) {
                              return Positioned.fill(
                                child: GestureDetector(
                                  onTap: () {
                                    DocumentPreviewRoute($extra: state.document)
                                        .push(context);
                                  },
                                  child: DocumentPreview(
                                    document: state.document,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Positioned.fill(
                          //   top: -kToolbarHeight,
                          //   child: DecoratedBox(
                          //     decoration: BoxDecoration(
                          //       gradient: LinearGradient(
                          //         colors: [
                          //           Theme.of(context)
                          //               .colorScheme
                          //               .background
                          //               .withOpacity(0.8),
                          //           Theme.of(context)
                          //               .colorScheme
                          //               .background
                          //               .withOpacity(0.5),
                          //           Colors.transparent,
                          //           Colors.transparent,
                          //           Colors.transparent,
                          //         ],
                          //         begin: Alignment.topCenter,
                          //         end: Alignment.bottomCenter,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    bottom: ColoredTabBar(
                      tabBar: TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(
                            child: Text(
                              S.of(context)!.overview,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              S.of(context)!.content,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              S.of(context)!.metaData,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              S.of(context)!.similarDocuments,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                          if (hasMultiUserSupport)
                            Tab(
                              child: Text(
                                "Permissions",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              body: BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
                builder: (context, state) {
                  return BlocProvider(
                    create: (context) => SimilarDocumentsCubit(
                      context.read(),
                      context.read(),
                      context.read(),
                      context.read(),
                      documentId: state.document.id,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: TabBarView(
                        children: [
                          CustomScrollView(
                            slivers: [
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              DocumentOverviewWidget(
                                document: state.document,
                                itemSpacing: _itemSpacing,
                                queryString: widget.titleAndContentQueryString,
                                availableCorrespondents: state.correspondents,
                                availableDocumentTypes: state.documentTypes,
                                availableTags: state.tags,
                                availableStoragePaths: state.storagePaths,
                              ),
                            ],
                          ),
                          CustomScrollView(
                            slivers: [
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              DocumentContentWidget(
                                isFullContentLoaded: state.isFullContentLoaded,
                                document: state.document,
                                fullContent: state.fullContent,
                                queryString: widget.titleAndContentQueryString,
                              ),
                            ],
                          ),
                          CustomScrollView(
                            slivers: [
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              DocumentMetaDataWidget(
                                document: state.document,
                                itemSpacing: _itemSpacing,
                              ),
                            ],
                          ),
                          CustomScrollView(
                            controller: _pagingScrollController,
                            slivers: [
                              SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context),
                              ),
                              SimilarDocumentsView(
                                pagingScrollController: _pagingScrollController,
                              ),
                            ],
                          ),
                          if (hasMultiUserSupport)
                            CustomScrollView(
                              controller: _pagingScrollController,
                              slivers: [
                                SliverOverlapInjector(
                                  handle: NestedScrollView
                                      .sliverOverlapAbsorberHandleFor(context),
                                ),
                                DocumentPermissionsWidget(
                                  document: state.document,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    final currentUser = context.watch<LocalUserAccount>();

    bool canEdit = context.watchInternetConnection &&
        currentUser.paperlessUser.canEditDocuments;
    if (!canEdit) {
      return const SizedBox.shrink();
    }
    return BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
      builder: (context, state) {
        // final _filteredSuggestions =
        //     state.suggestions?.documentDifference(state.document);

        return Tooltip(
          message: S.of(context)!.editDocumentTooltip,
          preferBelow: false,
          verticalOffset: 40,
          child: FloatingActionButton(
            heroTag: "fab_document_details",
            child: const Icon(Icons.edit),
            onPressed: () => EditDocumentRoute(state.document).push(context),
          ),
        );
      },
    );
  }

  BlocBuilder<DocumentDetailsCubit, DocumentDetailsState> _buildBottomAppBar() {
    return BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
      builder: (context, state) {
        return BottomAppBar(
          child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, connectivityState) {
              final currentUser = context.watch<LocalUserAccount>();
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConnectivityAwareActionWrapper(
                    disabled: !currentUser.paperlessUser.canDeleteDocuments,
                    offlineBuilder: (context, child) {
                      return const IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: null,
                      ).paddedSymmetrically(horizontal: 4);
                    },
                    child: IconButton(
                      tooltip: S.of(context)!.deleteDocumentTooltip,
                      icon: const Icon(Icons.delete),
                      onPressed: () => _onDelete(state.document),
                    ).paddedSymmetrically(horizontal: 4),
                  ),
                  ConnectivityAwareActionWrapper(
                    offlineBuilder: (context, child) =>
                        const DocumentDownloadButton(
                      document: null,
                      enabled: false,
                    ),
                    child: DocumentDownloadButton(
                      document: state.document,
                    ),
                  ),
                  ConnectivityAwareActionWrapper(
                    offlineBuilder: (context, child) => const IconButton(
                      icon: Icon(Icons.open_in_new),
                      onPressed: null,
                    ),
                    child: IconButton(
                      tooltip: S.of(context)!.openInSystemViewer,
                      icon: const Icon(Icons.open_in_new),
                      onPressed: _onOpenFileInSystemViewer,
                    ).paddedOnly(right: 4.0),
                  ),
                  DocumentShareButton(document: state.document),
                  IconButton(
                    tooltip: S.of(context)!.print,
                    onPressed: () =>
                        context.read<DocumentDetailsCubit>().printDocument(),
                    icon: const Icon(Icons.print),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _onOpenFileInSystemViewer() async {
    final status =
        await context.read<DocumentDetailsCubit>().openDocumentInSystemViewer();
    if (status == ResultType.done) return;
    if (status == ResultType.noAppToOpen) {
      showGenericError(context, S.of(context)!.noAppToDisplayPDFFilesFound);
    }
    if (status == ResultType.fileNotFound) {
      showGenericError(context, translateError(context, ErrorCode.unknown));
    }
    if (status == ResultType.permissionDenied) {
      showGenericError(
          context, S.of(context)!.couldNotOpenFilePermissionDenied);
    }
  }

  void _onDelete(DocumentModel document) async {
    final delete = await showDialog(
          context: context,
          builder: (context) =>
              DeleteDocumentConfirmationDialog(document: document),
        ) ??
        false;
    if (delete) {
      try {
        await context.read<DocumentDetailsCubit>().delete(document);
        showSnackBar(context, S.of(context)!.documentSuccessfullyDeleted);
      } on PaperlessApiException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      } finally {
        do {
          context.pop();
        } while (context.canPop());
      }
    }
  }

  Future<void> _onOpen(DocumentModel document) async {
    DocumentPreviewRoute(
      $extra: document,
      title: document.title,
    ).push(context);
  }
}
