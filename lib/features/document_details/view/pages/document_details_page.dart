import 'dart:io';

import 'package:badges/badges.dart' as b;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/translation/error_code_localization_mapper.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_content_widget.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_download_button.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_meta_data_widget.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_overview_widget.dart';
import 'package:paperless_mobile/features/document_edit/cubit/document_edit_cubit.dart';
import 'package:paperless_mobile/features/document_edit/view/document_edit_page.dart';
import 'package:paperless_mobile/features/documents/view/pages/document_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/delete_document_confirmation_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/similar_documents/cubit/similar_documents_cubit.dart';
import 'package:paperless_mobile/features/similar_documents/view/similar_documents_view.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

//TODO: Refactor this into several widgets
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
  late Future<DocumentMetaData> _metaData;
  static const double _itemPadding = 24;
  @override
  void initState() {
    super.initState();
    _loadMetaData();
  }

  void _loadMetaData() {
    _metaData = context
        .read<PaperlessDocumentsApi>()
        .getMetaData(context.read<DocumentDetailsCubit>().state.document);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pop(context.read<DocumentDetailsCubit>().state.document);
        return false;
      },
      child: DefaultTabController(
        length: 4,
        child: BlocListener<ConnectivityCubit, ConnectivityState>(
          listenWhen: (previous, current) =>
              !previous.isConnected && current.isConnected,
          listener: (context, state) {
            _loadMetaData();
            setState(() {});
          },
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: widget.allowEdit ? _buildEditButton() : null,
            bottomNavigationBar: _buildBottomAppBar(),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  leading: const BackButton(),
                  floating: true,
                  pinned: true,
                  expandedHeight: 200.0,
                  flexibleSpace:
                      BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
                    builder: (context, state) => DocumentPreview(
                      document: state.document,
                      fit: BoxFit.cover,
                    ),
                  ),
                  bottom: ColoredTabBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    tabBar: TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(
                          child: Text(
                            S.of(context).documentDetailsPageTabOverviewLabel,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            S.of(context).documentDetailsPageTabContentLabel,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            S.of(context).documentDetailsPageTabMetaDataLabel,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            S
                                .of(context)
                                .documentDetailsPageTabSimilarDocumentsLabel,
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
              ],
              body: BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
                builder: (context, state) {
                  return BlocProvider(
                    create: (context) => SimilarDocumentsCubit(
                      context.read(),
                      context.read(),
                      documentId: state.document.id,
                    ),
                    child: TabBarView(
                      children: [
                        DocumentOverviewWidget(
                          document: state.document,
                          itemSpacing: _itemPadding,
                          queryString: widget.titleAndContentQueryString,
                        ),
                        DocumentContentWidget(
                          isFullContentLoaded: state.isFullContentLoaded,
                          document: state.document,
                          fullContent: state.fullContent,
                          queryString: widget.titleAndContentQueryString,
                        ),
                        DocumentMetaDataWidget(
                          document: state.document,
                          itemSpacing: _itemPadding,
                          metaData: _metaData,
                        ),
                        const SimilarDocumentsView(),
                      ],
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
        final _filteredSuggestions =
            state.suggestions.documentDifference(state.document);
        return BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, connectivityState) {
            if (!connectivityState.isConnected) {
              return const SizedBox.shrink();
            }
            return b.Badge(
              position: b.BadgePosition.topEnd(top: -12, end: -6),
              showBadge: _filteredSuggestions.hasSuggestions,
              child: Tooltip(
                message: S.of(context).documentDetailsPageEditTooltip,
                preferBelow: false,
                verticalOffset: 40,
                child: FloatingActionButton(
                  child: const Icon(Icons.edit),
                  onPressed: () => _onEdit(state.document),
                ),
              ),
              badgeContent: Text(
                '${_filteredSuggestions.suggestionsCount}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              badgeColor: Colors.red,
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
                    tooltip: S.of(context).documentDetailsPageDeleteTooltip,
                    icon: const Icon(Icons.delete),
                    onPressed: widget.allowEdit && isConnected
                        ? () => _onDelete(state.document)
                        : null,
                  ).paddedSymmetrically(horizontal: 4),
                  Tooltip(
                    message: S.of(context).documentDetailsPageDownloadTooltip,
                    child: DocumentDownloadButton(
                      document: state.document,
                      enabled: isConnected,
                      metaData: _metaData,
                    ),
                  ),
                  IconButton(
                    tooltip: S.of(context).documentDetailsPagePreviewTooltip,
                    icon: const Icon(Icons.visibility),
                    onPressed:
                        isConnected ? () => _onOpen(state.document) : null,
                  ).paddedOnly(right: 4.0),
                  IconButton(
                    tooltip: S
                        .of(context)
                        .documentDetailsPageOpenInSystemViewerTooltip,
                    icon: const Icon(Icons.open_in_new),
                    onPressed: isConnected ? _onOpenFileInSystemViewer : null,
                  ).paddedOnly(right: 4.0),
                  IconButton(
                    tooltip: S.of(context).documentDetailsPageShareTooltip,
                    icon: const Icon(Icons.share),
                    onPressed: isConnected
                        ? () =>
                            context.read<DocumentDetailsCubit>().shareDocument()
                        : null,
                  ),
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
                  document,
                  documentsApi: context.read(),
                  correspondentRepository: context.read(),
                  documentTypeRepository: context.read(),
                  storagePathRepository: context.read(),
                  tagRepository: context.read(),
                  notifier: context.read(),
                ),
              ),
              BlocProvider<DocumentDetailsCubit>.value(
                value: cubit,
              ),
            ],
            child: BlocListener<DocumentEditCubit, DocumentEditState>(
              listenWhen: (previous, current) =>
                  previous.document != current.document,
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
    final status =
        await context.read<DocumentDetailsCubit>().openDocumentInSystemViewer();
    if (status == ResultType.done) return;
    if (status == ResultType.noAppToOpen) {
      showGenericError(context,
          S.of(context).documentDetailsPageNoPdfViewerFoundErrorMessage);
    }
    if (status == ResultType.fileNotFound) {
      showGenericError(context, translateError(context, ErrorCode.unknown));
    }
    if (status == ResultType.permissionDenied) {
      showGenericError(context,
          S.of(context).documentDetailsPageOpenPdfPermissionDeniedErrorMessage);
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
        showSnackBar(context, S.of(context).documentDeleteSuccessMessage);
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
          documentBytes:
              context.read<PaperlessDocumentsApi>().getPreview(document.id),
        ),
      ),
    );
  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar({
    super.key,
    required this.backgroundColor,
    required this.tabBar,
  });

  final TabBar tabBar;
  final Color backgroundColor;
  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundColor,
        child: tabBar,
      );
}
