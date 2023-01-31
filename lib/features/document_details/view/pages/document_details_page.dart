import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/repository/state/impl/correspondent_repository_state.dart';
import 'package:paperless_mobile/core/translation/error_code_localization_mapper.dart';
import 'package:paperless_mobile/core/widgets/highlighted_text.dart';
import 'package:paperless_mobile/core/widgets/offline_widget.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/bloc/document_details_cubit.dart';
import 'package:paperless_mobile/features/document_details/view/pages/similar_documents_view.dart';
import 'package:paperless_mobile/features/document_details/view/widgets/document_download_button.dart';
import 'package:paperless_mobile/features/documents/view/pages/document_edit_page.dart';
import 'package:paperless_mobile/features/documents/view/pages/document_view.dart';
import 'package:paperless_mobile/features/documents/view/widgets/delete_document_confirmation_dialog.dart';
import 'package:paperless_mobile/features/documents/view/widgets/document_preview.dart';
import 'package:paperless_mobile/features/edit_document/cubit/edit_document_cubit.dart';
import 'package:paperless_mobile/features/labels/storage_path/view/widgets/storage_path_widget.dart';
import 'package:paperless_mobile/features/labels/tags/view/widgets/tags_widget.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_text.dart';
import 'package:paperless_mobile/features/similar_documents/cubit/similar_documents_cubit.dart';
import 'package:paperless_mobile/generated/l10n.dart';
import 'package:paperless_mobile/helpers/format_helpers.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:badges/badges.dart' as b;

import '../../../../core/repository/state/impl/document_type_repository_state.dart';

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

  @override
  void initState() {
    super.initState();
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
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: widget.allowEdit ? _buildAppBar() : null,
          bottomNavigationBar: _buildBottomAppBar(),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors
                        .black, //TODO: check if there is a way to dynamically determine color...
                  ),
                  onPressed: () => Navigator.of(context).pop(
                    context.read<DocumentDetailsCubit>().state.document,
                  ),
                ),
                floating: true,
                pinned: true,
                expandedHeight: 200.0,
                flexibleSpace:
                    BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
                  builder: (context, state) => DocumentPreview(
                    id: state.document.id,
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
                                  .onPrimaryContainer),
                        ),
                      ),
                      Tab(
                        child: Text(
                          S.of(context).documentDetailsPageTabContentLabel,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        ),
                      ),
                      Tab(
                        child: Text(
                          S.of(context).documentDetailsPageTabMetaDataLabel,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
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
                    documentId: state.document.id,
                  ),
                  child: TabBarView(
                    children: [
                      _buildDocumentOverview(
                        state.document,
                      ),
                      _buildDocumentContentView(
                        state.document,
                        state,
                      ),
                      _buildDocumentMetaDataView(
                        state.document,
                      ),
                      _buildSimilarDocumentsView(),
                    ],
                  ),
                ).paddedSymmetrically(horizontal: 8);
              },
            ),
          ),
        ),
      ),
    );
  }

  BlocBuilder<DocumentDetailsCubit, DocumentDetailsState> _buildAppBar() {
    return BlocBuilder<DocumentDetailsCubit, DocumentDetailsState>(
      builder: (context, state) {
        final _filteredSuggestions =
            state.suggestions.documentDifference(state.document);
        return BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, connectivityState) {
            if (!connectivityState.isConnected) {
              return Container();
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
                    onPressed:
                        isConnected ? () => _onShare(state.document) : null,
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
                value: EditDocumentCubit(
                  document,
                  documentsApi: context.read(),
                  correspondentRepository: context.read(),
                  documentTypeRepository: context.read(),
                  storagePathRepository: context.read(),
                  tagRepository: context.read(),
                ),
              ),
              BlocProvider<DocumentDetailsCubit>.value(
                value: cubit,
              ),
            ],
            child: BlocListener<EditDocumentCubit, EditDocumentState>(
              listenWhen: (previous, current) =>
                  previous.document != current.document,
              listener: (context, state) {
                cubit.replaceDocument(state.document);
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

  Widget _buildDocumentMetaDataView(DocumentModel document) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        if (!state.isConnected) {
          return const Center(
            child: OfflineWidget(),
          );
        }
        return FutureBuilder<DocumentMetaData>(
          future: _metaData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final meta = snapshot.data!;
            return ListView(
              children: [
                _DetailsItem.text(DateFormat().format(document.modified),
                        label: S.of(context).documentModifiedPropertyLabel,
                        context: context)
                    .paddedOnly(bottom: 16),
                _DetailsItem.text(DateFormat().format(document.added),
                        label: S.of(context).documentAddedPropertyLabel,
                        context: context)
                    .paddedSymmetrically(vertical: 16),
                _DetailsItem(
                  label: S
                      .of(context)
                      .documentArchiveSerialNumberPropertyLongLabel,
                  content: document.archiveSerialNumber != null
                      ? Text(document.archiveSerialNumber.toString())
                      : TextButton.icon(
                          icon: const Icon(Icons.archive_outlined),
                          label: Text(S
                              .of(context)
                              .documentDetailsPageAssignAsnButtonLabel),
                          onPressed: widget.allowEdit
                              ? () => _assignAsn(document)
                              : null,
                        ),
                ).paddedSymmetrically(vertical: 16),
                _DetailsItem.text(
                  meta.mediaFilename,
                  context: context,
                  label:
                      S.of(context).documentMetaDataMediaFilenamePropertyLabel,
                ).paddedSymmetrically(vertical: 16),
                _DetailsItem.text(
                  meta.originalChecksum,
                  context: context,
                  label: S.of(context).documentMetaDataChecksumLabel,
                ).paddedSymmetrically(vertical: 16),
                _DetailsItem.text(formatBytes(meta.originalSize, 2),
                        label:
                            S.of(context).documentMetaDataOriginalFileSizeLabel,
                        context: context)
                    .paddedSymmetrically(vertical: 16),
                _DetailsItem.text(
                  meta.originalMimeType,
                  label: S.of(context).documentMetaDataOriginalMimeTypeLabel,
                  context: context,
                ).paddedSymmetrically(vertical: 16),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _assignAsn(DocumentModel document) async {
    try {
      await context.read<DocumentDetailsCubit>().assignAsn(document);
    } on PaperlessServerException catch (error, stackTrace) {
      showErrorMessage(context, error, stackTrace);
    }
  }

  Widget _buildDocumentContentView(
    DocumentModel document,
    DocumentDetailsState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HighlightedText(
            text: (state.isFullContentLoaded
                    ? state.fullContent
                    : document.content) ??
                "",
            highlights: widget.titleAndContentQueryString != null
                ? widget.titleAndContentQueryString!.split(" ")
                : [],
            style: Theme.of(context).textTheme.bodyMedium,
            caseSensitive: false,
          ),
          if (!state.isFullContentLoaded && (document.content ?? '').isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                child:
                    Text(S.of(context).documentDetailsPageLoadFullContentLabel),
                onPressed: () {
                  context.read<DocumentDetailsCubit>().loadFullContent();
                },
              ),
            ),
        ],
      ).padded(8).paddedOnly(top: 14),
    );
  }

  Widget _buildDocumentOverview(DocumentModel document) {
    return ListView(
      children: [
        _DetailsItem(
          label: S.of(context).documentTitlePropertyLabel,
          content: HighlightedText(
            text: document.title,
            highlights: widget.titleAndContentQueryString?.split(" ") ?? [],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ).paddedOnly(bottom: 16),
        _DetailsItem.text(
          DateFormat.yMMMMd().format(document.created),
          context: context,
          label: S.of(context).documentCreatedPropertyLabel,
        ).paddedSymmetrically(vertical: 16),
        Visibility(
          visible: document.documentType != null,
          child: _DetailsItem(
            label: S.of(context).documentDocumentTypePropertyLabel,
            content: LabelText<DocumentType, DocumentTypeRepositoryState>(
              style: Theme.of(context).textTheme.bodyLarge,
              id: document.documentType,
            ),
          ).paddedSymmetrically(vertical: 16),
        ),
        Visibility(
          visible: document.correspondent != null,
          child: _DetailsItem(
            label: S.of(context).documentCorrespondentPropertyLabel,
            content: LabelText<Correspondent, CorrespondentRepositoryState>(
              style: Theme.of(context).textTheme.bodyLarge,
              id: document.correspondent,
            ),
          ).paddedSymmetrically(vertical: 16),
        ),
        Visibility(
          visible: document.storagePath != null,
          child: _DetailsItem(
            label: S.of(context).documentStoragePathPropertyLabel,
            content: StoragePathWidget(
              pathId: document.storagePath,
            ),
          ).paddedSymmetrically(vertical: 16),
        ),
        Visibility(
          visible: document.tags.isNotEmpty,
          child: _DetailsItem(
            label: S.of(context).documentTagsPropertyLabel,
            content: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TagsWidget(
                isClickable: widget.isLabelClickable,
                tagIds: document.tags,
              ),
            ),
          ).paddedSymmetrically(vertical: 16),
        ),
      ],
    );
  }

  ///
  /// Downloads file to temporary directory, from which it can then be shared.
  ///
  Future<void> _onShare(DocumentModel document) async {
    Uint8List documentBytes =
        await context.read<PaperlessDocumentsApi>().download(document);
    final dir = await getTemporaryDirectory();
    final String path = "${dir.path}/${document.originalFileName}";
    await File(path).writeAsBytes(documentBytes);
    Share.shareXFiles(
      [
        XFile(
          path,
          name: document.originalFileName,
          mimeType: "application/pdf",
          lastModified: document.modified,
        )
      ],
      subject: document.title,
    );
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

  Widget _buildSimilarDocumentsView() {
    return const SimilarDocumentsView();
  }
}

class _DetailsItem extends StatelessWidget {
  final String label;
  final Widget content;
  const _DetailsItem({
    Key? key,
    required this.label,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          content,
        ],
      ),
    );
  }

  _DetailsItem.text(
    String text, {
    required this.label,
    required BuildContext context,
  }) : content = Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        );
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
