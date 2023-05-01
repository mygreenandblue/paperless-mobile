import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/translation/error_code_localization_mapper.dart';
import 'package:paperless_mobile/core/widgets/material/colored_tab_bar.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_content_widget.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_download_button.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_meta_data_widget.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_overview_widget.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_share_button.dart';
import 'package:paperless_mobile/features/document_edit/cubit/document_edit_cubit.dart';
import 'package:paperless_mobile/features/document_edit/view/document_edit_page.dart';
import 'package:paperless_mobile/features/documents/view/pages/document_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/delete_document_confirmation_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/similar_documents/cubit/similar_documents_cubit.dart';
import 'package:paperless_mobile/features/similar_documents/view/similar_documents_view.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class DocumentDetailsPage extends StatefulWidget {
  final bool allowEdit;
  final bool isLabelClickable;
  final String? titleAndContentQueryString;

  const DocumentDetailsPage({
    Key? key,
    this.isLabelClickable = true,
    this.titleAndContentQueryString,
    this.allowEdit = true,
  }) : super(key: key);

  @override
  State<DocumentDetailsPage> createState() => _DocumentDetailsPageState();
}

class _DocumentDetailsPageState extends State<DocumentDetailsPage> {
  static const double _itemSpacing = 24;

  final _pagingScrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(context.read<DocumentDetailsCubit>().state.document);
        return false;
      },
      child: DefaultTabController(
        length: 4,
        child: BlocListener<ConnectivityCubit, ConnectivityState>(
          listenWhen: (previous, current) => !previous.isConnected && current.isConnected,
          listener: (context, state) {
            context.read<DocumentDetailsCubit>().loadMetaData();
          },
          child: Scaffold(
            extendBodyBehindAppBar: false,
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            floatingActionButton: widget.allowEdit ? _buildEditButton() : null,
            bottomNavigationBar: _buildBottomAppBar(),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    title: Text(context.watch<DocumentDetailsCubit>().state.document.title),
                    leading: const BackButton(),
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    collapsedHeight: kToolbarHeight,
                    expandedHeight: 250.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
                            builder: (context, state) => Positioned.fill(
                              child: DocumentPreview(
                                document: state.document,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned.fill( 
                            top: 0,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.black.withOpacity(0.2),
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
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
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              S.of(context)!.content,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              S.of(context)!.metaData,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              S.of(context)!.similarDocuments,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
                                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
                                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
                                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                              ),
                              SimilarDocumentsView(
                                pagingScrollController: _pagingScrollController,
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
    return BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
      builder: (context, state) {
        // final _filteredSuggestions =
        //     state.suggestions?.documentDifference(state.document);
        return BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, connectivityState) {
            if (!connectivityState.isConnected) {
              return const SizedBox.shrink();
            }
            return Tooltip(
              message: S.of(context)!.editDocumentTooltip,
              preferBelow: false,
              verticalOffset: 40,
              child: FloatingActionButton(
                child: const Icon(Icons.edit),
                onPressed: () => _onEdit(state.document),
              ),
            );
          },
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
              final isConnected = connectivityState.isConnected;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    tooltip: S.of(context)!.deleteDocumentTooltip,
                    icon: const Icon(Icons.delete),
                    onPressed:
                        widget.allowEdit && isConnected ? () => _onDelete(state.document) : null,
                  ).paddedSymmetrically(horizontal: 4),
                  DocumentDownloadButton(
                    document: state.document,
                    enabled: isConnected,
                  ),
                  IconButton(
                    tooltip: S.of(context)!.previewTooltip,
                    icon: const Icon(Icons.visibility),
                    onPressed: isConnected ? () => _onOpen(state.document) : null,
                  ).paddedOnly(right: 4.0),
                  IconButton(
                    tooltip: S.of(context)!.openInSystemViewer,
                    icon: const Icon(Icons.open_in_new),
                    onPressed: isConnected ? _onOpenFileInSystemViewer : null,
                  ).paddedOnly(right: 4.0),
                  DocumentShareButton(document: state.document),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _onEdit(DocumentModel document) async {
    {
      final cubit = context.read<DocumentDetailsCubit>();
      Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: DocumentEditCubit(
                  context.read(),
                  context.read(),
                  context.read(),
                  document: document,
                ),
              ),
              BlocProvider<DocumentDetailsCubit>.value(
                value: cubit,
              ),
            ],
            child: BlocListener<DocumentEditCubit, DocumentEditState>(
              listenWhen: (previous, current) => previous.document != current.document,
              listener: (context, state) {
                cubit.replace(state.document);
              },
              child: BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
                builder: (context, state) {
                  return DocumentEditPage(
                    suggestions: state.suggestions,
                  );
                },
              ),
            ),
          ),
          maintainState: true,
        ),
      );
    }
  }

  void _onOpenFileInSystemViewer() async {
    final status = await context.read<DocumentDetailsCubit>().openDocumentInSystemViewer();
    if (status == ResultType.done) return;
    if (status == ResultType.noAppToOpen) {
      showGenericError(context, S.of(context)!.noAppToDisplayPDFFilesFound);
    }
    if (status == ResultType.fileNotFound) {
      showGenericError(context, translateError(context, ErrorCode.unknown));
    }
    if (status == ResultType.permissionDenied) {
      showGenericError(context, S.of(context)!.couldNotOpenFilePermissionDenied);
    }
  }

  void _onDelete(DocumentModel document) async {
    final delete = await showDialog(
          context: context,
          builder: (context) => DeleteDocumentConfirmationDialog(document: document),
        ) ??
        false;
    if (delete) {
      try {
        await context.read<DocumentDetailsCubit>().delete(document);
        showSnackBar(context, S.of(context)!.documentSuccessfullyDeleted);
      } on PaperlessServerException catch (error, stackTrace) {
        showErrorMessage(context, error, stackTrace);
      } finally {
        // Document deleted => go back to primary route
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  Future<void> _onOpen(DocumentModel document) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentView(
          documentBytes: context.read<PaperlessDocumentsApi>().getPreview(document.id),
        ),
      ),
    );
  }
}
